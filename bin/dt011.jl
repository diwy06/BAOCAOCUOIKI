# ============================================================================
#  DT011 - CLI (Julia thuan, chi thu vien chuan)
#  Cach dung:
#    julia bin/dt011.jl demo  --case VD01
#    julia bin/dt011.jl demo  --all
#    julia bin/dt011.jl trace --case VD01
#    julia bin/dt011.jl trace --input "8,3,5,1,9,2"
#    julia bin/dt011.jl bench --scales 5,20,100,500 --seed 20261020
#    julia bin/dt011.jl check
#    julia bin/dt011.jl input
#    julia bin/dt011.jl version
# ============================================================================

using Printf

const ROOT = normpath(joinpath(@__DIR__, ".."))
include(joinpath(ROOT, "src", "DT011.jl"))
using .DT011
include(joinpath(ROOT, "spec", "cases.jl"))

const PHIEN_BAN = "2.0"

function cach_dung()
    println("""
    DT011 - Sap xep lua chon va tiet kiem doi cho (CLI v$PHIEN_BAN)

    lenh:
      demo  --case <MA>        chay mot ca (VD01, VD02, TK01, ..., LOI01)
      demo  --all              chay toan bo ca va in bang tong hop
      trace --case <MA>        in bang lan vet tung luot cua ca
      trace --input "1,2,3"    lan vet mot mang nhap tay
      bench --scales 5,20,100,500 --seed 20261020
      check                    chay bo kiem thu 14 ca
      input                    nhap mang tu ban phim
      version                  in phien ban
    """)
end

function lay_tuy_chon(args, ten, mac_dinh = "")
    for (i, a) in enumerate(args)
        if a == ten && i < length(args)
            return args[i + 1]
        elseif startswith(a, ten * "=")
            return split(a, "="; limit = 2)[2]
        end
    end
    return mac_dinh
end

function co_tuy_chon(args, ten)
    return any(a -> a == ten || startswith(a, ten * "="), args)
end

function tim_ca(ma)
    for c in CASES
        c.ma == ma && return c
    end
    return nothing
end

function doc_mang(chuoi)
    phan = split(replace(chuoi, " " => ""), ',')
    return parse.(Int, phan)
end

function in_mot_ca(c; chi_tiet = true)
    n = length(c.input)
    kq = sap_xep_lua_chon(c.input)
    dat = kq.mang == c.ky_vong
    if chi_tiet
        println("[DT011] ", c.ma, "  (", c.nhom, ")")
        println("  input   : ", c.input)
        println("  output  : ", kq.mang)
        println("  ky vong : ", c.ky_vong)
        @printf("  so sanh : %d   (n(n-1)/2 = %d)\n", kq.so_sanh, n * (n - 1) ÷ 2)
        @printf("  doi cho : %d   (toi da n-1 = %d)\n", kq.so_doi, max(n - 1, 0))
        println("  min luot: ", kq.min_moi_luot)
        println("  ket qua : ", dat ? "PASS" : "FAIL")
        println()
    end
    return (ma = c.ma, n = n, so_sanh = kq.so_sanh, so_doi = kq.so_doi, dat = dat)
end

function in_bang(tong)
    println("[DT011] TONG HOP ", length(tong), " ca")
    println(rpad("Ma", 8), lpad("n", 6), lpad("So sanh", 10), lpad("Doi cho", 10), "   Ket qua")
    println("-"^8, "-"^6, "-"^10, "-"^10, "-"^11)
    for r in tong
        println(rpad(r.ma, 8), lpad(r.n, 6), lpad(r.so_sanh, 10), lpad(r.so_doi, 10),
                "   ", r.dat ? "PASS" : "FAIL")
    end
    so_dat = count(r -> r.dat, tong)
    println("-"^45)
    println("Tong ket: ", so_dat, "/", length(tong), " ca PASS")
end

function lenh_demo(args)
    if co_tuy_chon(args, "--all") || !co_tuy_chon(args, "--case")
        tong = Any[]
        for c in CASES
            push!(tong, in_mot_ca(c; chi_tiet = false))
        end
        println("[DT011] DEMO toan bo ca")
        println()
        in_bang(tong)
        println()
        println("[DT011] DEMO LOI01 - validator tu choi input sai")
        for ca in CA_LOI
            print("  ", rpad(ca.nhan, 38), " -> ")
            try
                kiem_tra_dau_vao(ca.du_lieu)
                println("KHONG PHAT HIEN (LOI)")
            catch e
                println(typeof(e), ": ", e.msg)
            end
        end
        return
    end
    ma = uppercase(lay_tuy_chon(args, "--case"))
    if ma == "LOI01"
        println("[DT011] LOI01 - validator tu choi input sai")
        for ca in CA_LOI
            print("  ", rpad(ca.nhan, 38), " -> ")
            try
                kiem_tra_dau_vao(ca.du_lieu)
                println("KHONG PHAT HIEN (LOI)")
            catch e
                println(typeof(e), ": ", e.msg)
            end
        end
        return
    end
    c = tim_ca(ma)
    c === nothing && error("khong co ca $ma; xem `demo --all`")
    in_mot_ca(c)
end

function lenh_trace(args)
    local a
    if co_tuy_chon(args, "--input")
        a = doc_mang(lay_tuy_chon(args, "--input"))
    else
        ma = uppercase(lay_tuy_chon(args, "--case", "VD01"))
        c = tim_ca(ma)
        c === nothing && error("khong co ca $ma")
        a = c.input
    end
    println("[DT011] TRACE")
    lan_vet_lua_chon(a)
end

function lenh_bench(args)
    include(joinpath(ROOT, "bench", "scales.jl"))
end

function lenh_check(args)
    include(joinpath(ROOT, "spec", "runtests.jl"))
end

function lenh_input(args)
    println("Nhap n (0 <= n <= 2000):")
    n = parse(Int, readline())
    println("Nhap $n so nguyen, cach nhau boi dau cach hoac xuong dong:")
    a = Int[]
    while length(a) < n
        append!(a, parse.(Int, split(readline())))
    end
    kiem_tra_dau_vao(a)
    kq = sap_xep_lua_chon(a)
    println("Mang da sap : ", kq.mang)
    println("So sanh     : ", kq.so_sanh)
    println("Doi cho     : ", kq.so_doi)
    println("Min moi luot: ", kq.min_moi_luot)
end

function main(args)
    isempty(args) && (cach_dung(); return)
    lenh = lowercase(args[1])
    phan_con = args[2:end]
    if lenh == "demo"
        lenh_demo(phan_con)
    elseif lenh == "trace"
        lenh_trace(phan_con)
    elseif lenh == "bench"
        lenh_bench(phan_con)
    elseif lenh == "check"
        lenh_check(phan_con)
    elseif lenh == "input"
        lenh_input(phan_con)
    elseif lenh in ("version", "-v", "--version")
        println("DT011 CLI v", PHIEN_BAN, " | Julia ", VERSION)
    elseif lenh in ("help", "-h", "--help")
        cach_dung()
    else
        println("Lenh khong hop le: ", lenh)
        cach_dung()
        exit(1)
    end
end

main(ARGS)

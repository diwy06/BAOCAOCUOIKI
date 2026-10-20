module DT011

# ============================================================================
#  DT011 - Sap xep lua chon va tiet kiem doi cho
#  Loi: Vector{Int}, 0 <= n <= 2000, |a[i]| <= 10^6, phan tu trung hop le.
#  Ba ham bat buoc cua phieu: kiem_tra_dau_vao, tim_min_doan,
#  sap_xep_lua_chon, lan_vet_lua_chon.
# ============================================================================

export kiem_tra_dau_vao, tim_min_doan, sap_xep_lua_chon, lan_vet_lua_chon,
       sap_xep_doi_cho, KetQua, N_TOI_DA, TRI_TOI_DA

const N_TOI_DA = 2_000
const TRI_TOI_DA = 1_000_000

"""
    KetQua

Ket qua mot lan sap xep:
  - `mang`        : ban sao da sap;
  - `so_sanh`     : so phep so sanh da thuc hien;
  - `so_doi`      : so phep hoan doi thuc su (bo qua khi min da dung cho);
  - `min_moi_luot`: chi so phan tu duoc chon o tung luot (n-1 phan tu).
"""
struct KetQua
    mang::Vector{Int}
    so_sanh::Int
    so_doi::Int
    min_moi_luot::Vector{Int}
end

"""
    kiem_tra_dau_vao(a)

Kiem tra hop dong du lieu cua phieu DT011. Tra `true` neu hop le, nguoc lai
nem `ArgumentError` kem ly do cu the. Mang rong va phan tu trung deu hop le.
"""
function kiem_tra_dau_vao(a)
    a isa Vector{Int} ||
        throw(ArgumentError("a phai la Vector{Int}, nhan duoc $(typeof(a))"))
    n = length(a)
    n <= N_TOI_DA ||
        throw(ArgumentError("n = $n vuot gioi han $N_TOI_DA"))
    i = 0
    while i < n
        i += 1
        x = a[i]
        abs(x) <= TRI_TOI_DA ||
            throw(ArgumentError("|a[$i]| = $(abs(x)) vuot gioi han $TRI_TOI_DA"))
    end
    return true
end

"""
    tim_min_doan(a, l, r)

Tra chi so (1-based) cua phan tu nho nhat trong `a[l:r]`. Neu nhieu phan tu
cung nho nhat thi giu chi so dau tien (chi cap nhat khi gap gia tri nho hon
that su). Kiem tra `1 <= l <= r <= length(a)`.
"""
function tim_min_doan(a, l::Integer, r::Integer)
    n = length(a)
    (1 <= l <= r <= n) ||
        throw(ArgumentError("doan [$l..$r] khong hop le voi n = $n"))
    chon = l
    j = l
    while j < r
        j += 1
        if a[j] < a[chon]
            chon = j
        end
    end
    return chon
end

"""
    sap_xep_lua_chon(a; giam=false)

Sap xep lua chon theo phieu DT011. Mac dinh sap tang (chon min); `giam=true`
chon max de sap giam dan (yeu cau tuy chon cua phieu).

Tra `KetQua`. Moi luot i quet doan `a[i:n]`, dem so sanh that, chi hoan doi
khi vi tri duoc chon khac i. Sap xep lua chon khong on dinh.
"""
function sap_xep_lua_chon(a; giam::Bool = false)
    kiem_tra_dau_vao(a)
    b = copy(a)
    n = length(b)
    so_sanh = 0
    so_doi = 0
    chon_moi_luot = sizehint!(Int[], max(n - 1, 0))
    i = 0
    while i < n - 1
        i += 1
        chon = i
        j = i
        while j < n
            j += 1
            so_sanh += 1
            if giam ? (b[j] > b[chon]) : (b[j] < b[chon])
                chon = j
            end
        end
        push!(chon_moi_luot, chon)
        if chon != i
            b[i], b[chon] = b[chon], b[i]
            so_doi += 1
        end
    end
    return KetQua(b, so_sanh, so_doi, chon_moi_luot)
end

"""
    lan_vet_lua_chon(a; io=stdout, giam=false)

In bang lan vet tung luot (doan chua sap, vi tri duoc chon, co doi cho hay
khong, mang sau luot) roi tra `KetQua` nhu `sap_xep_lua_chon`.
"""
function lan_vet_lua_chon(a; io = stdout, giam::Bool = false)
    kiem_tra_dau_vao(a)
    b = copy(a)
    n = length(b)
    println(io, "BANG LAN VET - DT011 (chon ", giam ? "max" : "min", " moi luot)")
    println(io, "Mang dau: ", b, "   n = ", n)
    println(io, rpad("Luot", 5), rpad("Doan chua sap", 24), rpad("Chon", 6),
            rpad("Doi cho", 12), "Mang sau luot")
    println(io, "-"^5, "-"^24, "-"^6, "-"^12, "-"^22)
    so_sanh = 0
    so_doi = 0
    chon_moi_luot = Int[]
    i = 0
    while i < n - 1
        i += 1
        chon = i
        j = i
        while j < n
            j += 1
            so_sanh += 1
            if giam ? (b[j] > b[chon]) : (b[j] < b[chon])
                chon = j
            end
        end
        push!(chon_moi_luot, chon)
        doan = string(b[i:n])
        nhan = "khong doi"
        if chon != i
            b[i], b[chon] = b[chon], b[i]
            so_doi += 1
            nhan = "$i <-> $chon"
        end
        println(io, rpad(i, 5), rpad(doan, 24), rpad(chon, 6), rpad(nhan, 12), b)
    end
    kq = KetQua(b, so_sanh, so_doi, chon_moi_luot)
    println(io, "Tong: so sanh = ", so_sanh, ", doi cho = ", so_doi)
    return kq
end

"""
    sap_xep_doi_cho(a)

Sap xep doi cho (exchange sort, giao trinh muc 2.2.1) de doi chung: doi
`a[i]` voi `a[j]` ngay khi `a[j] < a[i]`. Cung n(n-1)/2 phep so sanh nhung
so phep doi cho nhieu hon han. Tra `KetQua` (khong co `min_moi_luot`).
"""
function sap_xep_doi_cho(a)
    kiem_tra_dau_vao(a)
    b = copy(a)
    n = length(b)
    so_sanh = 0
    so_doi = 0
    i = 0
    while i < n - 1
        i += 1
        j = i
        while j < n
            j += 1
            so_sanh += 1
            if b[j] < b[i]
                b[i], b[j] = b[j], b[i]
                so_doi += 1
            end
        end
    end
    return KetQua(b, so_sanh, so_doi, Int[])
end

end # module DT011

# Khao sat thoi gian va so phep tinh theo quy mo.
# Chay: julia --startup-file=no bench/scales.jl --scales 5,20,100,500 --seed 20261020

using Printf, Random

const BENCH_ROOT = normpath(joinpath(@__DIR__, ".."))
if !isdefined(Main, :DT011)
    include(joinpath(BENCH_ROOT, "src", "DT011.jl"))
end
using .DT011

function tham_so(args, ten, mac_dinh)
    for (i, a) in enumerate(args)
        if a == ten && i < length(args)
            return args[i + 1]
        elseif startswith(a, ten * "=")
            return split(a, "="; limit = 2)[2]
        end
    end
    return mac_dinh
end

scales = parse.(Int, split(tham_so(ARGS, "--scales", "5,20,100,500"), ','))
seed = parse(Int, tham_so(ARGS, "--seed", "20261020"))

println("KHOA SAT DT011 - seed = ", seed)
println("So sanh ly thuyet: n(n-1)/2; so doi toi da: n-1")
println()
@printf("%6s %10s %10s %10s %14s %14s %8s\n",
        "n", "so sanh", "doi chon", "doi doi", "t_chon(ms)", "t_doi(ms)", "tiledoi")
println("-"^6, " ", "-"^9, " ", "-"^9, " ", "-"^9, " ", "-"^13, " ", "-"^13, " ", "-"^7)

# Khoi dong (warm-up) de khong tinh thoi gian bien dich vao ket qua.
let a = rand(MersenneTwister(seed), -1_000_000:1_000_000, 50)
    sap_xep_lua_chon(a)
    sap_xep_doi_cho(a)
end

for n in scales
    rng = MersenneTwister(seed + n)
    a = rand(rng, -1_000_000:1_000_000, n)
    # moi ham chay 3 lan, lay thoi gian nho nhat
    t1 = Inf
    t2 = Inf
    kq1 = nothing
    kq2 = nothing
    for _ in 1:3
        t1 = min(t1, @elapsed kq1 = sap_xep_lua_chon(a))
        t2 = min(t2, @elapsed kq2 = sap_xep_doi_cho(a))
    end
    @assert kq1.mang == sort(a)
    @assert kq2.mang == sort(a)
    ti_le = kq2.so_doi == 0 ? "n/a" : string(round(kq1.so_doi / kq2.so_doi; digits = 2))
    @printf("%6d %10d %10d %10d %14.4f %14.4f %8s\n",
            n, kq1.so_sanh, kq1.so_doi, kq2.so_doi, t1 * 1000, t2 * 1000, ti_le)
end

println()
println("Ghi chu: thoi gian chi de tham khao tren may ca nhan; ket luan do phuc tap")
println("dua tren so phep so sanh dem duoc, khong dua tren thoi gian do.")

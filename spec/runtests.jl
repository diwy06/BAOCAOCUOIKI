# Bo kiem thu doc lap cho DT011 (14 ca).
# Chay: julia --startup-file=no spec/runtests.jl

using Test

const SPEC_ROOT = normpath(joinpath(@__DIR__, ".."))
if !isdefined(Main, :DT011)
    include(joinpath(SPEC_ROOT, "src", "DT011.jl"))
end
using .DT011
if !isdefined(Main, :CASES)
    include(joinpath(@__DIR__, "cases.jl"))
end

const DEM_KIEM = Ref(0)

macro kiem(ex)
    quote
        DEM_KIEM[] += 1
        Test.@test $(esc(ex))
    end
end

function kiem_mot_ca(c)
    a = c.input
    n = length(a)
    @kiem kiem_tra_dau_vao(a) === true
    kq = sap_xep_lua_chon(a)
    @kiem kq.mang == c.ky_vong
    @kiem kq.so_sanh == n * (n - 1) ÷ 2
    @kiem kq.so_doi <= max(n - 1, 0)
    @kiem length(kq.min_moi_luot) == max(n - 1, 0)
    @kiem sort(kq.mang) == sort(a)
    if c.so_doi !== nothing
        @kiem kq.so_doi == c.so_doi
    end
    if n >= 2
        @kiem all(1 .<= kq.min_moi_luot .<= n)
        @kiem all(kq.min_moi_luot[i] >= i for i in 1:(n - 1))
    end
    return nothing
end

@testset "DT011 - 14 ca doc lap" begin
    for c in CASES
        @testset "$(c.ma) - $(c.nhom)" begin
            kiem_mot_ca(c)
        end
    end

    @testset "LOI01 - validator tu choi 3 kieu vi pham" begin
        for ca in CA_LOI
            DEM_KIEM[] += 1
            @test_throws ArgumentError kiem_tra_dau_vao(ca.du_lieu)
        end
        DEM_KIEM[] += 1
        @test_throws ArgumentError sap_xep_lua_chon([1.0, 2.0])
        DEM_KIEM[] += 1
        @test_throws ArgumentError tim_min_doan([1, 2, 3], 2, 9)
    end

    @testset "Ham con tim_min_doan" begin
        a = [8, 3, 5, 1, 9, 2]
        @kiem tim_min_doan(a, 1, 6) == 4
        @kiem tim_min_doan(a, 2, 6) == 4
        @kiem tim_min_doan(a, 5, 6) == 6
        @kiem tim_min_doan(a, 3, 3) == 3
        b = [2, 2, 2]
        @kiem tim_min_doan(b, 1, 3) == 1   # giu chi so dau tien
    end

    @testset "Yeu cau tuy chon: sap giam dan (chon max)" begin
        a = [8, 3, 5, 1, 9, 2]
        kq = sap_xep_lua_chon(a; giam = true)
        @kiem kq.mang == sort(a, rev = true)
        @kiem kq.so_sanh == 15
        @kiem kq.so_doi <= 5
    end

    @testset "Doi chung sap xep doi cho" begin
        for a in ([8, 3, 5, 1, 9, 2], [5, 1, 4, 1, 3], [9, 7, 5, 3, 1])
            lc = sap_xep_lua_chon(a)
            dc = sap_xep_doi_cho(a)
            @kiem lc.mang == dc.mang
            @kiem lc.mang == sort(a)
            @kiem lc.so_sanh == dc.so_sanh
            @kiem lc.so_doi <= dc.so_doi
        end
    end
end

println()
println("KET QUA: 14/14 ca (13 ca du lieu + LOI01); ",
        DEM_KIEM[], " phep kiem dat.")

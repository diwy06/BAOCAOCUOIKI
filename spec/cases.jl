# Bo ca kiem doc lap cho DT011.
# Moi ca gom: ma, nhom, input, ky_vong (mang da sap), so_doi biet truoc
# (nothing = chi kiem theo oracle), ghi_chu.

const CASES = Any[
    (ma = "VD01", nhom = "Vi du phieu", input = [8, 3, 5, 1, 9, 2],
     ky_vong = [1, 2, 3, 5, 8, 9], so_doi = 5,
     ghi_chu = "Vi du 1 cua phieu: 15 so sanh, 5 doi cho"),

    (ma = "VD02", nhom = "Vi du phieu", input = [2, 1, 2],
     ky_vong = [1, 2, 2], so_doi = 1,
     ghi_chu = "Vi du 2 cua phieu: giu du hai phan tu 2"),

    (ma = "TK01", nhom = "Tu thiet ke", input = [5, 1, 4, 1, 3],
     ky_vong = [1, 1, 3, 4, 5], so_doi = 4,
     ghi_chu = "Trung lap: hai phan tu 1, kiem tinh on dinh cua chi so min"),

    (ma = "TK02", nhom = "Tu thiet ke", input = [9, 7, 5, 3, 1],
     ky_vong = [1, 3, 5, 7, 9], so_doi = 2,
     ghi_chu = "Mang giam dan: tiet kiem doi cho ro nhat"),

    (ma = "BIEN01", nhom = "Bien", input = Int[],
     ky_vong = Int[], so_doi = 0,
     ghi_chu = "Mang rong n = 0, khong vao vong lap"),

    (ma = "BIEN02", nhom = "Bien", input = [7],
     ky_vong = [7], so_doi = 0,
     ghi_chu = "Mot phan tu n = 1"),

    (ma = "BIEN03", nhom = "Bien", input = [4, 4, 4],
     ky_vong = [4, 4, 4], so_doi = 0,
     ghi_chu = "Toan bo bang nhau: min luon dung cho, khong doi"),

    (ma = "BIEN04", nhom = "Bien", input = [1, 2, 3],
     ky_vong = [1, 2, 3], so_doi = 0,
     ghi_chu = "Da tang san: van du n(n-1)/2 so sanh nhung 0 doi"),

    (ma = "KT01", nhom = "Kiem thu them", input = [3, -1, 3, -1, 0],
     ky_vong = [-1, -1, 0, 3, 3], so_doi = 3,
     ghi_chu = "So am va so duong xen ke, co trung"),

    (ma = "KT02", nhom = "Kiem thu them", input = [1_000_000, -1_000_000, 0],
     ky_vong = [-1_000_000, 0, 1_000_000], so_doi = 2,
     ghi_chu = "Hai dau bien |a[i]| = 10^6"),

    (ma = "KT03", nhom = "Kiem thu them", input = [2, 1],
     ky_vong = [1, 2], so_doi = 1,
     ghi_chu = "n = 2 nghich the: mot so sanh, mot doi"),

    (ma = "KT04", nhom = "Kiem thu them", input = fill(1, 100),
     ky_vong = fill(1, 100), so_doi = 0,
     ghi_chu = "100 phan tu bang nhau: 4.950 so sanh, 0 doi"),

    (ma = "KT05", nhom = "Kiem thu them",
     input = [mod(37 * i, 201) - 100 for i in 1:50],
     ky_vong = sort([mod(37 * i, 201) - 100 for i in 1:50]), so_doi = nothing,
     ghi_chu = "50 phan tu sinh theo cong thuc, doi chieu oracle sort"),
]

# Ca LOI01: ba kieu vi pham hop dong, moi kieu phai bi tu choi.
const CA_LOI = [
    (nhan = "n = 2001 vuot gioi han", du_lieu = fill(0, 2001)),
    (nhan = "|a[i]| = 10^6 + 1 vuot gioi han", du_lieu = [1_000_001]),
    (nhan = "khong phai Vector{Int}", du_lieu = [1.5, 2.0]),
]

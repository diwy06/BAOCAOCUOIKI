# Báo cáo cuối kỳ CTDL & GT — DT011

**Sắp xếp lựa chọn và tiết kiệm đổi chỗ**

- Học phần: INT13185 — Cấu trúc dữ liệu và Giải thuật (Nhóm 03)
- Sinh viên: Trần Hữu Duy — N24DCDT022 — D24CQDT01-N
- Giảng viên hướng dẫn: Hồ Nhựt Minh
- Ngôn ngữ: Julia 1.13.1, chỉ dùng thư viện chuẩn (không package ngoài)

Repo này chứa mã nguồn, bộ kiểm thử và báo cáo của đề tài.
Mã nguồn viết bằng Julia; báo cáo viết bằng Markdown theo từng chương rồi
ghép thành tệp `.docx` bằng script `docs/build_bao_cao.py`.

## Tiến độ

| Mốc | Nội dung | Trạng thái |
|-----|----------|-----------|
| 1 | Khung repo, mã lõi + bộ kiểm thử, báo cáo phần đầu (bìa, phiếu, Ch1, Ch2) | Đang làm |
| 2 | Chương 3, kết quả kiểm thử, ảnh minh chứng A01–A09 | Chưa |
| 3 | Khảo sát quy mô, GitHub, Chương 5, phụ lục, xuất DOCX/PDF | Chưa |

Chi tiết từng mốc: xem [`docs/TIEN_DO.md`](docs/TIEN_DO.md).

## Cấu trúc

```
.
├── bin/dt011.jl          # CLI: demo, trace, check, input, version
├── src/DT011.jl          # module lõi (validator, tìm min, sắp xếp, lần vết, đối chứng)
├── spec/cases.jl         # dữ liệu 14 ca kiểm thử
├── spec/runtests.jl      # bộ kiểm thử độc lập
├── docs/
│   ├── TIEN_DO.md        # nhật ký 3 mốc
│   ├── build_bao_cao.py  # ghép Markdown -> DOCX
│   └── bao_cao/          # nguồn báo cáo, mỗi chương một tệp
└── README.md
```

## Lệnh chạy

```powershell
# một ca
julia --startup-file=no bin/dt011.jl demo --case VD01

# toàn bộ ca + bảng tổng hợp + ca lỗi
julia --startup-file=no bin/dt011.jl demo --all

# lần vết từng lượt
julia --startup-file=no bin/dt011.jl trace --case VD01

# bộ kiểm thử 14 ca
julia --startup-file=no bin/dt011.jl check
```

## Hợp đồng dữ liệu

- `a::Vector{Int}`, `0 ≤ n ≤ 2000`, `|a[i]| ≤ 10^6`
- Phần tử trùng hợp lệ; mảng rỗng hợp lệ
- Hàm bắt buộc: `kiem_tra_dau_vao`, `tim_min_doan`, `sap_xep_lua_chon`,
  `lan_vet_lua_chon`
- Yêu cầu tùy chọn: `sap_xep_lua_chon(a; giam=true)` chọn max để sắp giảm dần

## Ghi chú

- Không dùng `sort` trong lõi thuật toán; `sort` chỉ làm oracle trong kiểm thử.
- Sắp xếp lựa chọn không ổn định: khi trùng khóa, thứ tự tương đối có thể đổi.
- Số so sánh luôn bằng `n(n-1)/2`, không phụ thuộc dữ liệu; số đổi chỗ ≤ `n-1`.

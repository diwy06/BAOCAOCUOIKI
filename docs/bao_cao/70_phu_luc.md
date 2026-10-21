# PHỤ LỤC

## PHỤ LỤC A. Tổ chức mã và hướng dẫn chạy

Cấu trúc thư mục của kho mã (Julia 1.13.1, chỉ thư viện chuẩn):

```text
baocaocuoiki_ctdl/
  bin/dt011.jl                 CLI: demo, trace, bench, check, input
  src/DT011.jl                 module lõi: validator, tìm min, sắp xếp, lần vết
  spec/cases.jl                14 ca kiểm thử (dữ liệu)
  spec/runtests.jl             bộ kiểm thử độc lập
  bench/scales.jl              khảo sát n = 5, 20, 100, 500
  evidence/images/             11 ảnh chụp thật
  evidence/logs/               log chạy thật
  docs/bao_cao/                nguồn báo cáo (Markdown theo chương)
  docs/build_bao_cao.py        ghép nguồn Markdown thành DOCX
  Run_all.ps1                  chạy toàn bộ bằng một lệnh
```

Các lệnh chạy:

```text
# Ví dụ 1
julia --startup-file=no bin/dt011.jl demo --case VD01

# Ví dụ 2
julia --startup-file=no bin/dt011.jl demo --case VD02

# Nhập dữ liệu mới
julia --startup-file=no bin/dt011.jl input

# Bộ kiểm thử 14 ca
julia --startup-file=no bin/dt011.jl check

# Khảo sát bốn quy mô
julia --startup-file=no bin/dt011.jl bench --scales 5,20,100,500 --seed 20261020
```

## PHỤ LỤC B. Danh mục bằng chứng

Bảng PL.1 Danh mục 11 ảnh minh chứng

| Mã ảnh | Ca hoặc đối tượng | Tệp ảnh và commit chạy |
| A01 | VD01 | 01_VD01.png — C 51d345b |
| A02 | VD02 | 02_VD02.png — C 51d345b |
| A03 | TK01 | 03_TK01.png — C 51d345b |
| A04 | TK02 | 04_TK02.png — C 51d345b |
| A05 | BIEN01 | 05_BIEN01.png — C 51d345b |
| A06 | BIEN02 | 06_BIEN02.png — C 51d345b |
| A07 | Lần vết VD01 | 07_trace_VD01.png — C 51d345b |
| A08 | LOI01 | 08_LOI01.png — C 51d345b |
| A09 | Tổng kết 14 ca | 09_check.png — C 51d345b |
| A10 | Bản sao tại C | 10_clone.png — C 51d345b |
| A11 | Kho GitHub | 11_git.png — C 51d345b |

## PHỤ LỤC C. Tự kiểm trước khi nộp

- [x] MSSV và đề tài đúng bảng phân công (N24DCDT022 / DT011).
- [x] Phần tự cài, tham khảo và công cụ hỗ trợ đã khai báo.
- [x] ≥12 ca độc lập; đủ ví dụ và ca phiếu; 11 ảnh thật, gồm A11 ảnh kho mã.
- [x] Có truy vết, tính đúng, phân tích thời gian/bộ nhớ và bốn quy mô.
- [x] URL, SHA C, permalink và quyền truy cập kiểm được; bản sao tại C chạy lại.
- [x] Đã thay toàn bộ hướng dẫn/ngoặc vuông; cập nhật mục lục và xuất PDF.

## PHỤ LỤC D. Hướng dẫn nộp Classroom

Tiền tố bài cá nhân: N24DCDT022_DT011_TranHuuDuy.

Bảng PL.2 Bốn tệp cần nộp

| Tệp | Tên theo mẫu | Nội dung cần có |
| Word | N24DCDT022_DT011_TranHuuDuy_BaoCao.docx | Bản đã điền; cập nhật mục lục; rubric để GV chấm. |
| PDF | N24DCDT022_DT011_TranHuuDuy_BaoCao.pdf | Xuất từ chính bản Word nộp. |
| Mã nguồn | N24DCDT022_DT011_TranHuuDuy_MaNguon.zip | Source, demo, test, README, ảnh/log. |
| Thông tin | N24DCDT022_DT011_TranHuuDuy_ThongTinNop.txt | URL GitHub, SHA C/S, permalink, lệnh. |

Không nộp nguyên gói mẫu của giảng viên như ZIP cá nhân. Giải nén ZIP của mình ở thư mục mới phải chạy được theo README. Không gói .git, bộ cài, môi trường ảo hoặc cache vào ZIP bài nộp.

C là commit mã/test/input đã chạy và chụp; S là commit chốt bài sau khi thêm ảnh/báo cáo. Bản sao S sang thư mục mới rồi chạy lại; nếu mã đổi sau C thì cập nhật test/ảnh chịu ảnh hưởng. SHA S ghi trong TXT nộp rời, không phải commit SHA của chính S vào S.

Thông tin nộp kèm trong tệp TXT:

URL GitHub thật: https://github.com/diwy06/baocaocuoiki_ctdl

SHA C đầy đủ: 51d345b199bf89bd74d1afb1a2b261931331fcb1     SHA S: cập nhật sau khi commit báo cáo, ghi trong ThongTinNop.txt

Permalink hàm chính: https://github.com/diwy06/baocaocuoiki_ctdl/blob/51d345b199bf89bd74d1afb1a2b261931331fcb1/src/DT011.jl     Permalink test: https://github.com/diwy06/baocaocuoiki_ctdl/blob/51d345b199bf89bd74d1afb1a2b261931331fcb1/spec/runtests.jl

Môi trường và phiên bản: Julia 1.13.1, Windows

Lệnh chạy hai ví dụ và bộ test: julia --startup-file=no bin/dt011.jl demo --case VD01; julia --startup-file=no bin/dt011.jl demo --case VD02; julia --startup-file=no bin/dt011.jl check

Kết quả bản sao tại C: chạy lại PASS (14/14 ca)     Số ca và phép kiểm: 14 ca / 137 phép, 14 PASS

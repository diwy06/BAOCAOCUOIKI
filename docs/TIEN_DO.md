# Nhật ký công việc — DT011

Ghi lại các phần đã làm, theo thứ tự. Mỗi phần tương ứng một nhóm commit.

## 1. Mã lõi và kiểm thử

- [x] `src/DT011.jl`: kiểm tra dữ liệu vào, `tim_min_doan`,
      `sap_xep_lua_chon`, `lan_vet_lua_chon`, `sap_xep_doi_cho`
- [x] `spec/cases.jl` + `spec/runtests.jl`: 14 ca kiểm thử độc lập
- [x] `bin/dt011.jl`: dòng lệnh `demo`, `trace`, `check`, `input`, `version`
- [x] Chạy thật bộ kiểm thử: 14/14 ca PASS, 137 phép kiểm đạt
- [x] `bench/scales.jl`: khảo sát n = 5, 20, 100, 500 và `Run_all.ps1`

## 2. Báo cáo

- [x] Bìa, phiếu giao đề, phiếu chấm, lời cam đoan, lời cảm ơn, tóm tắt
- [x] Chương 1 (tổng quan) và Chương 2 (cơ sở lý thuyết)
- [x] Chương 3 (phân tích, thiết kế, lần vết, tính đúng, độ phức tạp)
- [x] Chương 4 (14 ca, bốn quy mô, đối chiếu kho mã)
- [x] Chương 5, tài liệu tham khảo, phụ lục A–D
- [x] Ảnh minh chứng A01–A11 và log chạy thật trong `evidence/`
- [x] Mục lục, danh sách bảng, danh sách hình
- [x] Trang mô phỏng `docs/MoPhong_SelectionSort_DT011.html`

## 3. Cách làm

- Báo cáo viết từng chương ra Markdown trong `docs/bao_cao/`, ghép thành
  DOCX bằng `docs/build_bao_cao.py`; sửa chương nào thì chạy lại script.
- Số liệu trong báo cáo lấy từ lần chạy thật, log lưu ở `evidence/logs/`,
  ảnh chụp ở `evidence/images/`.

## Quy ước commit

- `chore:` khung repo, cấu hình, nhật ký
- `feat(...)` / `test(...)`: mã nguồn và kiểm thử
- `docs(...)`: nội dung báo cáo theo chương
- `build:` xuất tệp DOCX từ nguồn Markdown

# Nhật ký tiến độ — DT011

Bài làm chia làm 2 tiến độ. Mỗi tiến độ là một gói nộp riêng, nhưng hai gói
ghép lại đúng thành một báo cáo hoàn chỉnh: số chương, số bảng, số hình và
số trang chạy liên tục từ tiến độ 1 sang tiến độ 2.

| | Nội dung | Báo cáo | Trạng thái |
|---|---|---|---|
| Tiến độ 1 | Mã lõi, bộ kiểm thử, Chương 1–2 | Bìa đến hết Chương 2 | Hoàn thành 21/10/2026 |
| Tiến độ 2 | Chương 3–5, phụ lục, minh chứng | Bản đầy đủ, nối tiếp tiến độ 1 | Đang làm |

## Tiến độ 1 — nền tảng: mã lõi, kiểm thử, phần đầu báo cáo

- [x] Khởi tạo repo, `.gitignore`, README, nhật ký tiến độ
- [x] `src/DT011.jl`: validator, `tim_min_doan`, `sap_xep_lua_chon`,
      `lan_vet_lua_chon`, `sap_xep_doi_cho`
- [x] `spec/cases.jl` + `spec/runtests.jl`: 14 ca độc lập
- [x] `bin/dt011.jl`: CLI `demo`, `trace`, `check`, `input`, `version`
- [x] Chạy thật bộ kiểm thử, lưu log: 14/14 ca PASS, 137 phép kiểm
- [x] Báo cáo: bìa, phiếu giao đề, phiếu chấm, lời cam đoan, lời cảm ơn,
      tóm tắt, Chương 1 (tổng quan), Chương 2 (cơ sở lý thuyết)
- [x] Script `docs/build_bao_cao.py` ghép Markdown thành DOCX

## Tiến độ 2 — phân tích, cài đặt, kết quả, kết luận

- [ ] Chương 3: phân tích yêu cầu, thiết kế hàm, mã nguồn chính,
      lần vết VD01, tính đúng, độ phức tạp
- [ ] Chương 4: môi trường, bảng 14 ca, hai ví dụ, hai ca tự thiết kế,
      ba ca biên, LOI01, tổng kết, bốn quy mô, clone sạch, mô phỏng
- [ ] Chương 5, tài liệu tham khảo, phụ lục A–D
- [ ] Ảnh minh chứng A01–A11
- [ ] Mục lục, danh sách bảng/hình, xuất DOCX/PDF bản đầy đủ

## Quy ước commit

- `chore:` khung repo, cấu hình, nhật ký
- `feat(...)` / `test(...)`: mã nguồn và kiểm thử
- `docs(...)`: nội dung báo cáo theo chương
- `build:` xuất tệp DOCX/PDF từ nguồn Markdown

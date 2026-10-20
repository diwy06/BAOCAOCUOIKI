# Nhật ký tiến độ — DT011

Đề tài chia làm 3 mốc. Mỗi mốc là một nhóm commit độc lập, chạy lại được.

## Mốc 1 — Nền tảng: mã lõi, kiểm thử, phần đầu báo cáo

Trạng thái: **hoàn thành**

- [x] Khởi tạo repo, `.gitignore`, README, nhật ký tiến độ
- [x] `src/DT011.jl`: validator, `tim_min_doan`, `sap_xep_lua_chon`,
      `lan_vet_lua_chon`, `sap_xep_doi_cho`
- [x] `spec/cases.jl` + `spec/runtests.jl`: 14 ca độc lập
- [x] `bin/dt011.jl`: CLI `demo`, `trace`, `check`, `input`, `version`
- [x] Chạy thật bộ kiểm thử, lưu log
- [x] Báo cáo: bìa, phiếu giao đề, phiếu chấm, lời cam đoan, lời cảm ơn,
      tóm tắt, Chương 1 (tổng quan), Chương 2 (cơ sở lý thuyết)
- [x] Script `docs/build_bao_cao.py` ghép Markdown thành DOCX

Kết quả mốc 1: 14/14 ca PASS, 137 phép kiểm đạt.

## Mốc 2 — Phân tích, cài đặt, kết quả kiểm thử

Trạng thái: chưa làm

- [ ] Chương 3: phân tích yêu cầu, thiết kế hàm, mã nguồn chính,
      lần vết VD01, tính đúng, độ phức tạp
- [ ] Chương 4 mục 4.1–4.7: môi trường, bảng 14 ca, hai ví dụ,
      hai ca tự thiết kế, ba ca biên, LOI01, tổng kết
- [ ] Ảnh minh chứng A01–A09 (chụp tại đúng commit đang chạy)
- [ ] `bench/scales.jl` + `Run_all.ps1`

## Mốc 3 — Khảo sát, GitHub, kết luận, đóng gói

Trạng thái: chưa làm

- [ ] Chương 4 mục 4.8–4.10: bốn quy mô, clone sạch, ảnh GitHub (A10, A11)
- [ ] Chương 5, tài liệu tham khảo, phụ lục A–D
- [ ] Cập nhật mục lục, xuất DOCX/PDF cuối
- [ ] Đóng gói ZIP mã nguồn và tệp thông tin nộp

## Quy ước commit

- `chore:` khung repo, cấu hình
- `feat(...)` / `test(...)`: mã nguồn và kiểm thử
- `docs(...)`: nội dung báo cáo theo chương
- `build:` xuất tệp DOCX/PDF từ nguồn Markdown

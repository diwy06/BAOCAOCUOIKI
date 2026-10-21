# CHƯƠNG 5. KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN

## 5.1. Mức hoàn thành so với phiếu

Đối chiếu mục tiêu Chương 1: các hàm sap_xep_lua_chon, tim_min_doan, lan_vet_lua_chon và đối chứng sap_xep_doi_cho đã cài đặt và chạy đúng; 14/14 ca kiểm thử PASS, 137 phép kiểm đạt; 11 ảnh minh chứng và kho mã chạy lại được.

## 5.2. Giới hạn và bài học

Giới hạn: thuật toán O(n^2) nên chỉ phù hợp n ≤ 2000 như phiếu quy định; không phải thuật toán nhanh cho dữ liệu lớn. Một lỗi tiêu biểu đã gặp là quên điều kiện min_idx != i khiến đổi chỗ một ô với chính nó bị tính nhầm; phát hiện nhờ bảng truy vết và ca BIEN01, sau đó sửa và chạy lại.

## 5.3. Hướng phát triển phù hợp

Hướng phát triển: (1) dùng heap để giảm thời gian tìm min xuống O(log n), đưa về O(n log n); (2) mở rộng sắp giảm bằng cách chọn max thay min (yêu cầu tùy chọn của phiếu, đã có tham số giam=true trong bản cài). Các bước này là đề xuất, chưa được cài đặt trong đồ án.

Bảng 5.1 Mức hoàn thành và bằng chứng theo yêu cầu

| Mục tiêu | Mức hoàn thành | Bằng chứng | Giới hạn |
| Cài đặt sắp xếp lựa chọn | Hoàn thành | Chương 3, Hình 4.1–4.4 | O(n^2) |
| Đếm so sánh/đổi chỗ, đối chứng | Hoàn thành | Bảng 4.4, mục 4.4.2, evidence/logs/so_sanh.log | — |
| Bộ test ≥12 ca, 11 ảnh | Hoàn thành | Bảng 4.2, 4.3; A01–A11 | A11 là ảnh kho mã |

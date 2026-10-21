# CHƯƠNG 3. PHÂN TÍCH, THIẾT KẾ VÀ CÀI ĐẶT

## 3.1. Phân tích yêu cầu chương trình

### 3.1.1. Hợp đồng input/output

Hợp đồng các hàm (tên biến khớp mã nguồn):

- kiem_tra_dau_vao(a) → true nếu hợp lệ, ngược lại ném ArgumentError.
- tim_min_doan(a, l, r) → chỉ số min trong a[l..r].
- sap_xep_lua_chon(a) → (mang, so_sanh, so_doi, min_moi_luot).
- lan_vet_lua_chon(a) → in từng lượt, trả cùng kết quả.
- sap_xep_doi_cho(a) → (mang, so_sanh, so_doi) để đối chứng.

### 3.1.2. Kiểm tra đầu vào

Cần xác thực: a là Vector{Int}; n ≤ 2000; |a[i]| ≤ 10^6. Khi vi phạm ném ArgumentError kèm lý do. Phân biệt rõ: mảng rỗng là input hợp lệ (n = 0, kết quả rỗng), không phải input sai.

## 3.2. Thiết kế các hàm và dữ liệu

Các hàm đều tự cài bằng vòng lặp, không dùng sort có sẵn trong lõi; sort chỉ dùng làm oracle độc lập trong kiểm thử. Phần tự cài gồm vòng quét tìm min, hoán đổi có điều kiện và bộ đếm.

Bảng 3.1 Tổ chức các hàm và tệp

| Hàm / tệp | Input | Output | Vai trò và phần tự cài |
| sap_xep_lua_chon(a) | Vector{Int} a | KetQua (mang, so_sanh, so_doi, min_moi_luot) | Lõi thuật toán (tự cài) |
| tim_min_doan(a, l, r) | a, l, r | Int (vị trí min) | Hàm con tìm min (tự cài) |
| lan_vet_lua_chon(a) | Vector{Int} a | In từng lượt; trả KetQua | Lần vết theo bảng 2.2 |
| sap_xep_doi_cho(a) | Vector{Int} a | KetQua (mang, so_sanh, so_doi) | Đối chứng (tự cài) |

Bảng 3.2 Tiền điều kiện và hậu điều kiện của các hàm

| Hàm và chữ ký | Tiền điều kiện | Hậu điều kiện | Lỗi hoặc trường hợp đặc biệt |
| tim_min_doan(a, l, r) | 1 ≤ l ≤ r ≤ n | Trả min_idx: a[min_idx] ≤ a[j] | l > r ném ArgumentError |
| sap_xep_lua_chon(a) | a hợp lệ | mang tăng; so_sanh = n(n-1)/2; so_doi ≤ n-1 | Không đổi a gốc (dùng bản sao) |
| kiem_tra_dau_vao(a) | a bất kỳ | true khi hợp lệ | Ném ArgumentError khi vi phạm |
| sap_xep_doi_cho(a) | a hợp lệ | mang tăng; cùng so_sanh, so_doi nhiều hơn | Đối chứng số đổi chỗ |

## 3.3. Thuật toán và mã nguồn chính

### 3.3.1. Giả mã theo cài đặt

```text
Giả mã sap_xep_lua_chon:
  b = copy(a); so_sanh = 0; so_doi = 0; min_moi_luot = []
  for i = 1 .. n-1
      min_idx = i
      for j = i+1 .. n
          so_sanh += 1
          if b[j] < b[min_idx]: min_idx = j
      push!(min_moi_luot, min_idx)
      if min_idx != i: hoán đổi b[i], b[min_idx]; so_doi += 1
  return (b, so_sanh, so_doi, min_moi_luot)
```

### 3.3.2. Đoạn mã và giải thích

Đoạn mã quyết định nằm trong src/DT011.jl: hai vòng lặp lồng nhau, vòng ngoài chọn i, vòng trong quét tìm min. Phép hoán đổi chỉ xảy ra sau khi quét xong và chỉ khi min_idx != i, đảm bảo không tính phép đổi một ô với chính nó. Permalink tại commit C ghi ở Bảng 4.5.

### 3.3.3. Xử lý tình huống đặc biệt

Tình huống đặc biệt: n = 0, 1 thì vòng ngoài không chạy, trả mảng gốc với 0 so sánh, 0 đổi chỗ; mảng đã tăng cho so_doi = 0; mảng toàn phần tử bằng nhau giữ nguyên; input sai bị từ chối ở kiem_tra_dau_vao trước khi vào lõi (kiểm ở Chương 4: BIEN01–BIEN03, LOI01).

## 3.4. Lần vết ví dụ nhỏ

Ca truy vết T01 dùng input của Ví dụ 1: a = [8,3,5,1,9,2], expected [1,2,3,5,8,9].

Ca truy vết T01    Input đầy đủ [8,3,5,1,9,2]    Expected [1,2,3,5,8,9]

Bảng 3.3 Truy vết ca T01 (VD01) với a = [8,3,5,1,9,2]

| Bước | Thao tác | Trạng thái trước | Trạng thái sau | Giải thích |
| Khởi tạo | b = copy(a) | — | [8,3,5,1,9,2] | n = 6, so_sanh = 0, so_doi = 0 |
| Lượt 1 | Quét [1..6], min tại 4 | [8,3,5,1,9,2] | [1,3,5,8,9,2] | Đổi a[1] ↔ a[4] (8, 1) |
| Lượt 2 | Quét [2..6], min tại 6 | [1,3,5,8,9,2] | [1,2,5,8,9,3] | Đổi a[2] ↔ a[6] (3, 2) |
| Lượt 3 | Quét [3..6], min tại 6 | [1,2,5,8,9,3] | [1,2,3,8,9,5] | Đổi a[3] ↔ a[6] (5, 3) |
| Lượt 4 | Quét [4..6], min tại 6 | [1,2,3,8,9,5] | [1,2,3,5,9,8] | Đổi a[4] ↔ a[6] (8, 5) |
| Lượt 5 | Quét [5..6], min tại 6 | [1,2,3,5,9,8] | [1,2,3,5,8,9] | Đổi a[5] ↔ a[6] (9, 8) |
| Tổng kết | Hết vòng ngoài i = 1..5 | [1,2,3,5,8,9] | — | 15 so sánh, 5 đổi chỗ, min [4,6,6,6,6] |

## 3.5. Giải thích tính đúng và điều kiện dừng

### 3.5.1. Điều kiện khởi đầu và duy trì

Bất biến vòng lặp: trước lượt i, đoạn a[1..i-1] đã cố định đúng (i-1 phần tử nhỏ nhất theo thứ tự tăng). Sau khi quét đoạn a[i..n] và đổi a[i] với phần tử nhỏ nhất, bất biến được duy trì cho lượt i+1. Cơ sở i = 1 đúng (đoạn rỗng); bước chuyển đúng vì phần tử nhỏ nhất còn lại được đưa về đúng vị trí.

### 3.5.2. Kết thúc và output

Vòng ngoài tăng i từ 1 đến n-1 nên dừng sau đúng n-1 lượt. Khi kết thúc, a[1..n-1] đã cố định đúng, phần tử còn lại a[n] tự là lớn nhất, do đó toàn mảng tăng dần. Kiểm thử Chương 4 là bằng chứng bổ sung, không thay lập luận.

## 3.6. Phân tích độ phức tạp

Mỗi lượt i thực hiện n-i phép so sánh, tổng n(n-1)/2, nên thời gian O(n^2) không phụ thuộc dữ liệu. Số hoán đổi tối đa n-1. Bộ nhớ phụ O(1) cho biến đếm; bản sao b tốn O(n).

Bảng 3.4 Chi phí của từng pha trong bản cài

| Pha thực hiện | Tham số quy mô | Phép toán đếm | Thời gian | Bộ nhớ phụ |
| Kiểm tra và chuẩn bị | n | Kiểm tra n, \|a[i]\| | O(n) | O(1) |
| Thuật toán chính | n | n(n-1)/2 phép so sánh | O(n^2) | O(1) |
| Bản sao / đối chứng | n | copy(a), sap_xep_doi_cho | O(n^2) | O(n) |
| In và định dạng | n | In mảng, bộ đếm | O(n) | O(1) |
| Toàn chương trình | n | — | O(n^2) | O(n) |

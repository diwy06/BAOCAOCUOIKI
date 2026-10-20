# CHƯƠNG 2. CƠ SỞ LÝ THUYẾT

## 2.1. Khái niệm và mô hình dữ liệu

Đối tượng chính là mảng số nguyên a[1..n], n là số phần tử. Đoạn chưa sắp là dãy con a[i..n] với i là vị trí bắt đầu lượt hiện hành. Phần tử nhỏ nhất của đoạn xác định bởi chỉ số min thỏa a[min] ≤ a[j] với mọi j trong đoạn. Giáo trình trình bày ở mục 2.2.2, bảng 2.2 (trang in 35–37).

## 2.2. Cấu trúc dữ liệu sử dụng

### 2.2.1. Dữ liệu và thao tác chính

Cấu trúc dùng là mảng (Vector{Int}). Thao tác chính: đọc a[j], so sánh a[j] < a[min] và hoán đổi a[i], a[min]. Mảng phù hợp vì đề chỉ cần sắp xếp tại chỗ, truy cập ngẫu nhiên O(1), không cần cấu trúc phụ. Bản sao b = copy(a) giữ nguyên dữ liệu gốc của người gọi.

### 2.2.2. Quy ước và điều kiện hợp lệ

Quy ước: chỉ số 1-based; mảng rỗng Int[] có n = 0; phần tử trùng hợp lệ, khi nhiều phần tử cùng nhỏ nhất giữ chỉ số đầu tiên (chỉ cập nhật khi a[j] < a[min]); bỏ hoán đổi khi min_index == i. Các khái niệm cây, đồ thị không dùng trong đề này.

Bảng 2.1 Biến cấu trúc và điều kiện phải duy trì

| Ký hiệu / cấu trúc | Ý nghĩa | Miền / bất biến |
| a[1..n] | Mảng cần sắp | \|a[i]\| ≤ 10^6; giữ nguyên đa tập |
| i (đầu đoạn chưa sắp) | Biến vòng ngoài | Sau lượt i, a[1..i] cố định đúng |
| min_idx | Vị trí nhỏ nhất đoạn a[i..n] | a[min_idx] ≤ a[j] với mọi j trong [i..n] |

## 2.3. Nguyên lý thuật toán

### 2.3.1. Ý tưởng xử lý

Ở mỗi lượt i (1..n-1) thuật toán quét đoạn a[i..n] tìm vị trí min rồi đổi a[i] với a[min] nếu min khác i. Sau lượt i, phần tử nhỏ nhất còn lại nằm đúng vị trí i. Đây là điểm khác với sắp xếp đổi chỗ: đổi chỗ hoán đổi ngay mỗi khi gặp phần tử nhỏ hơn nên số lần đổi nhiều hơn hẳn.

### 2.3.2. Điều kiện bắt đầu và kết thúc

Khởi tạo b = copy(a), so_sanh = 0, so_doi = 0, min_moi_luot rỗng. Vòng ngoài i = 1..n-1, vòng trong j = i+1..n. Dừng khi i = n (đoạn còn một phần tử). Trả về mảng đã sắp cùng các bộ đếm. Lưu ý tính ổn định: sắp xếp lựa chọn KHÔNG ổn định. Với [2a,2b,1], lượt 1 tìm min là 1 tại vị trí 3 rồi đổi a[1] với a[3], thu được [1,2b,2a] — hai phần tử bằng nhau bị đảo thứ tự tương đối. Muốn ổn định phải dùng sắp xếp chèn/trộn hoặc thêm điều kiện chọn.

## 2.4. Cơ sở đánh giá thời gian và bộ nhớ

Phép toán chính là so sánh a[j] < a[min]. Số so sánh lượt i là n-i, tổng là n(n-1)/2 nên thời gian O(n^2) cho mọi dữ liệu. Số hoán đổi tối đa n-1. Bộ nhớ phụ O(1) cho biến đếm; bản sao b tốn O(n) (không bắt buộc nếu sắp tại chỗ). Dự đoán n = 5, 20, 100, 500 tăng bậc hai.

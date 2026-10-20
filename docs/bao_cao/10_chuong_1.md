# CHƯƠNG 1. TỔNG QUAN ĐỀ TÀI

## 1.1. Bài toán và lý do thực hiện

Đề tài "Sắp xếp lựa chọn và tiết kiệm đổi chỗ" yêu cầu sắp xếp một mảng số nguyên tăng dần bằng thuật toán sắp xếp lựa chọn: ở mỗi lượt tìm phần tử nhỏ nhất của đoạn chưa sắp rồi đổi về đầu đoạn. Trọng tâm là theo dõi chỉ số min, đếm số phép so sánh và số phép hoán đổi thực sự, từ đó so với thuật toán đổi chỗ (mục 2.2.1) để giải thích vì sao hai thuật toán cùng bậc hai nhưng khác lượng thay đổi mảng. Căn cứ: Chương 2, Mục 2.2.2, bảng 2.2, trang in 35–37.

## 1.2. Mục tiêu và sản phẩm

Các mục tiêu và sản phẩm:

- Cài đặt sap_xep_lua_chon(a) trả về mảng tăng dần, số so sánh, số đổi chỗ thực và vị trí min từng lượt.
- Cài đặt hàm con tim_min_doan(a, l, r) tìm vị trí nhỏ nhất trong một đoạn.
- Cài đặt lan_vet_lua_chon(a) in từng lượt theo bảng 2.2.
- Đối chứng sap_xep_doi_cho(a) để so số đổi chỗ.
- Bộ kiểm thử ≥12 ca độc lập, 11 ảnh minh chứng, báo cáo và kho mã chạy lại được.

## 1.3. Phạm vi, đầu vào và đầu ra

### 1.3.1. Miền và quy ước đầu vào

Dữ liệu vào là mảng a kiểu Vector{Int} với n phần tử, 0 ≤ n ≤ 2000 và |a[i]| ≤ 10^6. Phần tử trùng nhau hợp lệ. Dữ liệu nhập từ bàn phím hoặc khai báo trực tiếp, không đọc tệp CSV/Excel. Chỉ số mảng dùng 1-based theo quy ước của Julia.

### 1.3.2. Kết quả và trường hợp đặc biệt

Kết quả gồm: mảng đã sắp tăng dần; số phép so sánh; số phép hoán đổi thực sự (bỏ qua phép đổi một ô với chính nó khi min_index == i); danh sách vị trí min từng lượt. Không có trường hợp vô nghiệm: mọi mảng hợp lệ đều sắp được. Input sai bị từ chối bằng ArgumentError.

Bảng 1.1 Đặc tả dữ liệu vào

| Tên dữ liệu | Kiểu và kích thước | Miền và điều kiện | Cách nhập hoặc khai báo |
| a (mảng đầu vào) | Vector{Int}, n phần tử | 0 ≤ n ≤ 2000; \|a[i]\| ≤ 10^6; trùng hợp lệ | Khai báo trực tiếp / bàn phím |
| n (số phần tử) | Số nguyên không âm | 0 ≤ n ≤ 2000 | Suy từ độ dài mảng a |
| l, r (chỉ số đoạn) | Số nguyên 1-based | 1 ≤ l ≤ r ≤ n | Tham số hàm tim_min_doan |

Bảng 1.2 Đặc tả kết quả đầu ra

| Kết quả | Kiểu hoặc cách in | Ý nghĩa và điều kiện đúng | Hòa vô nghiệm hoặc lỗi |
| Mảng đã sắp | Vector{Int} | Tăng dần, đúng đa tập của a | Không áp dụng hòa/vô nghiệm |
| Số so sánh, đổi chỗ, vị trí min | Số nguyên / danh sách | so sánh = n(n-1)/2; đổi chỗ ≤ n-1 | Input sai: ArgumentError |

Input được nhập bàn phím, khai báo trực tiếp hoặc truyền tham số; thuật toán không phụ thuộc CSV/Excel hay tệp ngoài. Trường hợp hòa/vô nghiệm không áp dụng: mọi mảng hợp lệ có đúng một kết quả; chỉ input sai mới bị từ chối.

## 1.4. Cách thực hiện và cấu trúc báo cáo

Quy trình: đọc giáo trình mục 2.2.2 → giải ví dụ bằng tay → cài đặt → chạy kiểm thử → chụp bằng chứng. Báo cáo gồm năm chương như đã liệt kê ở mục lục.

Bảng 1.3 Đối chiếu yêu cầu và sản phẩm

| Yêu cầu trên phiếu | Sản phẩm/điều kiện kiểm | Mục sẽ trình bày |
| Cài đặt sắp xếp lựa chọn | Hàm sap_xep_lua_chon chạy đúng mọi ca | Chương 3, mục 3.3 |
| Theo dõi min, so sánh, đổi chỗ | Đếm đúng n(n-1)/2 so sánh, ≤ n-1 đổi chỗ | Chương 3, mục 3.3–3.4 |
| Đối chứng thuật toán đổi chỗ | So số đổi chỗ hai thuật toán | Chương 4, mục 4.4.2 |

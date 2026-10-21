# CHƯƠNG 4. KẾT QUẢ THỬ NGHIỆM VÀ NHẬN XÉT

## 4.1. Môi trường và kế hoạch kiểm thử

### 4.1.1. Môi trường và phiên bản

Môi trường: Windows 11; VSCode 1.142.0 dùng terminal PowerShell; Julia 1.13.1 (chỉ thư viện chuẩn). Mã chính tại src/DT011.jl, CLI tại bin/dt011.jl, bộ kiểm thử tại spec/runtests.jl, khảo sát tại bench/scales.jl. Commit chạy và chụp ảnh là C 51d345b; commit nộp S ghi trong ThongTinNop.txt.

### 4.1.2. Phương pháp xác định kỳ vọng

Kỳ vọng được tính độc lập bằng tay (giải ví dụ từng bước) và đối chiếu bằng hàm sort có sẵn của Julia trong kiểm thử (oracle độc lập, không dùng trong lõi thuật toán). Với mảng, kết quả là duy nhất nên so sánh trực tiếp không cần sai số.

## 4.2. Bảng kết quả ít nhất 14 ca

Bảng dưới liệt kê 14 ca kiểm thử độc lập, gồm hai ví dụ và toàn bộ năm ca trên phiếu, bổ sung các ca tự thiết kế, biên và input sai. Mỗi ca có mã, input đủ tái hiện, expected tính độc lập và actual đối chiếu.

Miền chính là mảng số nguyên; các ca biên và ca hàm con (tim_min_doan, validator) được dùng để kiểm nhánh đặc biệt của thuật toán.

Bảng 4.1 Ánh xạ năm ca kiểm trên phiếu

| Ca trên phiếu | Input và yêu cầu/kỳ vọng theo phiếu | Mã ca trong bảng kiểm thử | Ảnh/log hoặc vị trí kết quả |
| Ca phiếu 1 | [1,2,3,5,8,9] đã tăng (dãy kết quả VD01) | BIEN04 / demo_all.log | evidence/logs/demo_all.log |
| Ca phiếu 2 | [2,1,2] cho [1,2,2] | VD02 / A02 | 02_VD02.png |
| Ca phiếu 3 | [1,2,3] không đổi chỗ | BIEN04 / demo_all.log | evidence/logs/demo_all.log |
| Ca phiếu 4 | [4,4,4] giữ đủ 3 phần tử | BIEN03 / demo_all.log | evidence/logs/demo_all.log |
| Ca phiếu 5 | Mảng rỗng Int[] / một phần tử [7] không lỗi | BIEN01 + BIEN02 / A05 + A06 | 05_BIEN01.png; 06_BIEN02.png |

Ca phiếu 1 ([1,2,3,5,8,9]) là dãy đã tăng — chính là kết quả của VD01; tính chất "đã tăng thì không đổi chỗ" được kiểm trực tiếp bằng BIEN04 trên [1,2,3] (cùng mục tiêu nên đếm một lần), còn giá trị đúng của dãy 6 phần tử đã được xác nhận ở VD01. Ca phiếu 5 được phủ bởi hai ca: BIEN01 (Int[]) và BIEN02 ([7]).

Bảng 4.2 Thiết kế ít nhất 14 ca kiểm độc lập

| Ca | Nguồn và đối tượng | Input đủ tái hiện | Expected và cách kiểm |
| VD01 | Ví dụ 1 phiếu / sap_xep_lua_chon | [8,3,5,1,9,2] | ra [1,2,3,5,8,9]; so_sanh=15; so_doi=5 |
| VD02 | Ví dụ 2 phiếu / sap_xep_lua_chon | [2,1,2] | ra [1,2,2]; so_sanh=3; so_doi=1 |
| TK01 | Tự thiết kế 1 (trùng 1) / sap_xep_lua_chon | [5,1,4,1,3] | ra [1,1,3,4,5]; so_sanh=10; so_doi=4 |
| TK02 | Tự thiết kế 2 (giảm dần) / sap_xep_lua_chon | [9,7,5,3,1] | ra [1,3,5,7,9]; so_sanh=10; so_doi=2 |
| BIEN01 | Biên rỗng / sap_xep_lua_chon | Int[] | ra Int[]; so_sanh=0; so_doi=0 |
| BIEN02 | Biên một phần tử / sap_xep_lua_chon | [7] | ra [7]; so_sanh=0; so_doi=0 |
| BIEN03 | Biên toàn trùng / sap_xep_lua_chon | [4,4,4] | ra [4,4,4]; so_sanh=3; so_doi=0 |
| BIEN04 | Biên đã tăng / sap_xep_lua_chon | [1,2,3] | ra [1,2,3]; so_sanh=3; so_doi=0 |
| KT01 | Số âm xen kẽ, có trùng | [3,-1,3,-1,0] | ra [-1,-1,0,3,3]; so_sanh=10; so_doi=3 |
| KT02 | Hai đầu biên 10^6 | [1000000,-1000000,0] | ra [-1000000,0,1000000]; so_sanh=3; so_doi=2 |
| KT03 | n = 2 nghịch thế | [2,1] | ra [1,2]; so_sanh=1; so_doi=1 |
| KT04 | 100 phần tử bằng nhau | fill(1,100) | ra 100 số 1; so_sanh=4950; so_doi=0 |
| KT05 | 50 phần tử sinh theo công thức | mod(37*i,201)-100 với i = 1..50 | đối chiếu sort(a); so_sanh=1225; so_doi=45 |
| LOI01 | Input sai, 3 kiểu vi phạm | n=2001; a[i]=10^6+1; [1.5,2.0] | hàm kiểm tra ném ArgumentError |

Bảng 4.3 Actual, kết luận và vị trí minh chứng

| Ca | Actual | Kết luận | Ảnh, log và commit chạy |
| VD01 | [1,2,3,5,8,9] | PASS | A01 / 01_VD01.png / C 51d345b |
| VD02 | [1,2,2] | PASS | A02 / 02_VD02.png / C 51d345b |
| TK01 | [1,1,3,4,5] | PASS | A03 / 03_TK01.png / C 51d345b |
| TK02 | [1,3,5,7,9] | PASS | A04 / 04_TK02.png / C 51d345b |
| BIEN01 | [] | PASS | A05 / 05_BIEN01.png / C 51d345b |
| BIEN02 | [7] | PASS | A06 / 06_BIEN02.png / C 51d345b |
| BIEN03 | [4,4,4] | PASS | demo_all.log / C 51d345b |
| BIEN04 | [1,2,3] | PASS | demo_all.log / C 51d345b |
| KT01 | [-1,-1,0,3,3] | PASS | demo_all.log / C 51d345b |
| KT02 | [-1000000,0,1000000] | PASS | demo_all.log / C 51d345b |
| KT03 | [1,2] | PASS | demo_all.log / C 51d345b |
| KT04 | 100 số 1 | PASS | demo_all.log / C 51d345b |
| KT05 | khớp sort(a) | PASS | demo_all.log / C 51d345b |
| LOI01 | cả 3 kiểu đều ném ArgumentError | PASS | A08 / 08_LOI01.png / C 51d345b |

## 4.3. Hai ví dụ trên phiếu

### 4.3.1. Ví dụ 1 — VD01

Input: [8,3,5,1,9,2]. Expected: [1,2,3,5,8,9], xác định bằng giải tay và sort độc lập. Lệnh chạy: julia --startup-file=no bin/dt011.jl demo --case VD01. Actual: [1,2,3,5,8,9], 15 so sánh, 5 đổi chỗ, min từng lượt [4,6,6,6,6].

![Hình 4.1 — Ví dụ 1 (VD01): output thật từ bin/dt011.jl demo --case VD01.](evidence/images/01_VD01.png)

### 4.3.2. Ví dụ 2 — VD02

Input: [2,1,2]. Expected: [1,2,2], xác định bằng giải tay (giữ đủ hai phần tử 2). Lệnh chạy: julia --startup-file=no bin/dt011.jl demo --case VD02. Actual: [1,2,2], 3 so sánh, 1 đổi chỗ, min [2,2].

![Hình 4.2 — Ví dụ 2 (VD02): output thật từ bin/dt011.jl demo --case VD02.](evidence/images/02_VD02.png)

## 4.4. Hai ca sinh viên tự thiết kế

### 4.4.1. Ca TK01

Mục đích: kiểm phần tử trùng. Input [5,1,4,1,3], expected [1,1,3,4,5]. Actual khớp: 10 so sánh, 4 đổi chỗ. Hai số 1 trùng giá trị nên không phân biệt được thứ tự; sắp xếp lựa chọn nói chung KHÔNG ổn định — ví dụ [2a,2b,1] cho [1,2b,2a] vì lượt 1 đổi a[1] với a[3]. Tính không ổn định được phân tích ở mục 2.3.2.

![Hình 4.3 — Ca tự thiết kế 1 (TK01).](evidence/images/03_TK01.png)

### 4.4.2. Ca TK02

Mục đích: mảng giảm dần — trường hợp tiết kiệm đổi chỗ rõ nhất. Input [9,7,5,3,1], expected [1,3,5,7,9]. Actual khớp: 10 so sánh nhưng chỉ 2 đổi chỗ. Chạy đối chứng sap_xep_doi_cho trên cùng input cho 10 đổi chỗ (đúng bằng số nghịch thế; log tại evidence/logs/so_sanh.log); hai mảng khác cũng lệch rõ: [8,3,5,1,9,2] là 5 so với 9, [5,1,4,1,3] là 4 so với 6. Hàm đối chứng được kiểm trong testset "Đối chứng sắp xếp đổi chỗ" với các assert lc.mang == dc.mang == sort(a), lc.so_sanh == dc.so_sanh và lc.so_doi ≤ dc.so_doi.

![Hình 4.4 — Ca tự thiết kế 2 (TK02).](evidence/images/04_TK02.png)

## 4.5. Ba ca biên phù hợp với đề tài

### 4.5.1. Ca BIEN01 — mảng rỗng

Biên rỗng: Int[] (n = 0). Expected Int[], so_sanh = 0, so_doi = 0. Actual khớp; đây là ca phiếu 5 (mảng rỗng). Hình 4.5 là ảnh chạy thật ca này.

![Hình 4.5 — Biên rỗng (BIEN01): mảng Int[] không lỗi.](evidence/images/05_BIEN01.png)

### 4.5.2. Ca BIEN02 — một phần tử

Biên một phần tử: [7] (n = 1). Expected [7], so_sanh = 0, so_doi = 0. Actual khớp; đây là ca phiếu 5 (một phần tử). Hình 4.6 là ảnh chạy thật ca này.

![Hình 4.6 — Một phần tử (BIEN02).](evidence/images/06_BIEN02.png)

### 4.5.3. Ca BIEN03 — toàn trùng

Biên toàn trùng: [4,4,4] (ca phiếu 4). Expected [4,4,4], so_sanh = 3, so_doi = 0 vì min luôn đúng chỗ. Ca BIEN04 ([1,2,3] đã tăng) cũng cho so_doi = 0; cả hai nằm trong evidence/logs/demo_all.log. Hình 4.7 là bảng lần vết VD01 do bin/dt011.jl trace in ra, minh hoạ cách ghi nhận min từng lượt.

![Hình 4.7 — Lần vết VD01 do bin/dt011.jl trace in ra.](evidence/images/07_trace_VD01.png)

## 4.6. Kiểm tra input không hợp lệ — LOI01

Điều kiện phiếu bị vi phạm: n = 2001 > 2000; |a[i]| = 10^6+1 > 10^6; hoặc không phải Vector{Int}. Expected: hàm kiem_tra_dau_vao ném ArgumentError kèm lý do. Actual: ném đúng ArgumentError, không vào lõi thuật toán.

![Hình 4.8 — Input không hợp lệ (LOI01): cả ba kiểu đều bị từ chối.](evidence/images/08_LOI01.png)

## 4.7. Kết quả toàn bộ kiểm thử

Chạy lại toàn bộ 14 ca: 14/14 PASS. Bộ kiểm thử spec/runtests.jl có 137 phép kiểm, tất cả đạt, không còn lỗi.

![Hình 4.9 — Tổng kết 14 ca: bin/dt011.jl check in 137 phép kiểm đạt.](evidence/images/09_check.png)

## 4.8. Khảo sát bốn quy mô

### 4.8.1. Dữ liệu và điều kiện khảo sát

Khảo sát bốn quy mô n = 5, 20, 100, 500 (theo phiếu) trên mảng ngẫu nhiên |a[i]| ≤ 10^6, seed 20261020 để tái hiện. Phép đếm là số so sánh (tất định = n(n-1)/2) và số đổi chỗ thực của cả lựa chọn lẫn đổi chỗ.

### 4.8.2. Kết quả và giới hạn nhận xét

Số so sánh đếm thực khớp đúng công thức n(n-1)/2 ở cả bốn quy mô (10; 190; 4.950; 124.750), xác nhận O(n^2). Số đổi chỗ của lựa chọn là 4; 15; 93; 492, còn của sắp xếp đổi chỗ là 6; 111; 2.383; 64.815 — mức chênh lệch tăng rất nhanh theo n, đúng tinh thần "tiết kiệm đổi chỗ". Thời gian đo chỉ mang tính tham khảo vì quy mô còn nhỏ.

Bảng 4.4 Khảo sát bốn quy mô Q1–Q4

| Bộ | Quy mô hoặc cấu hình và input | Yếu tố thay đổi | Phép đếm hoặc số đo | Bộ nhớ và nhận xét |
| Q1 | n = 5, mảng ngẫu nhiên (seed 20261020) | quy mô n | so_sanh = 10; so_doi_lc = 4; so_doi_dc = 6; ~0,0004 ms | O(1) phụ |
| Q2 | n = 20, mảng ngẫu nhiên | quy mô n | so_sanh = 190; so_doi_lc = 15; so_doi_dc = 111; ~0,0007 ms | O(1) phụ |
| Q3 | n = 100, mảng ngẫu nhiên | quy mô n | so_sanh = 4.950; so_doi_lc = 93; so_doi_dc = 2.383; ~0,0075 ms | O(1) phụ |
| Q4 | n = 500, mảng ngẫu nhiên | quy mô n | so_sanh = 124.750; so_doi_lc = 492; so_doi_dc = 64.815; ~0,1573 ms | O(1) phụ |

Bảng 4.4 dùng đúng bốn quy mô 5, 20, 100, 500 và đo cả hai thuật toán trên cùng mảng. Thời gian đo không dùng để chứng minh bậc phức tạp; phép đếm so sánh (tất định) và cặp số đổi chỗ lựa chọn/đổi chỗ là bằng chứng chính.

Dữ liệu tạo ngẫu nhiên bằng Random.seed!(20261020) trong bench/scales.jl để tái hiện được. Số liệu thời gian chỉ minh hoạ, không kết luận vượt bằng chứng.

## 4.9. GitHub và chạy lại từ bản sao tại C

### 4.9.1. Phiên bản có thể đối chiếu

URL repo, SHA chạy C và permalink hàm chính/test tại C được ghi ở Bảng 4.5; SHA nộp S ghi trong ThongTinNop.txt nộp rời. Việc đối chiếu phiên bản dựa trên commit C 51d345b và các ảnh chụp tại đúng commit đó.

Bảng 4.5 Kho mã và phiên bản có thể kiểm lại

| Thông tin | Giá trị |
| URL repo | https://github.com/diwy06/baocaocuoiki_ctdl |
| Full SHA chạy ảnh C | 51d345b199bf89bd74d1afb1a2b261931331fcb1 |
| Commit chụp ảnh/log | A01–A11 chụp tại C 51d345b; A10 dựng bản sao đúng HEAD C |
| SHA S ghi TXT nộp rời | Commit S sau khi thêm báo cáo/ảnh — ghi trong ThongTinNop.txt |
| Permalink hàm chính | https://github.com/diwy06/baocaocuoiki_ctdl/blob/51d345b199bf89bd74d1afb1a2b261931331fcb1/src/DT011.jl |
| Permalink tệp kiểm thử | https://github.com/diwy06/baocaocuoiki_ctdl/blob/51d345b199bf89bd74d1afb1a2b261931331fcb1/spec/runtests.jl |
| Lệnh chạy lại | julia --startup-file=no bin/dt011.jl check |
| Ghi chú | Kho công khai, nhánh main; bản sao tại C chạy lại 14/14 ca PASS |

### 4.9.2. Bản sao tại C và tái hiện kết quả

Ảnh A10 chụp khi dựng bản sao của mã tại commit C trong thư mục mới, kiểm HEAD = C bằng git log -1, kiểm julia --version rồi chạy lại bộ kiểm thử.

Ảnh A10 cho thấy thư mục bản sao mới hoàn toàn, HEAD = 51d345b đúng như khai báo và phiên bản Julia 1.13.1. Chạy lại bin/dt011.jl check cho 14/14 ca PASS, 137 phép kiểm đạt.

![Hình 4.10 — Bản sao tại commit C: HEAD đúng C, check 14/14 ca, 137 phép kiểm đạt.](evidence/images/10_clone.png)

### 4.9.3. Bằng chứng kho GitHub thật

Ảnh A11 là màn hình terminal tại thư mục repo, in địa chỉ remote trỏ tới https://github.com/diwy06/baocaocuoiki_ctdl và danh sách commit trên nhánh main, cho thấy commit C 51d345b cùng chuỗi commit của hai tiến độ. Đối chiếu ảnh với Bảng 4.5 cho thấy URL, SHA và cấu trúc tệp khớp nhau.

![Hình 4.11 — Kho GitHub: địa chỉ remote và lịch sử commit tại nhánh main.](evidence/images/11_git.png)

## 4.10. Mô phỏng trực quan (tuỳ chọn)

Ngoài mã lõi, đồ án có thêm trang mô phỏng tương tác docs/MoPhong_SelectionSort_DT011.html — một tệp HTML tự chứa, mở trực tiếp bằng trình duyệt, không cần cài đặt hay mạng. Trang minh hoạ: (i) giả mã có dòng đang chạy được tô sáng; (ii) chạy đối đầu song song sắp xếp lựa chọn và sắp xếp đổi chỗ trên cùng mảng, đếm số đổi chỗ theo thời gian thực; (iii) biểu đồ số so sánh n(n-1)/2 với n = 5, 20, 100, 500; (iv) chế độ sắp giảm dần (chọn max); (v) sao chép bảng truy vết.

Trang mô phỏng chỉ là công cụ quan sát thuật toán, không phải bằng chứng chạy; mọi số liệu trong báo cáo vẫn lấy từ mã Julia tại commit C. Trang dùng cùng quy ước với lõi (đếm n-i phép so sánh mỗi lượt, chỉ đổi khi vị trí min khác i) nên kết quả hiển thị trùng với bin/dt011.jl.

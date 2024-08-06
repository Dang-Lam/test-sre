# SRE Tasks

## Nhiệm vụ 1: Xây dựng Script để Cài đặt Máy chủ Sản xuất

### Mục tiêu
Xây dựng một script để cài đặt các máy chủ cơ sở cho môi trường sản xuất, sử dụng bất kỳ công cụ tự động hóa phù hợp nào (ansible*, salt stack, terraform, bash...).

### Yêu cầu
Giải pháp nên thiết lập các thành phần sau với sự cân nhắc cho một hệ thống cấp sản xuất:

1. **Tài khoản "Sysadmin":**
   - Có quyền sudo
   - Thiết lập hostname (dns)
   - Bao gồm các lệnh CLI thường dùng

2. **Cài đặt Docker daemon:**
   - Chỉ định trình điều khiển ghi log
   - Chọn trình điều khiển lưu trữ phù hợp

3. **Tối ưu hóa máy chủ:**
   - Chuẩn bị/tinh chỉnh cho khối lượng công việc có lưu lượng mạng cao

4. **Ghi log lệnh:**
   - Ghi lại mọi lệnh được thực hiện bởi người dùng
   - Lưu log trong một tệp cụ thể

### Triển khai
Chúng ta sẽ sử dụng một script bash cho việc cài đặt ban đầu, có thể dễ dàng tích hợp với Ansible cho các cấu hình phức tạp hơn.

#### Môi trường
- Hệ điều hành: Ubuntu 22.04 LTS (được hỗ trợ đến năm 2027)

#### Hướng dẫn Cài đặt Nhanh

1. **Cài đặt Các Phụ thuộc**
   - VirtualBox: [Tải tại đây](https://www.virtualbox.org/wiki/Downloads)
   - Vagrant: [Tải tại đây](http://www.vagrantup.com/downloads.html)
   - Ansible (chỉ cho Mac/Linux): [Hướng dẫn cài đặt](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

   > **Lưu ý cho người dùng Windows:** Hướng dẫn này được tối ưu hóa cho Mac và Linux. Hỗ trợ cho Windows có thể bị hạn chế tại thời điểm này.

2. **Chạy Máy ảo**
   1. Clone dự án này
   2. Mở Terminal và di chuyển đến thư mục dự án
   3. Chạy `vagrant up` và đợi Vagrant hoàn thành quá trình thiết lập

3. **Ghi chú Bổ sung**
   - Để tắt VM: Chạy `vagrant halt` trong thư mục chứa `Vagrantfile`
   - Để xóa hoàn toàn VM: Chạy `vagrant destroy`
   - Thư mục `/vagrant/` trong VM được đồng bộ hóa với thư mục dự án trên máy chủ của bạn
   - Để chạy script cài đặt: Thực thi `sudo sh /vagrant/scripts/setup-server.sh`

## Nhiệm vụ 2: Giám sát Việc Sử dụng Tài nguyên của một Tech Stack

### Chiến lược Giám sát

1. **Xác định Các Chỉ số Quan trọng**
   - **Máy chủ:** CPU, Ổ đĩa, I/O Ổ đĩa, I/O Mạng, thời gian hoạt động, tải trung bình
   - **Cơ sở dữ liệu:** Hiệu suất truy vấn, số lượng kết nối, độ trễ sao chép, tỷ lệ cache hit
   - **Ứng dụng:** Thời gian phản hồi, tỷ lệ yêu cầu, tỷ lệ lỗi, số lượng luồng, quản lý bộ nhớ
   - **Mạng:** Độ trễ, sử dụng băng thông, mất gói tin, tỷ lệ lỗi
   - **Container:** Sử dụng CPU/bộ nhớ, trạng thái container, sử dụng tài nguyên của node

2. **Chọn Công cụ Giám sát Phù hợp**
   - Prometheus: Thu thập dữ liệu thời gian thực và cảnh báo
   - Grafana: Trực quan hóa các chỉ số được thu thập bởi Prometheus
   - ELK Stack: Phân tích log ứng dụng

3. **Triển khai Thu thập Dữ liệu**
   - Máy chủ Prometheus: Thu thập các chỉ số từ các exporter và lưu trữ chúng
   - Logstash: Thu thập log từ nhiều nguồn và chuyển tiếp đến Elasticsearch
   - Elasticsearch: Lưu trữ và lập chỉ mục log
   - Grafana: Tạo bảng điều khiển để trực quan hóa các chỉ số

4. **Thiết lập Cảnh báo**
   - Prometheus Alertmanager: Gửi cảnh báo dựa trên các chỉ số của Prometheus

5. **Tạo Bảng điều khiển**
   - Bảng điều khiển Sức khỏe Máy chủ
   - Bảng điều khiển Hiệu suất Cơ sở dữ liệu
   - Bảng điều khiển Hiệu suất Ứng dụng
   - Bảng điều khiển Hiệu suất Mạng

### Kiến trúc Có khả năng Mở rộng, Đáng tin cậy và Phản hồi nhanh

![Sơ đồ Kiến trúc](/images/architect.drawio.png)

#### Các Thành phần Chính

1. **Lớp Người dùng**
   - Trình duyệt Web
   - Ứng dụng Di động
   - DNS để phân giải tên miền

2. **Cân bằng Tải**
   - Phân phối yêu cầu giữa các máy chủ web

3. **Lớp Web**
   - Nhiều máy chủ web (Máy chủ 1, Máy chủ 2, v.v.)

4. **Lớp Dữ liệu**
   - Master DB cho các hoạt động ghi
   - Slave DBs cho các hoạt động đọc
   - Sao chép để đảm bảo tính nhất quán dữ liệu

5. **Lớp Cache**
   - Ví dụ: Redis cho dữ liệu được truy cập thường xuyên

6. **Giám sát và Quản lý**
   - Ghi log
   - Thu thập chỉ số
   - Hệ thống giám sát
   - Công cụ tự động hóa

## Nhiệm vụ 3: Phản ứng Sự cố và Giải quyết Vấn đề

### Các bước Giải quyết Vấn đề Dịch vụ

1. **Xác nhận Cảnh báo**
   - Xác minh độ chính xác của cảnh báo trong hệ thống giám sát
   - Xem xét các chỉ số và tham số liên quan

2. **Đánh giá Tác động**
   - Xác định phạm vi và mức độ nghiêm trọng của vấn đề
   - Kiểm tra ảnh hưởng đến người dùng cuối hoặc các dịch vụ khác

3. **Kiểm tra Nhanh Sức khỏe**
   - Xác minh kết nối mạng
   - Kiểm tra tài nguyên hệ thống (CPU, RAM, Không gian đĩa)
   - Xem xét trạng thái của các quy trình liên quan

4. **Phân tích Log**
   - Kiểm tra log ứng dụng, hệ thống và cơ sở dữ liệu để tìm lỗi hoặc bất thường

5. **Xem xét Các thay đổi Gần đây**
   - Kiểm tra các bản cập nhật, thay đổi cấu hình hoặc triển khai gần đây

6. **Thực hiện Sửa chữa Nhanh**
   - Khởi động lại dịch vụ nếu cần thiết
   - Điều chỉnh tài nguyên hệ thống nếu chúng là nút thắt cổ chai

7. **Áp dụng Giải pháp Dài hạn**
   - Giải quyết nguyên nhân gốc rễ để ngăn chặn tái diễn
   - Cập nhật tài liệu và quy trình hoạt động

8. **Giám sát và Báo cáo**
   - Tiếp tục giám sát dịch vụ sau khi sửa chữa
   - Chuẩn bị báo cáo sự cố cho các bên liên quan

### Ví dụ Thực tế: Dịch vụ Web Chậm

#### Bối cảnh
- Nhận được cảnh báo: Thời gian phản hồi của dịch vụ web tăng đột biến
- Báo cáo của người dùng: Trang web tải cực kỳ chậm

#### Các bước Giải quyết

1. **Xác nhận Cảnh báo**
   - Bảng điều khiển giám sát cho thấy thời gian phản hồi tăng từ 200ms lên 2000ms

2. **Đánh giá Tác động**
   - Tất cả người dùng bị ảnh hưởng
   - Không có dịch vụ khác bị ảnh hưởng

3. **Kiểm tra Nhanh Sức khỏe**
   - Kết nối mạng bình thường
   - Sử dụng CPU của máy chủ web ở mức 90%

4. **Phân tích Log**
   - Log cho thấy sự tăng đột biến trong khối lượng yêu cầu

5. **Xem xét Thay đổi**
   - Không có thay đổi code hoặc cấu hình gần đây

6. **Sửa chữa Nhanh**
   - Tăng số lượng node máy chủ web

7. **Giải pháp Dài hạn**
   - Nguyên nhân gốc rễ: Chiến dịch marketing mới gây ra sự tăng vọt về lưu lượng truy cập
   - Triển khai tự động mở rộng để phản ứng nhanh với việc tăng tải
   - Hợp tác với team phát triển để tối ưu hóa code cho lưu lượng cao

8. **Theo dõi**
   - Giám sát liên tục trong 24 giờ
   - Chuẩn bị báo cáo chi tiết cho đội ngũ quản lý và marketing

#### Kết quả
- Dịch vụ trở lại bình thường trong vòng 30 phút
- Cải thiện khả năng xử lý tải cao trong tương lai
- Tăng cường phối hợp giữa các đội để dự đoán và chuẩn bị cho các chiến dịch marketing lớn
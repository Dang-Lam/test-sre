# test-sre
## Tasks
1 - Build a script to install base servers for a production environment, and use any
automation tools that suit you (ansible*, salt stack, terraform, bash...). The solution should
set up the following components, and make any changes as you see fit so that we can
assess your consideration for a production-grade system.
- "Sysadmin" accounts with sudo privilege; hostname (dns); cli commands you use
often.
- Install docker daemon, specify logging driver + storage driver of your choice.
- The server should be prepared/tuned for a high network traffic workload.
- Logging Every Command Executed by Users and saving in a specific file.

2 - Describe your idea to monitor the resource utilization of a Tech Stack. Draw a model
that is Scalable, Resilient, and Responsive to the most traffic you have ever deployed.

3 - When you receive an alert that a service is down or slow, what would you do to check
that service and resolve the issue? Describe your steps to resolve and prevent the problem
(you can describe a real situation that you have encountered).

1 - Xây dựng một script để cài đặt các máy chủ cơ sở cho môi trường sản xuất và sử dụng bất kỳ công cụ tự động hóa nào phù hợp với bạn (ansible*, salt stack, terraform, bash…). Giải pháp nên thiết lập các thành phần sau và thực hiện các thay đổi mà bạn thấy phù hợp để chúng tôi có thể đánh giá sự cân nhắc của bạn cho một hệ thống đạt tiêu chuẩn sản xuất.

- Tài khoản "Sysadmin" với quyền sudo; hostname (dns); các lệnh cli bạn thường sử dụng.
- Cài đặt docker daemon, chỉ định logging driver và storage driver theo ý bạn.
- Máy chủ nên được chuẩn bị/tinh chỉnh để chịu tải cao từ lưu lượng truy cập mạng.
- Ghi lại mọi lệnh được thực hiện bởi người dùng và lưu trữ trong một tệp cụ thể.

2 - Mô tả ý tưởng của bạn để giám sát việc sử dụng tài nguyên của một Tech Stack. Vẽ mô hình mà bạn đã triển khai có khả năng mở rộng, đáng tin cậy và phản ứng tốt với lưu lượng truy cập cao nhất mà bạn đã từng triển khai.

3 - Khi bạn nhận được cảnh báo rằng một dịch vụ bị ngừng hoặc chậm, bạn sẽ làm gì để kiểm tra dịch vụ đó và giải quyết vấn đề? Mô tả các bước của bạn để giải quyết và ngăn chặn vấn đề (bạn có thể mô tả một tình huống thực tế mà bạn đã gặp phải).

## Thực hiện:

Với yêu cầu là xây dựng một script để cài đặt máy chủ cơ sở cho môi trường sản xuất, mình sẽ sử dụng công cụ bash script, từ đó có thể dùng ansible để cấu hình một cách dễ dàng hơn. 
Môi trường để chạy script là Ubuntu 22.04 LTS, một distro ổn định còn được support đến 2027. 


Hướng dẫn nhanh test
1 - Cài đặt gói phụ thuộc (virutalBox, Vagrant, Ansible)

  1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
  2. Download and install [Vagrant](http://www.vagrantup.com/downloads.html).
  3. [Mac/Linux only] Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

Lưu ý cho người dùng Window: Hướng dẫn phù hợp cho người dùng MAC và linux. Windows host chưa được hỗ trợ tại thời điểm này. 
### 2- Chạy Máy ảo
  1. Tải project này về 
  2. Mở Terminal, cd tới thư mục đó
  3. Gõ `vagrant up`, chờ vagrant hoàn thành phần còn lại
### Notes
- Để tắt máy ảo, chạy `vagrant halt` trên terminal ở folder chứa cùng file `Vagrantfile`. Để xóa bỏ hoàn toàn (hoặc muốn tiết kiệm một chút phân vùng ổ cứng, hoặc muốn rebuild), gõ `vagrant destroy`.

Mặc định thư mục khi chạy lệnh vagrant sẽ đồng bộ với thư mục trong /vargrant/ . Để chạy script, chạy lệnh `sudo sh /vagrant/scripts/setup-server.sh`


Ý tưởng giám sát tài nguyên của một techstack.
1. Xác định các chỉ số cần giám sát
   - Máy chủ: CPU, Disks, Disks I/O, Network I/O, thời gian hoạt động, tải trung bình
   - CSDL: Hiệu suất truy vấn, số lượng kết nối, độ trễ sao chép, tỷ lệ cache hit. 
   - Ứng dụng: Thời gian phản hồì, tỷ lệ yêu cầu, tỷ lệ lỗi, số lượng luồng, quản lý bộ nhớ. 
   - mạng: độ trễ, băng thông sử dụng, mất gói, tỷ lệ lỗi
   - Container: Sử dụng CPU/bộ nhớ của container, trạng thái container, sử dụng tài nguyên của node
2. Chọn công cụ monitor phù hợp
   - Prometheus: Thu thập dữ liệu thời gian thực và cảnh báo
   - Grafana: Trực quan hóa các chỉ số được thu thập bởi Prometheus
   - ELK Stack: Phân tích Log ứng dụng
3. Triển khai thu thập dữ liệu
   - Prometheus server: thu thập các chỉ số từ các exporter và lưu trữ chúng
   - Logstash: thu thập log từ nhiều nguồn và chuyển tiếp tới elastic
   - Elasticsearch: lưu trữ và lập chỉ mục
   - Grafana: Tạo các bảng điều khiển để trực quan hóa các chỉ số 
4. Thiết lập cảnh báo
   - Prometheus Alertmanager: gửi cảnh báo dựa vào chỉ số của Prometheus 
5. Tạo bảng điều khiển
   - Server Health Dashboard: hiển thị sử dụng CPU, bộ nhớ , đĩa và mạng cho tất cả máy chủ
   - Database Performance Dashboard: hiển thị hiệu suất truy vấn, tốc độ giao dịch và trạng thái sao chép
   - Application Performance Dashboard: theo dõi thời gian phản hồi, tỷ lệ yêu cầu và tỷ lệ lỗi
   - Network Performance Dashboard: giám sát độ trễ, sử dụng băng thông và tỷ lệ lỗi

![grafana-demo](/images/grafana-demo.png)


Vẽ mô hình mà bạn đã triển khai có khả năng mở rộng, đáng tin cậy và phản ứng tốt với lưu lượng truy cập cao nhất mà bạn đã từng triển khai.

![architecture](/images/architect.drawio.png)

Thành Phần Chính của Mô Hình
1. User:

- Web Browser: Người dùng truy cập trang web qua trình duyệt web.
- Mobile App: Người dùng truy cập dịch vụ qua ứng dụng di động.
- DNS: Hệ thống phân giải tên miền, chuyển đổi tên miền (ví dụ: www.mysite.com) thành địa chỉ IP của máy chủ.
2. Load Balancer:

- Cân bằng tải, phân phối các yêu cầu từ người dùng đến các máy chủ web khác nhau để đảm bảo không có máy chủ nào bị quá tải.
3. Web Tier:

- Server 1 và Server 2: Các máy chủ web xử lý các yêu cầu từ người dùng. Các máy chủ này có thể xử lý đồng thời nhiều yêu cầu và cung cấp dịch vụ web.
4. Data Tier:

- Master DB: Cơ sở dữ liệu chính, nơi thực hiện các thao tác ghi (write) dữ liệu.
- Slave DB: Các cơ sở dữ liệu phụ, nơi thực hiện các thao tác đọc (read) dữ liệu và nhận dữ liệu sao chép từ cơ sở dữ liệu chính.
- Replication: Quá trình sao chép dữ liệu từ Master DB đến các Slave DB để đảm bảo tính nhất quán và độ tin cậy của dữ liệu.
5. Cache:

- Hệ thống cache (ví dụ: Redis) lưu trữ tạm thời các dữ liệu thường xuyên truy cập để giảm tải cho cơ sở dữ liệu và tăng tốc độ phản hồi.
Logging, Metrics, Monitoring, and Automation:

6. Logging: Ghi nhật ký các hoạt động và sự kiện của hệ thống để phục vụ cho việc phân tích và khắc phục sự cố.
- Metrics: Thu thập và phân tích các chỉ số hiệu suất của hệ thống để giám sát tình trạng hoạt động.
- Monitoring: Giám sát liên tục hệ thống để phát hiện và cảnh báo các vấn đề kịp thời.
- Automation: Tự động hóa các quy trình quản lý và vận hành hệ thống để nâng cao hiệu quả và giảm thiểu lỗi.
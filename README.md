# test-sre
## Tasks
1 - Build a script to install base servers for a production environment, and use any
automation tools that suit you (ansible*, salt stack, terraform, bash...). The solution should
set up the following components, and make any changes as you see fit so that we can
assess your consideration for a production-grade system.
- &quot;Sysadmin&quot; accounts with sudo privilege; hostname (dns); cli commands you use
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

### Thực hiện:

Với yêu cầu là xây dựng một script để cài đặt máy chủ cơ sở cho môi trường sản xuất, mình sẽ sử dụng công cụ bash script, từ đó có thể dùng ansible để cấu hình một cách dễ dàng hơn. 
Môi trường để chạy script là Ubuntu 22.04 LTS, một distro ổn định còn được support đến 2027. 


Hướng dẫn nhanh test
1 - Cài đặt gói phụ thuộc (virutalBox, Vagrant, Ansible)

  1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
  2. Download and install [Vagrant](http://www.vagrantup.com/downloads.html).
  3. [Mac/Linux only] Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

Lưu ý cho người dùng Window: Hướng dẫn phù hợp cho người dùng MAC và linux. Windows host chưa được hỗ trợ tại thời điểm này. 

## Notes
    - Để tắt máy ảo, chạy `vagrant halt` trên terminal ở folder chứa cùng file `Vagrantfilt`. Để xóa bỏ hoàn toàn (hoặc muốn tiết kiệm một chút phân vùng ổ cứng, hoặc muốn rebuild), gõ `vagrant destroy`.

Mặc định thư mục khi chạy lệnh vagrant sẽ đồng bộ với thư mục trong /vargrant/ . Để chạy script, chạy lệnh `sudo scripts/setup-server.sh`
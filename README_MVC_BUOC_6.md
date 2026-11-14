# Caro Flutter – Rà soát MVC bước 6

## Phạm vi rà soát

Bước 6 tập trung rà soát cấu trúc, bổ sung kiểm thử cho Model/Controller và xác nhận các phụ thuộc giữa các lớp.

## Kết quả rà soát cấu trúc

- `models/` chỉ phụ thuộc vào enum và quản lý dữ liệu bàn cờ/người chơi/ô cờ.
- `services/` xử lý luật chơi, lựa chọn nước đi AI và âm thanh; không import View.
- `views/widgets/` không import trực tiếp Controller, Service hoặc Model. Các widget nhận dữ liệu và callback từ màn hình.
- `views/screens/` đóng vai trò kết nối: khởi tạo Controller, lắng nghe trạng thái, truyền dữ liệu/callback xuống widget và hủy listener/controller trong `dispose`.
- `controllers/` điều phối trạng thái trận đấu, gọi Model/Service và thông báo thay đổi cho View.

## Thay đổi trong bước 6

- Controller cập nhật ô cờ qua `BanCoModel.datTrangThaiO()` thay vì ghi trực tiếp vào ma trận.
- Bổ sung `test/model_test.dart` cho khởi tạo bàn cờ, kích thước không hợp lệ, tọa độ, xóa bàn, trạng thái đầy, người chơi và ô cờ.
- Bổ sung `test/controller_test.dart` cho đổi lượt, bỏ qua ô đã đánh, kết thúc ván khi đủ 5 quân và khởi tạo ván mới.
- Mở rộng kiểm thử luật cho 4 hướng: ngang, dọc, chéo chính, chéo phụ; đồng thời kiểm tra trường hợp dưới 5 quân và hai đầu bị chặn.

## Tổng số test được khai báo

- `widget_test.dart`: 1
- `ai_service_test.dart`: 4
- `luat_va_kich_thuoc_test.dart`: 6
- `model_test.dart`: 6
- `controller_test.dart`: 3

Tổng cộng: 20 test.

## Kiểm tra cần chạy trên máy có Flutter SDK

Chạy tại thư mục chứa `pubspec.yaml`:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Sau đó kiểm tra thủ công PvP, PvE/AI, đồng hồ, âm thanh, chơi lại, đầu hàng và đường thắng.

## Giới hạn xác nhận

Môi trường đóng gói không có Flutter/Dart SDK, vì vậy chưa thể chạy `flutter analyze`, `flutter test` hoặc build ứng dụng tại đây. Các kiểm tra thực hiện trong môi trường đóng gói chỉ xác nhận ZIP hợp lệ, đường dẫn import tương đối không thiếu và quy tắc phân lớp ở mức rà soát tĩnh. Không xem 20 test là đã pass cho đến khi chạy thực tế trên máy có Flutter SDK.

## Ghi chú kiến trúc

Đây là MVC phù hợp với quy mô đồ án Flutter: màn hình đóng vai trò composition layer nối View với Controller. Các widget trình bày đã được tách khỏi Controller. `DieuKhienTroChoi` vẫn điều phối đồng hồ và thời điểm gọi AI/âm thanh; đây là trách nhiệm điều phối, còn thuật toán AI và luật chơi nằm ở Service.

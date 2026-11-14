# Ghi chú tái cấu trúc MVC – Caro Flutter

## Các thay đổi trong bước 4

1. Tách thuật toán chọn nước đi và chấm điểm AI khỏi `DieuKhienTroChoi` sang `services/ai_service.dart`.
2. `AiService` ưu tiên nước thắng ngay, sau đó chặn nước thắng của đối thủ, cuối cùng chấm điểm tấn công/phòng thủ như thuật toán trước.
3. Tách quản lý âm thanh/nhạc nền sang `services/am_thanh_service.dart`; các màn hình và controller gọi `AmThanhService`.
4. Đưa phần cài đặt luật chơi sang `services/bo_xu_ly_luat.dart`. File `controllers/bo_xu_ly_luat.dart` được giữ lại dưới dạng export tương thích với đường dẫn cũ.
5. `DieuKhienTroChoi` chỉ điều phối thời điểm AI suy nghĩ, nhận tọa độ do `AiService` trả về và áp dụng nước đi vào trận đấu.
6. Thay bài test Counter mặc định bằng bài test menu Caro; bổ sung `ai_service_test.dart` để kiểm tra AI thắng, chặn đối thủ, chọn trung tâm ở bàn trống và không để lại quân thử trên bàn.

## Cấu trúc liên quan

```text
lib/
├── controllers/
│   ├── bo_xu_ly_luat.dart  # export tương thích
│   └── dieu_khien_tro_choi.dart
├── models/
├── services/
│   ├── ai_service.dart
│   ├── am_thanh_service.dart
│   └── bo_xu_ly_luat.dart
└── views/
```

## Lưu ý kiểm thử

- Source được chỉnh sửa dựa trên bản bước 3 mà nhóm đã xác nhận `flutter test` chạy thành công.
- Môi trường tạo bản này không có Flutter/Dart SDK, vì vậy chưa thể tự chạy `flutter analyze`, `flutter test` hoặc `flutter run` sau khi tách service.
- Cần chạy các lệnh dưới đây trên máy nhóm và xử lý mọi lỗi mới (nếu có) trước khi dùng làm bản chính.

## Cách kiểm tra

Chạy lệnh tại thư mục chứa `pubspec.yaml`:

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Sau khi chạy, kiểm tra PvP, AI, đổi lượt, đồng hồ, thắng 5 quân, hòa, đầu hàng, chơi lại, âm thanh và nhạc nền.

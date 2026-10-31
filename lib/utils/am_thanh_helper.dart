import 'package:audioplayers/audioplayers.dart';

class AmThanhHelper {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> phatAmThanh(String tenFile) async {
    try {
      await _player.stop(); // Dừng âm thanh cũ nếu đang chạy
      await _player.play(AssetSource('sounds/$tenFile'));
    } catch (e) {
      print("Lỗi phát âm thanh: $e");
    }
  }
}
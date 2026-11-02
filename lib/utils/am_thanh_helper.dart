import 'package:audioplayers/audioplayers.dart';

class AmThanhHelper {
  static final AudioPlayer _player = AudioPlayer();
  static final AudioPlayer _playerNhacNen = AudioPlayer();

  static bool _tatNhacNen = false;
  static bool _tatTiengClick = false;

  static bool get dangTatNhacNen => _tatNhacNen;
  static bool get dangTatTiengClick => _tatTiengClick;

  static void toggleNhacNen() {
    _tatNhacNen = !_tatNhacNen;
    if (_tatNhacNen) {
      _playerNhacNen.stop();
    } else {
      phatNhacNen('PG_4_vol0.15.mp3');
    }
  }

  static void toggleTiengClick() {
    _tatTiengClick = !_tatTiengClick;
    if (_tatTiengClick) {
      _player.stop();
    }
  }

  static Future<void> phatAmThanh(String tenFile) async {
    if (_tatTiengClick) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/$tenFile'));
    } catch (e) {
      print("Lỗi phát âm thanh: $e");
    }
  }

  static Future<void> phatNhacNen(String tenFile) async {
    if (_tatNhacNen) return;
    try {
      await _playerNhacNen.setReleaseMode(ReleaseMode.loop);
      await _playerNhacNen.play(AssetSource('sounds/$tenFile'));
    } catch (e) {
      print("Lỗi phát nhạc nền: $e");
    }
  }

  static Future<void> dungNhacNen() async {
    await _playerNhacNen.stop();
  }

  // Thêm hàm này vào class AmThanhHelper
  static Future<void> phatAmThanhQuanCo(String tenFile) async {
    if (_tatTiengClick) return; // Nếu đang tắt tiếng click thì bỏ qua
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/$tenFile'));
    } catch (e) {
      print("Lỗi phát âm thanh quân cờ: $e");
    }
  }
}
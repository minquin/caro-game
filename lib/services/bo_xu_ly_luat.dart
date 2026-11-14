import 'dart:math';

import '../core/enums/trang_thai_o.dart';
import '../models/ban_co_model.dart';

/// Chứa các quy tắc của trò chơi Caro.
/// Lớp này không phụ thuộc vào giao diện hoặc vòng đời của trận đấu.
class BoXuLyLuat {
  static const List<List<int>> _huongQuet = [
    [1, 0], // Ngang
    [0, 1], // Dọc
    [1, 1], // Chéo chính
    [1, -1], // Chéo phụ
  ];

  /// Trả về hai đầu mút của đường thắng nếu có ít nhất 5 quân liên tiếp.
  /// Trả về null nếu nước đi chưa tạo thành đường thắng.
  static List<Point<int>>? timDuongThang(
    BanCoModel banCo,
    int xVuaDanh,
    int yVuaDanh,
    TrangThaiO trangThaiNguoiChoi,
  ) {
    if (trangThaiNguoiChoi == TrangThaiO.trong ||
        !_viTriHopLe(banCo, xVuaDanh, yVuaDanh)) {
      return null;
    }

    for (final huong in _huongQuet) {
      final dx = huong[0];
      final dy = huong[1];
      var soQuanLienTiep = 1;
      var diemDau = Point<int>(xVuaDanh, yVuaDanh);
      var diemCuoi = Point<int>(xVuaDanh, yVuaDanh);

      // Quét theo hướng dương.
      var buoc = 1;
      while (true) {
        final x = xVuaDanh + dx * buoc;
        final y = yVuaDanh + dy * buoc;
        if (!_viTriHopLe(banCo, x, y) ||
            banCo.layTrangThaiO(x, y) != trangThaiNguoiChoi) {
          break;
        }
        soQuanLienTiep++;
        diemCuoi = Point<int>(x, y);
        buoc++;
      }

      // Quét theo hướng âm.
      buoc = 1;
      while (true) {
        final x = xVuaDanh - dx * buoc;
        final y = yVuaDanh - dy * buoc;
        if (!_viTriHopLe(banCo, x, y) ||
            banCo.layTrangThaiO(x, y) != trangThaiNguoiChoi) {
          break;
        }
        soQuanLienTiep++;
        diemDau = Point<int>(x, y);
        buoc++;
      }

      if (soQuanLienTiep >= 5) {
        return [diemDau, diemCuoi];
      }
    }

    return null;
  }

  /// Kiểm tra nước đi có tạo thành ít nhất 5 quân liên tiếp hay không.
  static bool kiemTraThang(
    BanCoModel banCo,
    int xVuaDanh,
    int yVuaDanh,
    TrangThaiO trangThaiNguoiChoi,
  ) {
    return timDuongThang(
          banCo,
          xVuaDanh,
          yVuaDanh,
          trangThaiNguoiChoi,
        ) !=
        null;
  }

  /// Bàn cờ hòa khi không còn ô trống.
  static bool kiemTraHoa(BanCoModel banCo) => banCo.daDayBanCo();

  static bool _viTriHopLe(BanCoModel banCo, int x, int y) {
    if (banCo.laVoHan) return true;
    return x >= 0 &&
        x < banCo.kichThuoc &&
        y >= 0 &&
        y < banCo.kichThuoc;
  }
}

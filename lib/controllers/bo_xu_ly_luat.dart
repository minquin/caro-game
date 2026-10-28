import '../core/enums/trang_thai_o.dart';
import '../models/ban_co_model.dart';

class BoXuLyLuat {
  static bool kiemTraThang(BanCoModel banCo, int xVuaDanh, int yVuaDanh, TrangThaiO trangThaiNguoiChoi) {
    if (trangThaiNguoiChoi == TrangThaiO.trong) return false;

    final huongQuet = [
      [1, 0],  // Ngang
      [0, 1],  // Dọc
      [1, 1],  // Chéo chính
      [1, -1], // Chéo phụ
    ];

    final laBanCo3x3 = banCo.kichThuoc == 3;

    for (var huong in huongQuet) {
      int dx = huong[0];
      int dy = huong[1];

      int soQuanLienTiep = 1;
      int soDauBiChan = 0;

      // Quét hướng dương (+)
      int buoc = 1;
      while (true) {
        int nx = xVuaDanh + dx * buoc;
        int ny = yVuaDanh + dy * buoc;

        if (!_viTriHopLe(banCo, nx, ny)) {
          // Tường không tính là đầu bị chặn
          break;
        }

        TrangThaiO trangThai = banCo.layTrangThaiO(nx, ny);
        if (trangThai == trangThaiNguoiChoi) {
          soQuanLienTiep++;
          buoc++;
        } else if (trangThai == TrangThaiO.trong) {
          break; // Đầu mở
        } else {
          soDauBiChan++; // Bị quân đối phương chặn
          break;
        }
      }

      // Quét hướng âm (-)
      buoc = 1;
      while (true) {
        int nx = xVuaDanh - dx * buoc;
        int ny = yVuaDanh - dy * buoc;

        if (!_viTriHopLe(banCo, nx, ny)) {
          // Tường không tính là đầu bị chặn
          break;
        }

        TrangThaiO trangThai = banCo.layTrangThaiO(nx, ny);
        if (trangThai == trangThaiNguoiChoi) {
          soQuanLienTiep++;
          buoc++;
        } else if (trangThai == TrangThaiO.trong) {
          break; // Đầu mở
        } else {
          soDauBiChan++; // Bị quân đối phương chặn
          break;
        }
      }

      // ĐÁNH GIÁ ĐIỀU KIỆN THẮNG
      if (laBanCo3x3) {
        if (soQuanLienTiep >= 3) return true;
      } else {
        // Luật 4 quân không bị chặn
        if (soQuanLienTiep == 4 && soDauBiChan == 0) return true;
        // Luật 5 quân không bị chặn 2 đầu
        if (soQuanLienTiep >= 5 && soDauBiChan < 2) return true;
      }
    }

    return false;
  }

  static bool _viTriHopLe(BanCoModel banCo, int x, int y) {
    if (banCo.laVoHan) return true;
    return x >= 0 && x < banCo.kichThuoc && y >= 0 && y < banCo.kichThuoc;
  }
}
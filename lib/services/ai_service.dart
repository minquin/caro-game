import 'dart:math';

import '../core/enums/trang_thai_o.dart';
import '../models/ban_co_model.dart';
import '../services/bo_xu_ly_luat.dart';

/// Dịch vụ lựa chọn nước đi cho máy.
/// Không phụ thuộc vào giao diện, đồng hồ hoặc vòng đời trận đấu.
class AiService {
  static const int _banKinhTimKiem = 2;

  /// Tính thời gian suy nghĩ dựa trên số ô ứng viên, giữ nhịp phản hồi
  /// tương tự phiên bản AI trước khi tách service.
  static Duration tinhThoiGianSuyNghi(BanCoModel banCo) {
    final soOUngVien = _layOUngVien(banCo).length;
    final tongSoO = banCo.kichThuoc * banCo.kichThuoc;
    final milliseconds =
        ((soOUngVien / tongSoO) * 700 + 350)
            .round()
            .clamp(350, 1050)
            .toInt();
    return Duration(milliseconds: milliseconds);
  }

  /// Trả về tọa độ nước đi tốt nhất của AI, hoặc null nếu không còn ô trống.
  /// AI ưu tiên thắng ngay, sau đó chặn nước thắng của đối thủ, cuối cùng
  /// mới chọn nước có điểm tấn công/phòng thủ cao nhất.
  static Point<int>? timNuocDiTotNhat({
    required BanCoModel banCo,
    required TrangThaiO quanAI,
    required TrangThaiO quanDoiThu,
  }) {
    if (quanAI == TrangThaiO.trong || quanDoiThu == TrangThaiO.trong) {
      throw ArgumentError('Quân AI và quân đối thủ không được để trống.');
    }

    final oUngVien = _layOUngVien(banCo);
    if (oUngVien.isEmpty) {
      final tam = banCo.kichThuoc ~/ 2;
      if (banCo.layTrangThaiO(tam, tam) == TrangThaiO.trong) {
        return Point<int>(tam, tam);
      }
      return null;
    }

    // Ưu tiên nước giúp AI thắng ngay.
    for (final o in oUngVien) {
      if (_thuNuocDiVaKiemTraThang(banCo, o, quanAI)) return o;
    }

    // Nếu chưa thể thắng, chặn nước thắng ngay của đối thủ.
    for (final o in oUngVien) {
      if (_thuNuocDiVaKiemTraThang(banCo, o, quanDoiThu)) return o;
    }

    var nuocDiTotNhat = oUngVien.first;
    var diemCaoNhat = -1;
    final tamBanCo = (banCo.kichThuoc - 1) / 2;

    for (final o in oUngVien) {
      final diemTanCong = _tinhDiemSauKhiDat(banCo, o, quanAI);
      final diemPhongThu = _tinhDiemSauKhiDat(banCo, o, quanDoiThu);
      final khoangCachDenTam =
          (o.x - tamBanCo).abs() + (o.y - tamBanCo).abs();
      final diem = diemTanCong + (diemPhongThu * 1.1).round() -
          khoangCachDenTam.round();

      if (diem > diemCaoNhat) {
        diemCaoNhat = diem;
        nuocDiTotNhat = o;
      }
    }

    return nuocDiTotNhat;
  }

  static bool _thuNuocDiVaKiemTraThang(
    BanCoModel banCo,
    Point<int> o,
    TrangThaiO quan,
  ) {
    banCo.datTrangThaiO(o.x, o.y, quan);
    try {
      return BoXuLyLuat.kiemTraThang(banCo, o.x, o.y, quan);
    } finally {
      banCo.datTrangThaiO(o.x, o.y, TrangThaiO.trong);
    }
  }

  static int _tinhDiemSauKhiDat(
    BanCoModel banCo,
    Point<int> o,
    TrangThaiO quan,
  ) {
    banCo.datTrangThaiO(o.x, o.y, quan);
    try {
      return _danhGiaNuocTai(banCo, o.x, o.y);
    } finally {
      banCo.datTrangThaiO(o.x, o.y, TrangThaiO.trong);
    }
  }

  static List<Point<int>> _layOUngVien(BanCoModel banCo) {
    final ketQua = <Point<int>>[];
    for (var r = 0; r < banCo.kichThuoc; r++) {
      for (var c = 0; c < banCo.kichThuoc; c++) {
        if (banCo.layTrangThaiO(r, c) == TrangThaiO.trong &&
            _coQuanXungQuanh(banCo, r, c, _banKinhTimKiem)) {
          ketQua.add(Point<int>(r, c));
        }
      }
    }
    return ketQua;
  }

  static int _danhGiaNuocTai(BanCoModel banCo, int r, int c) {
    const directions = [
      [0, 1],
      [1, 0],
      [1, 1],
      [1, -1],
    ];
    var diem = 0;
    final n = banCo.kichThuoc;
    final quanDangXet = banCo.layTrangThaiO(r, c);

    for (final direction in directions) {
      final dr = direction[0];
      final dc = direction[1];
      var soQuan = 1;
      var dauMo = 0;

      for (final huong in [-1, 1]) {
        var rKe = r + dr * huong;
        var cKe = c + dc * huong;
        while (rKe >= 0 &&
            rKe < n &&
            cKe >= 0 &&
            cKe < n &&
            banCo.layTrangThaiO(rKe, cKe) == quanDangXet) {
          soQuan++;
          rKe += dr * huong;
          cKe += dc * huong;
        }
        if (rKe >= 0 &&
            rKe < n &&
            cKe >= 0 &&
            cKe < n &&
            banCo.layTrangThaiO(rKe, cKe) == TrangThaiO.trong) {
          dauMo++;
        }
      }

      if (soQuan >= 5) return 1000000000;
      if (soQuan == 4) {
        diem += dauMo == 2 ? 10000000 : (dauMo == 1 ? 1000000 : 0);
      } else if (soQuan == 3) {
        diem += dauMo == 2 ? 100000 : (dauMo == 1 ? 10000 : 0);
      } else if (soQuan == 2) {
        diem += dauMo == 2 ? 1000 : (dauMo == 1 ? 100 : 0);
      } else if (soQuan == 1 && dauMo > 0) {
        diem += 10;
      }
    }
    return diem;
  }

  static bool _coQuanXungQuanh(
    BanCoModel banCo,
    int r,
    int c,
    int banKinh,
  ) {
    for (var dr = -banKinh; dr <= banKinh; dr++) {
      for (var dc = -banKinh; dc <= banKinh; dc++) {
        if (banCo.layTrangThaiO(r + dr, c + dc) != TrangThaiO.trong) {
          return true;
        }
      }
    }
    return false;
  }
}

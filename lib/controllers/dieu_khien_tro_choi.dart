import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/am_thanh_helper.dart';
import '../core/enums/trang_thai_o.dart';
import '../core/enums/loai_nguoi_choi.dart';

class NguoiChoi {
  final String tenHienThi;
  final LoaiNguoiChoi loaiQuan;
  int diemSo = 0;

  NguoiChoi({required this.tenHienThi, required this.loaiQuan});
}

class DieuKhienTroChoi extends ChangeNotifier {
  final int kichThuoc; // Kích thước cố định (7, 10, 15)
  late List<List<TrangThaiO>> banCo;

  late NguoiChoi nguoiChoi1;
  late NguoiChoi nguoiChoi2;
  late NguoiChoi luotHienTai;

  bool troChoiKetThuc = false;
  String thongBaoKetQua = '';

  int thoiGianConLai = 30;
  Timer? _dongHoDemNguoc;

  bool laDauVoiMay = false;
  int soVanDau = 0;

  // 🎯 Thêm 2 biến lưu tọa độ đầu và cuối để vẽ đường gạch chiến thắng
  Point<int>? diemDauThang;
  Point<int>? diemCuoiThang;

  DieuKhienTroChoi({required this.kichThuoc, this.laDauVoiMay = false}) {
    nguoiChoi1 =
        NguoiChoi(tenHienThi: 'Người chơi A', loaiQuan: LoaiNguoiChoi.x);
    nguoiChoi2 = NguoiChoi(
      tenHienThi: laDauVoiMay ? 'Máy (AI)' : 'Người chơi B',
      loaiQuan: LoaiNguoiChoi.o,
    );
    khoiTaoBanCo();
  }

  void khoiTaoBanCo() {
    _dongHoDemNguoc?.cancel();
    banCo = List.generate(
        kichThuoc, (_) => List.filled(kichThuoc, TrangThaiO.trong));

    soVanDau++;
    luotHienTai = (soVanDau % 2 != 0) ? nguoiChoi1 : nguoiChoi2;

    troChoiKetThuc = false;
    thongBaoKetQua = '';
    diemDauThang = null;
    diemCuoiThang = null;

    _batDauDongHo();
    notifyListeners();

    if (laDauVoiMay && luotHienTai == nguoiChoi2 && !troChoiKetThuc) {
      _mayDanhAI();
    }
  }

  void _batDauDongHo() {
    _dongHoDemNguoc?.cancel();
    thoiGianConLai = 30;

    _dongHoDemNguoc = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (troChoiKetThuc) {
        timer.cancel();
        return;
      }

      if (thoiGianConLai > 0) {
        thoiGianConLai--;
        notifyListeners();
      } else {
        timer.cancel();
        _xuLyHetGio();
      }
    });
  }

  void _xuLyHetGio() {
    if (troChoiKetThuc) return;
    AmThanhHelper.phatAmThanh('lose.wav');
    troChoiKetThuc = true;
    NguoiChoi nguoiThang =
        (luotHienTai == nguoiChoi1) ? nguoiChoi2 : nguoiChoi1;
    nguoiThang.diemSo++;
    thongBaoKetQua =
        'Hết giờ! ${luotHienTai.tenHienThi} thua cuộc!\n${nguoiThang.tenHienThi} Chiến Thắng! ⏰';
    notifyListeners();
  }

  void choiLai() => khoiTaoBanCo();

  void dauHang() {
    if (troChoiKetThuc) return;
    troChoiKetThuc = true;
    _dongHoDemNguoc?.cancel();
    NguoiChoi nguoiThang =
        (luotHienTai == nguoiChoi1) ? nguoiChoi2 : nguoiChoi1;
    nguoiThang.diemSo++;

    if (laDauVoiMay && luotHienTai == nguoiChoi1) {
      thongBaoKetQua = 'Bạn đã Đầu Hàng và Thua cuộc! 😢';
      AmThanhHelper.phatAmThanh('lose.wav');
    } else {
      thongBaoKetQua =
          '${luotHienTai.tenHienThi} Đầu Hàng!\n${nguoiThang.tenHienThi} Chiến Thắng! 🎉';
      AmThanhHelper.phatAmThanh('win.wav');
    }
    notifyListeners();
  }

  TrangThaiO layTrangThai(int r, int c) {
    if (r < 0 || r >= banCo.length || c < 0 || c >= banCo[0].length) {
      return TrangThaiO.trong;
    }
    return banCo[r][c];
  }

  void xuLyNuocDi(int r, int c) {
    if (troChoiKetThuc) return;
    if (laDauVoiMay && luotHienTai == nguoiChoi2) return;
    _thucHienNuocDi(r, c);
  }

  void _thucHienNuocDi(int r, int c) {
    if (troChoiKetThuc) return;
    if (r < 0 || r >= banCo.length || c < 0 || c >= banCo[0].length) return;
    if (banCo[r][c] != TrangThaiO.trong) return;

    TrangThaiO quanHienTai =
        (luotHienTai.loaiQuan == LoaiNguoiChoi.x) ? TrangThaiO.x : TrangThaiO.o;
    banCo[r][c] = quanHienTai;

    if (kiemTraChienThang(r, c, quanHienTai)) {
      troChoiKetThuc = true;
      _dongHoDemNguoc?.cancel();
      luotHienTai.diemSo++;

      if (laDauVoiMay && luotHienTai == nguoiChoi2) {
        thongBaoKetQua = 'Bạn đã Thua mất rồi! 😢';
        AmThanhHelper.phatAmThanh('lose.wav');
      } else {
        thongBaoKetQua = '${luotHienTai.tenHienThi} Chiến Thắng! 🎉';
        AmThanhHelper.phatAmThanh('win.wav');
      }

      notifyListeners();
      return;
    }

    if (kiemTraHoa()) {
      troChoiKetThuc = true;
      _dongHoDemNguoc?.cancel();
      thongBaoKetQua = 'Ván đấu Hòa! 🤝';
      AmThanhHelper.phatAmThanh('draw.mp3');
      notifyListeners();
      return;
    }

    if (quanHienTai == TrangThaiO.o) {
      AmThanhHelper.phatAmThanhQuanCo('15_E2.mp3');
    } else {
      AmThanhHelper.phatAmThanhQuanCo('16_F2.mp3');
    }

    luotHienTai = (luotHienTai == nguoiChoi1) ? nguoiChoi2 : nguoiChoi1;
    _batDauDongHo();
    notifyListeners();

    if (laDauVoiMay && luotHienTai == nguoiChoi2 && !troChoiKetThuc) {
      _mayDanhAI();
    }
  }

  bool kiemTraChienThang(int r, int c, TrangThaiO quan) {
    List<List<int>> directions = [
      [0, 1],
      [1, 0],
      [1, 1],
      [1, -1]
    ];

    for (var dir in directions) {
      if (_kiemTraDuongThang(r, c, dir[0], dir[1], quan)) {
        return true;
      }
    }
    return false;
  }

  bool _kiemTraDuongThang(
      int r, int c, int dr, int dc, TrangThaiO quan) {
    int n = banCo.length;
    int r1 = r, c1 = c;
    while (r1 - dr >= 0 &&
        r1 - dr < n &&
        c1 - dc >= 0 &&
        c1 - dc < n &&
        banCo[r1 - dr][c1 - dc] == quan) {
      r1 -= dr;
      c1 -= dc;
    }

    int r2 = r, c2 = c;
    while (r2 + dr >= 0 &&
        r2 + dr < n &&
        c2 + dc >= 0 &&
        c2 + dc < n &&
        banCo[r2 + dr][c2 + dc] == quan) {
      r2 += dr;
      c2 += dc;
    }

    int length = 0;
    int currR = r1, currC = c1;
    while (true) {
      length++;
      if (currR == r2 && currC == c2) break;
      currR += dr;
      currC += dc;
    }

    if (length >= 5) {
      diemDauThang = Point(r1, c1);
      diemCuoiThang = Point(r2, c2);
      return true;
    }

    return false;
  }

  bool kiemTraHoa() {
    for (var hang in banCo) {
      for (var o in hang) {
        if (o == TrangThaiO.trong) return false;
      }
    }
    return true;
  }

  void _mayDanhAI() {
    final oUngVien = <Point<int>>[];
    for (var r = 0; r < banCo.length; r++) {
      for (var c = 0; c < banCo[r].length; c++) {
        if (banCo[r][c] == TrangThaiO.trong &&
            _coQuanXungQuanh(r, c, 2)) {
          oUngVien.add(Point(r, c));
        }
      }
    }

    final thoiGianSuyNghi =
        ((oUngVien.length / (banCo.length * banCo.length)) * 700 + 350)
            .round()
            .clamp(350, 1050)
            .toInt();

    Future.delayed(Duration(milliseconds: thoiGianSuyNghi), () {
      if (troChoiKetThuc) return;
      if (!laDauVoiMay || luotHienTai != nguoiChoi2) return;

      TrangThaiO quanAI = (nguoiChoi2.loaiQuan == LoaiNguoiChoi.x)
          ? TrangThaiO.x
          : TrangThaiO.o;
      TrangThaiO quanUser = (nguoiChoi1.loaiQuan == LoaiNguoiChoi.x)
          ? TrangThaiO.x
          : TrangThaiO.o;

      if (oUngVien.isEmpty) {
        final tam = banCo.length ~/ 2;
        _thucHienNuocDi(tam, tam);
        return;
      }

      for (final o in oUngVien) {
        banCo[o.x][o.y] = quanAI;
        if (kiemTraChienThang(o.x, o.y, quanAI)) {
          banCo[o.x][o.y] = TrangThaiO.trong;
          _thucHienNuocDi(o.x, o.y);
          return;
        }
        banCo[o.x][o.y] = TrangThaiO.trong;
      }

      for (final o in oUngVien) {
        banCo[o.x][o.y] = quanUser;
        if (kiemTraChienThang(o.x, o.y, quanUser)) {
          banCo[o.x][o.y] = TrangThaiO.trong;
          _thucHienNuocDi(o.x, o.y);
          return;
        }
        banCo[o.x][o.y] = TrangThaiO.trong;
      }

      Point<int> nuocDiTotNhat = oUngVien.first;
      var diemCaoNhat = -1;
      final tamBanCo = (banCo.length - 1) / 2;

      for (final o in oUngVien) {
        banCo[o.x][o.y] = quanAI;
        final diemTanCong = _danhGiaNuocTai(o.x, o.y);
        banCo[o.x][o.y] = TrangThaiO.trong;

        banCo[o.x][o.y] = quanUser;
        final diemPhongThu = _danhGiaNuocTai(o.x, o.y);
        banCo[o.x][o.y] = TrangThaiO.trong;

        final khoangCachDenTam =
            (o.x - tamBanCo).abs() + (o.y - tamBanCo).abs();
        final diem = diemTanCong +
            (diemPhongThu * 1.1).round() -
            khoangCachDenTam.round();

        if (diem > diemCaoNhat) {
          diemCaoNhat = diem;
          nuocDiTotNhat = o;
        }
      }

      _thucHienNuocDi(nuocDiTotNhat.x, nuocDiTotNhat.y);
    });
  }

  int _danhGiaNuocTai(int r, int c) {
    const directions = [
      [0, 1],
      [1, 0],
      [1, 1],
      [1, -1],
    ];
    var diem = 0;
    final n = banCo.length;

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
            banCo[rKe][cKe] == banCo[r][c]) {
          soQuan++;
          rKe += dr * huong;
          cKe += dc * huong;
        }
        if (rKe >= 0 &&
            rKe < n &&
            cKe >= 0 &&
            cKe < n &&
            banCo[rKe][cKe] == TrangThaiO.trong) {
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

  bool _coQuanXungQuanh(int r, int c, int banKinh) {
    for (int dr = -banKinh; dr <= banKinh; dr++) {
      for (int dc = -banKinh; dc <= banKinh; dc++) {
        if (layTrangThai(r + dr, c + dc) != TrangThaiO.trong) {
          return true;
        }
      }
    }
    return false;
  }

  void resetDiemSo() {
    nguoiChoi1.diemSo = 0;
    nguoiChoi2.diemSo = 0;
    soVanDau = 0;
    khoiTaoBanCo();
  }

  bool xinHoa() {
    if (laDauVoiMay) return Random().nextBool();
    return true;
  }

  @override
  void dispose() {
    _dongHoDemNguoc?.cancel();
    super.dispose();
  }
}
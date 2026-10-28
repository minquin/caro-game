import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../core/enums/trang_thai_o.dart';
import '../core/enums/loai_nguoi_choi.dart';

class NguoiChoi {
  final String tenHienThi;
  final LoaiNguoiChoi loaiQuan;
  int diemSo = 0;

  NguoiChoi({required this.tenHienThi, required this.loaiQuan});
}

class DieuKhienTroChoi extends ChangeNotifier {
  final int kichThuoc; // Kích thước cố định (3, 5, 7, 10, 15)
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
    thongBaoKetQua =
        '${luotHienTai.tenHienThi} Đầu Hàng!\n${nguoiThang.tenHienThi} Chiến Thắng! 🎉';
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
      thongBaoKetQua = '${luotHienTai.tenHienThi} Chiến Thắng! 🎉';
      notifyListeners();
      return;
    }

    if (kiemTraHoa()) {
      troChoiKetThuc = true;
      _dongHoDemNguoc?.cancel();
      thongBaoKetQua = 'Ván đấu Hòa! 🤝';
      notifyListeners();
      return;
    }

    luotHienTai = (luotHienTai == nguoiChoi1) ? nguoiChoi2 : nguoiChoi1;
    _batDauDongHo();
    notifyListeners();

    if (laDauVoiMay && luotHienTai == nguoiChoi2 && !troChoiKetThuc) {
      _mayDanhAI();
    }
  }

  bool kiemTraChienThang(int r, int c, TrangThaiO quan) {
    TrangThaiO doiThu = (quan == TrangThaiO.x) ? TrangThaiO.o : TrangThaiO.x;
    List<List<int>> directions = [
      [0, 1],
      [1, 0],
      [1, 1],
      [1, -1]
    ];

    for (var dir in directions) {
      if (_kiemTraDuongThang(r, c, dir[0], dir[1], quan, doiThu)) {
        return true;
      }
    }
    return false;
  }

  bool _kiemTraDuongThang(
      int r, int c, int dr, int dc, TrangThaiO quan, TrangThaiO doiThu) {
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

    if (kichThuoc == 3) {
      return length >= 3;
    }

    int blockCount = 0;
    int end1R = r1 - dr, end1C = c1 - dc;
    if (end1R >= 0 && end1R < n && end1C >= 0 && end1C < n) {
      if (banCo[end1R][end1C] == doiThu) blockCount++;
    }

    int end2R = r2 + dr, end2C = c2 + dc;
    if (end2R >= 0 && end2R < n && end2C >= 0 && end2C < n) {
      if (banCo[end2R][end2C] == doiThu) blockCount++;
    }

    if (length == 4 && blockCount == 0) return true;
    if (length >= 5 && blockCount <= 1) return true;

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

  // ==========================================================================
  // 🤖 AI SIÊU CẤP: KIỂM TRA KHẨN CẤP + MINIMAX ALPHA-BETA
  // ==========================================================================
  void _mayDanhAI() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (troChoiKetThuc) return;
      if (!laDauVoiMay || luotHienTai != nguoiChoi2) return;

      TrangThaiO quanAI = (nguoiChoi2.loaiQuan == LoaiNguoiChoi.x)
          ? TrangThaiO.x
          : TrangThaiO.o;
      TrangThaiO quanUser = (nguoiChoi1.loaiQuan == LoaiNguoiChoi.x)
          ? TrangThaiO.x
          : TrangThaiO.o;

      List<Point<int>> oTrongs = [];
      for (int i = 0; i < banCo.length; i++) {
        for (int j = 0; j < banCo[i].length; j++) {
          if (banCo[i][j] == TrangThaiO.trong) {
            if (banCo.length <= 5 || _coQuanXungQuanh(i, j, 2)) {
              oTrongs.add(Point(i, j));
            }
          }
        }
      }

      if (oTrongs.isEmpty) {
        int tam = banCo.length ~/ 2;
        _thucHienNuocDi(tam, tam);
        return;
      }

      // 🚨 BƯỚC 1: AI THẤY CƠ HỘI CHIẾN THẮNG NGAY LẬP TỨC ➔ ĐÁNH LUÔN
      for (var o in oTrongs) {
        banCo[o.x][o.y] = quanAI;
        if (kiemTraChienThang(o.x, o.y, quanAI)) {
          banCo[o.x][o.y] = TrangThaiO.trong;
          _thucHienNuocDi(o.x, o.y);
          return;
        }
        banCo[o.x][o.y] = TrangThaiO.trong;
      }

      // 🚨 BƯỚC 2: NGƯỜI CHƠI SẮP THẮNG Ở LƯỢT TIẾP THEO ➔ CHẶN ĐẦU NGAY LẬP TỨC
      for (var o in oTrongs) {
        banCo[o.x][o.y] = quanUser;
        if (kiemTraChienThang(o.x, o.y, quanUser)) {
          banCo[o.x][o.y] = TrangThaiO.trong;
          _thucHienNuocDi(o.x, o.y);
          return;
        }
        banCo[o.x][o.y] = TrangThaiO.trong;
      }

      // 🧠 BƯỚC 3: DÙNG MINIMAX ĐỂ TÍNH TOÁN CHIẾN THUẬT SÂU HƠN
      Point<int>? nuocDiTotNhat;
      int diemCaoNhat = -9999999;
      int doSau = (banCo.length <= 5) ? 3 : 2;

      for (var o in oTrongs) {
        banCo[o.x][o.y] = quanAI;
        int diem =
            _minimax(doSau - 1, false, -10000000, 10000000, quanAI, quanUser);
        banCo[o.x][o.y] = TrangThaiO.trong;

        if (diem > diemCaoNhat) {
          diemCaoNhat = diem;
          nuocDiTotNhat = o;
        }
      }

      if (nuocDiTotNhat != null) {
        _thucHienNuocDi(nuocDiTotNhat.x, nuocDiTotNhat.y);
      } else {
        Point<int> fallback = oTrongs[Random().nextInt(oTrongs.length)];
        _thucHienNuocDi(fallback.x, fallback.y);
      }
    });
  }

  int _minimax(int depth, bool isMaximizing, int alpha, int beta,
      TrangThaiO quanAI, TrangThaiO quanUser) {
    if (depth == 0) {
      return _danhGiaToanBoBanCo(quanAI, quanUser);
    }

    List<Point<int>> oTrongs = [];
    for (int i = 0; i < banCo.length; i++) {
      for (int j = 0; j < banCo[i].length; j++) {
        if (banCo[i][j] == TrangThaiO.trong) {
          if (_coQuanXungQuanh(i, j, 2)) {
            oTrongs.add(Point(i, j));
          }
        }
      }
    }

    if (oTrongs.isEmpty) return 0;

    if (isMaximizing) {
      int maxEval = -10000000;
      for (var o in oTrongs) {
        banCo[o.x][o.y] = quanAI;
        if (kiemTraChienThang(o.x, o.y, quanAI)) {
          banCo[o.x][o.y] = TrangThaiO.trong;
          return 1000000 + depth * 1000;
        }
        int eval = _minimax(depth - 1, false, alpha, beta, quanAI, quanUser);
        banCo[o.x][o.y] = TrangThaiO.trong;

        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);
        if (beta <= alpha) break;
      }
      return maxEval;
    } else {
      int minEval = 10000000;
      for (var o in oTrongs) {
        banCo[o.x][o.y] = quanUser;
        if (kiemTraChienThang(o.x, o.y, quanUser)) {
          banCo[o.x][o.y] = TrangThaiO.trong;
          return -1000000 - depth * 1000;
        }
        int eval = _minimax(depth - 1, true, alpha, beta, quanAI, quanUser);
        banCo[o.x][o.y] = TrangThaiO.trong;

        minEval = min(minEval, eval);
        beta = min(beta, eval);
        if (beta <= alpha) break;
      }
      return minEval;
    }
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

  int _danhGiaToanBoBanCo(TrangThaiO quanAI, TrangThaiO quanUser) {
    int diemAI = _demTongChuoi(quanAI);
    int diemUser = _demTongChuoi(quanUser);
    return diemAI - (diemUser * 150); // Tăng trọng số phòng thủ lên tối đa
  }

  int _demTongChuoi(TrangThaiO quan) {
    int tongDiem = 0;
    int n = banCo.length;
    List<List<int>> directions = [
      [0, 1],
      [1, 0],
      [1, 1],
      [1, -1]
    ];

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (banCo[i][j] == quan) {
          for (var dir in directions) {
            int count = 1;
            int r = i + dir[0], c = j + dir[1];
            while (r >= 0 && r < n && c >= 0 && c < n && banCo[r][c] == quan) {
              count++;
              r += dir[0];
              c += dir[1];
            }
            if (count == 2) tongDiem += 10;
            if (count == 3) tongDiem += 1000;
            if (count == 4) tongDiem += 50000;
            if (count >= 5) tongDiem += 500000;
          }
        }
      }
    }
    return tongDiem;
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

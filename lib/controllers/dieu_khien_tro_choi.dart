import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../services/am_thanh_service.dart';
import '../services/ai_service.dart';
import '../core/enums/trang_thai_o.dart';
import '../core/enums/loai_nguoi_choi.dart';
import '../models/ban_co_model.dart';
import '../models/nguoi_choi_model.dart';
import '../services/bo_xu_ly_luat.dart';

class DieuKhienTroChoi extends ChangeNotifier {
  final int kichThuoc; // Kích thước cố định (7, 10, 15)
  late BanCoModel _banCoModel;
  List<List<TrangThaiO>> get banCo => _banCoModel.oCo;

  late NguoiChoiModel nguoiChoi1;
  late NguoiChoiModel nguoiChoi2;
  late NguoiChoiModel luotHienTai;

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
        NguoiChoiModel(maSo: 'A', tenHienThi: 'Người chơi A', loaiQuan: LoaiNguoiChoi.x);
    nguoiChoi2 = NguoiChoiModel(
      maSo: 'B',
      tenHienThi: laDauVoiMay ? 'Máy (AI)' : 'Người chơi B',
      loaiQuan: LoaiNguoiChoi.o,
    );
    khoiTaoBanCo();
  }

  void khoiTaoBanCo() {
    _dongHoDemNguoc?.cancel();
    _banCoModel = BanCoModel(kichThuoc: kichThuoc);

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
    AmThanhService.phatAmThanh('lose.wav');
    troChoiKetThuc = true;
    NguoiChoiModel nguoiThang =
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
    NguoiChoiModel nguoiThang =
        (luotHienTai == nguoiChoi1) ? nguoiChoi2 : nguoiChoi1;
    nguoiThang.diemSo++;

    if (laDauVoiMay && luotHienTai == nguoiChoi1) {
      thongBaoKetQua = 'Bạn đã Đầu Hàng và Thua cuộc! 😢';
      AmThanhService.phatAmThanh('lose.wav');
    } else {
      thongBaoKetQua =
          '${luotHienTai.tenHienThi} Đầu Hàng!\n${nguoiThang.tenHienThi} Chiến Thắng! 🎉';
      AmThanhService.phatAmThanh('win.wav');
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
    _banCoModel.datTrangThaiO(r, c, quanHienTai);

    if (kiemTraChienThang(r, c, quanHienTai)) {
      troChoiKetThuc = true;
      _dongHoDemNguoc?.cancel();
      luotHienTai.diemSo++;

      if (laDauVoiMay && luotHienTai == nguoiChoi2) {
        thongBaoKetQua = 'Bạn đã Thua mất rồi! 😢';
        AmThanhService.phatAmThanh('lose.wav');
      } else {
        thongBaoKetQua = '${luotHienTai.tenHienThi} Chiến Thắng! 🎉';
        AmThanhService.phatAmThanh('win.wav');
      }

      notifyListeners();
      return;
    }

    if (kiemTraHoa()) {
      troChoiKetThuc = true;
      _dongHoDemNguoc?.cancel();
      thongBaoKetQua = 'Ván đấu Hòa! 🤝';
      AmThanhService.phatAmThanh('Draw.mp3');
      notifyListeners();
      return;
    }

    if (quanHienTai == TrangThaiO.o) {
      AmThanhService.phatAmThanhQuanCo('15_E2.mp3');
    } else {
      AmThanhService.phatAmThanhQuanCo('16_F2.mp3');
    }

    luotHienTai = (luotHienTai == nguoiChoi1) ? nguoiChoi2 : nguoiChoi1;
    _batDauDongHo();
    notifyListeners();

    if (laDauVoiMay && luotHienTai == nguoiChoi2 && !troChoiKetThuc) {
      _mayDanhAI();
    }
  }

  /// Controller chỉ điều phối việc kiểm tra luật và cập nhật dữ liệu
  /// phục vụ View (đường gạch đánh dấu chiến thắng).
  bool kiemTraChienThang(int r, int c, TrangThaiO quan) {
    final duongThang = BoXuLyLuat.timDuongThang(
      _banCoModel,
      r,
      c,
      quan,
    );

    if (duongThang == null) return false;

    diemDauThang = duongThang[0];
    diemCuoiThang = duongThang[1];
    return true;
  }

  bool kiemTraHoa() => BoXuLyLuat.kiemTraHoa(_banCoModel);

  /// Yêu cầu AiService chọn nước đi; Controller chỉ quản lý thời điểm
  /// và áp dụng nước đi vào trạng thái trận đấu.
  void _mayDanhAI() {
    final thoiGianSuyNghi = AiService.tinhThoiGianSuyNghi(_banCoModel);

    Future.delayed(thoiGianSuyNghi, () {
      if (troChoiKetThuc) return;
      if (!laDauVoiMay || luotHienTai != nguoiChoi2) return;

      final quanAI = nguoiChoi2.loaiQuan == LoaiNguoiChoi.x
          ? TrangThaiO.x
          : TrangThaiO.o;
      final quanUser = nguoiChoi1.loaiQuan == LoaiNguoiChoi.x
          ? TrangThaiO.x
          : TrangThaiO.o;

      final nuocDi = AiService.timNuocDiTotNhat(
        banCo: _banCoModel,
        quanAI: quanAI,
        quanDoiThu: quanUser,
      );

      if (nuocDi != null) {
        _thucHienNuocDi(nuocDi.x, nuocDi.y);
      }
    });
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
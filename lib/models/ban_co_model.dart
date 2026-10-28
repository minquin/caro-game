import '../core/enums/trang_thai_o.dart';
import '../utils/ho_tro_toa_do.dart';

class BanCoModel {
  final int kichThuoc; // 0 nghĩa là bàn cờ vô hạn
  final Map<String, TrangThaiO> danhSachOCo = {};

  BanCoModel({required this.kichThuoc});

  bool get laVoHan => kichThuoc == 0;

  TrangThaiO layTrangThaiO(int x, int y) {
    if (!laVoHan && (x < 0 || x >= kichThuoc || y < 0 || y >= kichThuoc)) {
      return TrangThaiO.trong;
    }
    return danhSachOCo[HoTroToaDo.taoKhoa(x, y)] ?? TrangThaiO.trong;
  }

  void datTrangThaiO(int x, int y, TrangThaiO trangThai) {
    danhSachOCo[HoTroToaDo.taoKhoa(x, y)] = trangThai;
  }

  void xoaBanCo() {
    danhSachOCo.clear();
  }

  bool daDayBanCo() {
    if (laVoHan) return false;
    return danhSachOCo.length >= (kichThuoc * kichThuoc);
  }
}
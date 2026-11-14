import '../core/enums/trang_thai_o.dart';

/// Model quản lý trạng thái các ô trên bàn cờ Caro.
class BanCoModel {
  final int kichThuoc;
  late final List<List<TrangThaiO>> oCo;

  // Dự án hiện triển khai bàn cờ hữu hạn. Giữ thuộc tính này để
  // tương thích với bộ kiểm tra luật đang có trong controllers.
  bool get laVoHan => false;

  BanCoModel({required this.kichThuoc}) {
    if (kichThuoc <= 0) {
      throw ArgumentError.value(kichThuoc, 'kichThuoc', 'Phải lớn hơn 0');
    }
    oCo = List.generate(
      kichThuoc,
      (_) => List.filled(kichThuoc, TrangThaiO.trong),
    );
  }

  TrangThaiO layTrangThaiO(int hang, int cot) {
    if (!_hopLe(hang, cot)) return TrangThaiO.trong;
    return oCo[hang][cot];
  }

  bool datTrangThaiO(int hang, int cot, TrangThaiO trangThai) {
    if (!_hopLe(hang, cot)) return false;
    oCo[hang][cot] = trangThai;
    return true;
  }

  void xoaBanCo() {
    for (final hang in oCo) {
      hang.fillRange(0, hang.length, TrangThaiO.trong);
    }
  }

  bool daDayBanCo() => oCo.every(
        (hang) => hang.every((o) => o != TrangThaiO.trong),
      );

  bool _hopLe(int hang, int cot) =>
      hang >= 0 && hang < kichThuoc && cot >= 0 && cot < kichThuoc;
}

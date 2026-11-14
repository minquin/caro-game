import '../services/am_thanh_service.dart';

/// Controller trung gian để View không gọi trực tiếp Audio Service.
class DieuKhienAmThanh {
  bool get dangTatNhacNen => AmThanhService.dangTatNhacNen;
  bool get dangTatTiengClick => AmThanhService.dangTatTiengClick;

  Future<void> phatAmThanh(String tenFile) =>
      AmThanhService.phatAmThanh(tenFile);

  Future<void> phatNhacNen(String tenFile) =>
      AmThanhService.phatNhacNen(tenFile);

  void toggleNhacNen() => AmThanhService.toggleNhacNen();
  void toggleTiengClick() => AmThanhService.toggleTiengClick();
}

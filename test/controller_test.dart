import 'package:flutter_test/flutter_test.dart';
import 'package:caro_project_cnttk25/controllers/dieu_khien_tro_choi.dart';
import 'package:caro_project_cnttk25/core/enums/trang_thai_o.dart';

void main() {
  group('DieuKhienTroChoi', () {
    test('switches turn after a valid move and ignores an occupied cell', () {
      final game = DieuKhienTroChoi(kichThuoc: 7);
      addTearDown(game.dispose);

      expect(game.luotHienTai, game.nguoiChoi1);
      game.xuLyNuocDi(2, 2);

      expect(game.banCo[2][2], TrangThaiO.x);
      expect(game.luotHienTai, game.nguoiChoi2);

      game.xuLyNuocDi(2, 2);
      expect(game.banCo[2][2], TrangThaiO.x);
      expect(game.luotHienTai, game.nguoiChoi2);
    });

    test('ends the game and awards a point after five consecutive pieces', () {
      final game = DieuKhienTroChoi(kichThuoc: 7);
      addTearDown(game.dispose);

      for (var column = 1; column <= 5; column++) {
        game.xuLyNuocDi(3, column);
        if (column < 5) {
          game.xuLyNuocDi(0, column - 1);
        }
      }

      expect(game.troChoiKetThuc, isTrue);
      expect(game.nguoiChoi1.diemSo, 1);
      expect(game.diemDauThang, isNotNull);
      expect(game.diemCuoiThang, isNotNull);
      expect(game.thongBaoKetQua, contains('Chiến Thắng'));
    });

    test('resets board and result state when starting a new round', () {
      final game = DieuKhienTroChoi(kichThuoc: 7);
      addTearDown(game.dispose);

      game.xuLyNuocDi(2, 2);
      game.choiLai();

      expect(game.banCo[2][2], TrangThaiO.trong);
      expect(game.troChoiKetThuc, isFalse);
      expect(game.thongBaoKetQua, isEmpty);
      expect(game.diemDauThang, isNull);
      expect(game.diemCuoiThang, isNull);
    });
  });
}

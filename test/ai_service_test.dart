import 'package:flutter_test/flutter_test.dart';
import 'package:caro_project_cnttk25/core/enums/trang_thai_o.dart';
import 'package:caro_project_cnttk25/models/ban_co_model.dart';
import 'package:caro_project_cnttk25/services/ai_service.dart';

void main() {
  test('AI chooses a winning move when four pieces are in a row', () {
    final board = BanCoModel(kichThuoc: 7);
    for (var column = 1; column <= 4; column++) {
      board.datTrangThaiO(3, column, TrangThaiO.o);
    }

    final move = AiService.timNuocDiTotNhat(
      banCo: board,
      quanAI: TrangThaiO.o,
      quanDoiThu: TrangThaiO.x,
    );

    expect(move, isNotNull);
    expect(move!.x, 3);
    expect([0, 5], contains(move.y));
  });

  test('AI blocks opponent winning move', () {
    final board = BanCoModel(kichThuoc: 7);
    for (var column = 1; column <= 4; column++) {
      board.datTrangThaiO(3, column, TrangThaiO.x);
    }

    final move = AiService.timNuocDiTotNhat(
      banCo: board,
      quanAI: TrangThaiO.o,
      quanDoiThu: TrangThaiO.x,
    );

    expect(move, isNotNull);
    expect(move!.x, 3);
    expect([0, 5], contains(move.y));
  });

  test('AI returns center on an empty board', () {
    final board = BanCoModel(kichThuoc: 7);

    final move = AiService.timNuocDiTotNhat(
      banCo: board,
      quanAI: TrangThaiO.o,
      quanDoiThu: TrangThaiO.x,
    );

    expect(move, isNotNull);
    expect(move!.x, 3);
    expect(move.y, 3);
  });

  test('AI analysis does not leave temporary pieces on the board', () {
    final board = BanCoModel(kichThuoc: 7);
    board.datTrangThaiO(3, 3, TrangThaiO.x);

    AiService.timNuocDiTotNhat(
      banCo: board,
      quanAI: TrangThaiO.o,
      quanDoiThu: TrangThaiO.x,
    );

    expect(board.layTrangThaiO(3, 3), TrangThaiO.x);
    expect(
      board.oCo.expand((row) => row).where((cell) => cell == TrangThaiO.o),
      isEmpty,
    );
  });
}

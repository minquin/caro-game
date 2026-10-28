class HoTroToaDo {
  static String taoKhoa(int x, int y) => '$x,$y';

  static List<int> layToaDoTuKhoa(String khoa) {
    final phanDoan = khoa.split(',');
    return [int.parse(phanDoan[0]), int.parse(phanDoan[1])];
  }
}
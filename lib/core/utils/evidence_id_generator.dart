class EvidenceIdGenerator {
  static String generate() {
    final now = DateTime.now();

    final year = now.year;
    final milliseconds = now.millisecond.toString().padLeft(3, '0');

    final microseconds = now.microsecond.toString().padLeft(3, '0');

    final value =
        '${now.hour}${now.minute}${now.second}'
        '$milliseconds$microseconds';

    final code = value
        .replaceAll(RegExp(r'[^0-9]'), '')
        .padRight(8, '0')
        .substring(0, 8);

    return 'PL-$year-$code';
  }
}

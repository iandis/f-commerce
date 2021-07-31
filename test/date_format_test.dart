import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  test('DateFormat test', () {
    expect(
      DateFormat('yyyyMMdd').format(DateTime.now()),
      equals('20210731'),
    );
  });
}

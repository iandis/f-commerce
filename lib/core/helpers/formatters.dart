import 'package:intl/intl.dart' show NumberFormat;

final _priceFormatter = NumberFormat.currency(
  symbol: 'Rp',
);
class Formatters {
  static String formatPrice(dynamic price) => _priceFormatter.format(price);
}
import 'package:intl/intl.dart';

class CurrencyUtil {
  /// Formats a double to Indonesian Rupiah (e.g., Rp 10.000)
  static String formatRupiah(num value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }
}

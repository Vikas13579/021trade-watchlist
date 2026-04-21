class Formatters {
  Formatters._();

  static String formatPrice(double price) {
    if (price >= 1000) {
      final parts = price.toStringAsFixed(2).split('.');
      final intPart = parts[0];
      final decPart = parts[1];

      String result = '';
      int len = intPart.length;

      if (len > 3) {
        result = ',${intPart.substring(len - 3)}';
        len -= 3;
        while (len > 2) {
          result = ',${intPart.substring(len - 2, len)}$result';
          len -= 2;
        }
        result = '${intPart.substring(0, len)}$result';
      } else {
        result = intPart;
      }

      return '₹$result.$decPart';
    }
    return '₹${price.toStringAsFixed(2)}';
  }

  static String formatChange(double change) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}';
  }

  static String formatChangePercent(double percent) {
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(2)}%';
  }

  static String formatVolume(double volumeInMillions) {
    return '${volumeInMillions.toStringAsFixed(1)}M';
  }
}

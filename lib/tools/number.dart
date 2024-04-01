
String currencyFormat(double value) {
  String priceString = value.toStringAsFixed(0);
  RegExp regex = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
  String formattedPrice = priceString.replaceAllMapped(regex, (match) => '${match.group(1)},');
  return formattedPrice;
}
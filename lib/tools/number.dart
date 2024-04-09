
import 'dart:ffi';

import 'package:rsc/tools/entity/entity.dart';

String currencyFormat(double value) {
  String priceString = value.toStringAsFixed(0);
  RegExp regex = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
  String formattedPrice = priceString.replaceAllMapped(regex, (match) => '${match.group(1)},');
  return formattedPrice;
}

Map<ShortedNumberResultKeys, String> shortenNumber(double number) {
  final List<String> suffixes = ['К', 'млн', 'млрд', 'трлн'];
  int magnitude = 1000;
  int index = 0;
  
  while (number >= magnitude * 1000 && index < suffixes.length - 1) {
    magnitude *= 1000;
    index++;
  }

  double result = number / magnitude;
  String formattedResult = result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1);

  return {
    ShortedNumberResultKeys.value: formattedResult,
    ShortedNumberResultKeys.suffix: suffixes[index]
  };
}
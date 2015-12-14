import 'dart:io';
import 'dart:convert';

var totalAmount = 0;
main() async {
  var input = await new File('bin/day_12_input.txt').readAsString();

  parse(JSON.decode(input));

  print(totalAmount);
}

parse(input) {
  if (input is List) {
    input.forEach(parse);
  } else if (input is int) {
    totalAmount += input;
  } else if (input is Map) {
    if (input.keys.contains('red') || input.values.contains('red')) return;
    input.forEach((key, value) => parse(value));
  } else if (input is String) {
    // Ignore
  } else {
    throw new ArgumentError('Unsupported: $input');
  }
}

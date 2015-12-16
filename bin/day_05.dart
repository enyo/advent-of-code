import 'dart:io';

main() async {
  var input = (await new File('bin/day_05_input.txt').readAsString()).split('\n');

  var niceList = input.where((input) => isNice(input));
  print(niceList.length);

  niceList = input.where((input) => isNice2(input));
  print(niceList.length);
}

isNice(String input) {
  Iterable<Match> matches;

  // It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
  var vowelRegExp = new RegExp(r'[aeiou]');
  matches = vowelRegExp.allMatches(input);
  if (matches.length < 3) return false;

  // It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
  var twiceRegExp = new RegExp(r'(\w)\1');
  var match = twiceRegExp.firstMatch(input);
  if (match == null) return false;

  // It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
  var contains = ['ab', 'cd', 'pq', 'xy'].firstWhere((forbidden) => input.contains(forbidden), orElse: () => null);
  if (contains != null) return false;

  return true;
}

isNice2(String input) {
  // It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy)
  // or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
  var twoLetterPairs = <String>[];
  for (var i = 0; i < input.length - 1; i++) {
    twoLetterPairs.add(input[i] + input[i + 1]);
  }
  var hasPair = twoLetterPairs.firstWhere((pair) => pair.allMatches(input).length >= 2, orElse: () => null);
  if (hasPair == null) return false;

  // It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe),
  // or even aaa.
  var twiceRegExp = new RegExp(r'(\w).\1');
  var match = twiceRegExp.firstMatch(input);
  if (match == null) return false;

  return true;
}
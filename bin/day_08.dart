import 'dart:io';
import 'dart:convert';

main() async {
  var input = await new File('bin/day_08_input.txt').readAsString();
  var lines = input.split('\n');

  print(lines.map(countChars).fold(0, (prevValue, Count count) {
    return prevValue + count.literalCount - count.inMemoryCount;
  }));

  print(lines.map(countChars).fold(0, (prevValue, Count count) {
    return prevValue + count.newCount - count.literalCount;
  }));
}

class Count {
  final int literalCount;
  final int inMemoryCount;
  final int newCount;
  Count(this.literalCount, this.inMemoryCount, this.newCount);
  toString() => 'literal $literalCount inMemory $inMemoryCount newString $newCount';
}

Count countChars(String line) {
  var literal = line.length;
  var inMemory = line
      .substring(1, line.length - 1)
      .replaceAll(r'\"', r'_')
      .replaceAll(r'\\', r'_')
      .replaceAll(new RegExp(r'\\x..'), r'_')
      .length;
  var newCount = JSON.encode(line).length;
  return new Count(literal, inMemory, newCount);
}

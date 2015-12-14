import 'dart:io';

main() async {
  DateTime start, end;
  var input = '1113122113'.split('').map(int.parse).toList();

  start = new DateTime.now();
  for (var i = 0; i < 50; i++) {
    input = lookAndSay(input);
  }
  print(input.length);
  end = new DateTime.now();
  print(end.difference(start));

  // Now with bools to see if it's more efficient
  var inputBool = '1113122113'.split('').map(int.parse).map(_numberToBool).toList();

  start = new DateTime.now();
  for (var i = 0; i < 50; i++) {
    inputBool = lookAndSayBool(inputBool);
  }
  print(inputBool.length);
  end = new DateTime.now();
  print(end.difference(start));
}

bool _numberToBool(int number) {
  if (number == 1) return true;
  else if (number == 2) return false;
  else return null;
}

List<int> lookAndSay(List<int> input) {
  int prevNumber = null;
  var numberCount = 0;
  var newList = [];
  input.forEach((number) {
    if (prevNumber == number) {
      numberCount++;
    } else {
      if (prevNumber != null) {
        newList.add(numberCount);
        newList.add(prevNumber);
      }
      prevNumber = number;
      numberCount = 1;
    }
  });
  newList.add(numberCount);
  newList.add(prevNumber);
  return newList;
}

List<bool> lookAndSayBool(List<bool> input) {
  bool first = true;
  bool prevNumber = null;
  var numberCount = 0;
  var newList = [];
  input.forEach((number) {
    if (first) {
      prevNumber = number;
      numberCount = 1;
      first = false;
    } else {
      if (prevNumber == number) {
        numberCount++;
      } else {
        newList.add(_numberToBool(numberCount));
        newList.add(prevNumber);

        prevNumber = number;
        numberCount = 1;
      }
    }
  });
  newList.add(_numberToBool(numberCount));
  newList.add(prevNumber);
  return newList;
}

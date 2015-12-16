
/// This was just a test to see if it's faster to work with bool and null values instead of ints.
main() async {
  DateTime start, end;

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

List<bool> lookAndSayBool(List<bool> input) {
  bool first = true;
  bool prevNumber = null;
  var numberCount = 0;
  var newList = <bool>[];
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

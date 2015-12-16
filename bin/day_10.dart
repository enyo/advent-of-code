
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
}

List<int> lookAndSay(List<int> input) {
  int prevNumber = null;
  var numberCount = 0;
  var newList = <int>[];
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

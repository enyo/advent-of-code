import 'dart:io';

main() async {
  var input = (await new File('bin/day_03_input.txt').readAsString()).split('');

  var position = [0, 0], robotPosition = [0, 0];

  var isSecondStar = true;

  mapping[positionToString(position)] = 1; // The first house always gets one

  var i = 0;
  input.forEach((String direction) {
    var currentPosition = position;
    if (isSecondStar && i % 2 == 1) {
      currentPosition = robotPosition;
    }

    switch (direction) {
      case 'v':
        currentPosition[1]++;
        break;
      case '^':
        currentPosition[1]--;
        break;
      case '<':
        currentPosition[0]--;
        break;
      case '>':
        currentPosition[0]++;
        break;
    }

    var stringPosition = positionToString(currentPosition);
    if (!mapping.containsKey(stringPosition)) {
      mapping[stringPosition] = 0;
    }
    mapping[stringPosition]++;

    i++;
  });

  print(mapping.length);
}

String positionToString(position) => '${position[0]},${position[1]}';

Map<String, int> mapping = {}; // Location (x,y), count

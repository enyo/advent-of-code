import 'dart:io';

main() async {

  String input = await new File('bin/day_01_input.txt').readAsString();
  var floor = 0;
  var chars = input.split('');

  for (var i = 0; i < chars.length; i++) {
    var char = chars[i];

    if (char == '(') floor++;
    else floor--;

    if (floor == -1) {
      print(i+1);
      break;
    }
  }
}

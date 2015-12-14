import 'dart:io';
import 'dart:math' as math;

Map<String, bool> grid = {};
Map<String, int> grid2 = {};

main() async {
  var input = (await new File('bin/day_06_input.txt').readAsString()).split('\n');

  List<Instruction> instructions = input.map((input) => new Instruction.fromInput(input)).toList();

  // Star 1
  // instructions.forEach((instruction) => instruction.execute());
  //
  // var litLights = 0;
  // grid.forEach((coordinates, state) {
  //   if (state == true) litLights++;
  // });
  // print(litLights);


  // Star 2
  instructions.forEach((instruction) => instruction.execute2());
  var lightLevel = grid2.values.fold(0, (prevValue, level) => prevValue + level);
  print(lightLevel);
}

enum Action { toggle, on, off }

class Instruction {
  Action action;
  Position from;
  Position to;

  Instruction.fromInput(String input) {
    // toggle 720,196 through 897,994
    var _regExp = new RegExp(r'(turn on|turn off|toggle) (\d+)\,(\d+) through (\d+)\,(\d+)');
    var match = _regExp.firstMatch(input);
    switch (match[1]) {
      case 'turn on':
        action = Action.on;
        break;
      case 'turn off':
        action = Action.off;
        break;
      case 'toggle':
        action = Action.toggle;
        break;
    }
    from = new Position(int.parse(match[2]), int.parse(match[3]));
    to = new Position(int.parse(match[4]), int.parse(match[5]));
  }

  execute() {
    for (var x = from.x; x <= to.x; x++) {
      for (var y = from.y; y <= to.y; y++) {
        var coordinates = Position.coordinatesToString(x, y);
        switch (action) {
          case Action.on:
            grid[coordinates] = true;
            break;
          case Action.off:
            grid[coordinates] = false;
            break;
          case Action.toggle:
            grid[coordinates] = grid[coordinates] != null ? !grid[coordinates] : true;
            break;
        }
      }
    }
  }

  // Star 2
  execute2() {
    for (var x = from.x; x <= to.x; x++) {
      for (var y = from.y; y <= to.y; y++) {
        var coordinates = Position.coordinatesToString(x, y);
        if (grid2[coordinates] == null) grid2[coordinates] = 0;

        switch (action) {
          case Action.on:
            // The phrase turn on actually means that you should increase the brightness of those lights by 1.
            grid2[coordinates]++;
            break;
          case Action.off:
            // The phrase turn off actually means that you should decrease the brightness of those lights by 1, to a minimum of zero.
            grid2[coordinates] = math.max(0, grid2[coordinates] - 1);
            break;
          case Action.toggle:
            // The phrase toggle actually means that you should increase the brightness of those lights by 2.
            grid2[coordinates] += 2;
            break;
        }
      }
    }
  }

  toString() => '$action from $from to $to';
}

class Position {
  final int x;
  final int y;
  Position(this.x, this.y);

  toString() => coordinatesToString(x, y);

  static coordinatesToString(x, y) => '$x,$y';
}

import 'dart:io';

var isSecondStar = true;

main(List<String> args) async {
  var inputLines = (await new File('bin/day_07_input.txt').readAsString()).split('\n');

  inputLines.forEach((line) {
    var segments = line.split(' ');
    var parsedSegments = [];
    segments.forEach((segment) {
      if (isOperator(segment)) parsedSegments.add(Operator.byName(segment));
      else if (isNumber(segment)) parsedSegments.add(new Number(int.parse(segment)));
      else if (isCable(segment)) parsedSegments.add(new Cable(segment));
    });

    Cable targetCable = parsedSegments.last;
    if (parsedSegments.first is Number && parsedSegments[1] == Operator.provide) {
      // 1123 -> a
      targetCable.input = new SignalInput(parsedSegments.first);
    } else if (parsedSegments.first == Operator.not) {
      // NOT a -> b
      targetCable.input = new NotInput(parsedSegments[1]);
    } else if (parsedSegments.first is Cable && ([Operator.rshift, Operator.lshift].contains(parsedSegments[1]))) {
      // a RSHIFT 2 -> b
      // a LSHIFT 4 -> b
      targetCable.input = new ShiftInput(parsedSegments[1], parsedSegments.first, (parsedSegments[2] as Number).number);
    } else if (parsedSegments[1] == Operator.or && parsedSegments[0] is Cable && parsedSegments[2] is Cable) {
      // a OR b -> c
      targetCable.input = new OrInput(parsedSegments[0], parsedSegments[2]);
    } else if (parsedSegments[1] == Operator.and && parsedSegments[0] is Cable && parsedSegments[2] is Cable) {
      // a AND b -> c
      targetCable.input = new AndInputCable(parsedSegments[0], parsedSegments[2]);
    } else if (parsedSegments[1] == Operator.and && parsedSegments[0] is Number && parsedSegments[2] is Cable) {
      // 3 AND a -> b
      targetCable.input = new AndInputNumber(parsedSegments[2], (parsedSegments[0] as Number).number);
    } else if (parsedSegments[1] == Operator.and && parsedSegments[2] is Number && parsedSegments[0] is Cable) {
      // a AND 3 -> b
      targetCable.input = new AndInputNumber(parsedSegments[0], (parsedSegments[2] as Number).number);
    } else if (parsedSegments.first is Cable && parsedSegments[1] == Operator.provide) {
      // a -> b
      targetCable.input = new CableInput(parsedSegments.first);
    } else {
      throw new Exception('Unhandled line: $line');
    }
  });

  var aCable = new Cable('a');
  print(aCable.value);
}

isOperator(String segment) => Operator.byName(segment) != null;
isNumber(String segment) => new RegExp(r'\d+').hasMatch(segment);
isCable(String segment) => new RegExp(r'\w+').hasMatch(segment);

class Operator {
  static final Operator not = new Operator._('NOT');
  static final Operator and = new Operator._('AND');
  static final Operator or = new Operator._('OR');
  static final Operator provide = new Operator._('->');
  static final Operator lshift = new Operator._('LSHIFT');
  static final Operator rshift = new Operator._('RSHIFT');

  static final List<Operator> values = [not, and, or, provide, lshift, rshift];

  static byName(String name) => values.firstWhere((op) => op.name == name, orElse: () => null);

  final String name;
  Operator._(this.name);

  toString() => 'Operator $name';
}

/// All cables. Index == name
Map<String, Cable> cables = {};

class Cable {
  String name;

  Input input;

  factory Cable(String name) {
    if (cables.containsKey(name)) return cables[name];
    else {
      var cable = new Cable._(name);
      cables[name] = cable;
      return cable;
    }
  }

  Cable._(this.name);

  int _value;
  int get value => isSecondStar && this.name == 'b' ? 3176 : (_value ?? (_value = input.value));

  toString() => 'Cable $name';
}

abstract class Input {
  int get value;
}

class SignalInput extends Input {
  Number signal;
  SignalInput(this.signal);
  int get value => signal.number;
}

class CableInput extends Input {
  Cable cable;
  CableInput(this.cable);
  int get value => cable.value;
}

class ShiftInput extends Input {
  final Operator operator;
  final Cable cable;
  final int shiftValue;
  ShiftInput(this.operator, this.cable, this.shiftValue);
  int get value => operator == Operator.lshift ? cable.value << shiftValue : cable.value >> shiftValue;
}

class NotInput extends Input {
  final Cable cable;
  NotInput(this.cable);
  int get value => ~cable.value;
}

class OrInput extends Input {
  final Cable cable1;
  final Cable cable2;
  OrInput(this.cable1, this.cable2);
  int get value => cable1.value | cable2.value;
}

class AndInputNumber extends Input {
  final Cable cable;
  final int number;
  AndInputNumber(this.cable, this.number);
  int get value => cable.value & number;
}

class AndInputCable extends Input {
  final Cable cable1;
  final Cable cable2;
  AndInputCable(this.cable1, this.cable2);
  int get value => cable1.value & cable2.value;
}

class Number {
  final int number;
  Number(this.number);
  toString() => 'Signal $number';
}

import 'dart:io';
import 'dart:math' as math;

main() async {
  var input = await new File('bin/day_13_input.txt').readAsString();

  // Parse all strings
  input.split('\n').forEach((input) { new HappinessInfo.fromString(input); });

  print('**Star 1**');
  solve(getPermutations(persons));

  print('**Star 2**');
  var me = new Person.fromName('Matias');
  persons.toList().forEach((person) {
    new HappinessInfo(me, person, 0);
    new HappinessInfo(person, me, 0);
  });
  solve(getPermutations(persons));
}

solve(List<List<Person>> permutations) {
  print('Persons: ${persons.length}');
  print('Possible permutations: ${permutations.length}');

  var bestHappinessValue = getBestHappiness(permutations);

  print("Best Happiness: $bestHappinessValue");
}

int getBestHappiness(List<List<Person>> permutations) {
  return permutations.fold(-1000, (prevHappinessValue, permutation) {
    var happinessValue = 0;

    for (var i = 0; i < permutation.length; i++) {
      Person person = permutation[i],
          prevPerson = permutation[(i - 1) % persons.length],
          nextPerson = permutation[(i + 1) % persons.length];

      happinessValue += [prevPerson, nextPerson].fold(0, (int prevValue, Person otherPerson) {
        var info = HappinessInfo.list.firstWhere((info) => info.who == person && info.nextTo == otherPerson);
        return prevValue + info.happinessUnits;
      });
    }

    return math.max(happinessValue, prevHappinessValue);
  });
}

List<List<Person>> getPermutations(List<Person> persons) {
  var permutations = <List<Person>>[];
  for (var i = 0; i < persons.length; i++) {
    var first = persons[i];
    if (persons.length > 1) {
      var personsWithoutFirst = persons.toList()..removeAt(i);
      getPermutations(personsWithoutFirst).forEach((List<Person> remainingPermutation) {
        permutations.add(<Person>[first]..addAll(remainingPermutation));
      });
    } else {
      permutations.add([first]);
    }
  }
  return permutations;
}

class HappinessInfo {
  Person who;
  Person nextTo;
  int happinessUnits;

  RegExp _inputRegExp = new RegExp(r'^(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)\.');

  static List<HappinessInfo> list = [];

  HappinessInfo.fromString(String input) {
    if (!_inputRegExp.hasMatch(input)) throw new ArgumentError('The input string is invalid: $input');
    var match = _inputRegExp.firstMatch(input);
    who = new Person.fromName(match[1]);
    happinessUnits = int.parse(match[3]);
    if (match[2] == 'lose') happinessUnits = -happinessUnits;
    nextTo = new Person.fromName(match[4]);
    list.add(this);
  }

  HappinessInfo(this.who, this.nextTo, this.happinessUnits) {
    list.add(this);
  }

  toString() => '$who + $nextTo -> $happinessUnits';
}

List<Person> persons = [];

class Person {
  static Map<String, Person> _persons = {}; // Name -> Person

  String name;

  Person._(this.name);

  factory Person.fromName(String name) {
    if (!_persons.containsKey(name)) {
      var person = new Person._(name);
      _persons[name] = person;
      persons.add(person);
    }
    return _persons[name];
  }

  toString() => name;
}

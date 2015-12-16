import 'dart:io';

main() async {
  var input = await new File('bin/day_09_input.txt').readAsString();
  var lines = input.split('\n');

  lines.forEach(parseLine);

  var permutations = getPermutations(cities);
//  permutations.forEach(print);


  print(permutations.fold(0, (prevValue, List<City> route) {
    var distance = getTotalDistance(route);
    return distance > prevValue ? distance : prevValue;
  }));

}


int getTotalDistance(List<City> route) {
  var distance = 0;
  for (var i = 0; i < route.length - 1; i++) {
    var from = route[i], to = route[i+1];
    distance += _getDistance(from, to);
  }
  return distance;
}

int _getDistance(City from, City to) {
  if (to.index < from.index) {
    var x = to;
    to = from;
    from = x;
  }
  var distance = distances[from].singleWhere((distance) => distance.to == to);
  return distance.distance;
}

List<List<City>> getPermutations(List<City> cities) {
  var permutations = <List<City>>[];
  for (var i = 0; i < cities.length; i++) {
    var first = cities[i];
    if (cities.length > 1) {
      var citiesWithoutFirst = cities.toList()..removeAt(i);
      getPermutations(citiesWithoutFirst).forEach((List<City> remainingPermutation) {
        permutations.add(<City>[first]..addAll(remainingPermutation));
      });
    } else {
      permutations.add([first]);
    }
  }
  return permutations;
}


parseLine(String line) {
  // AlphaCentauri to Snowdin = 66
  var regex = new RegExp(r'(\w+) to (\w+) \= (\d+)');
  var match = regex.firstMatch(line);
  var city1 = new City.fromName(match[1]);
  var city2 = new City.fromName(match[2]);
  var distance = int.parse(match[3]);

  City from, to;
  if (city1.index < city2.index) {
    from = city1;
    to = city2;
  }
  else {
    from = city2;
    to = city1;
  }
  if (!distances.containsKey(from)) distances[from] = [];
  distances[from].add(new Distance(to, distance));
}

List<City> cities = [];
var distances = <City, List<Distance>>{};

class Distance {
  City to;
  int distance;
  Distance(this.to, this.distance);

  toString() => '-> $to = $distance';
}

class City {
  final String name;
  int index;

  City._(this.name) {
    this.index = cities.length;
    cities.add(this);
  }

  factory City.fromName(String cityName) {
    return cities.firstWhere((city) => city.name == cityName, orElse: () => new City._(cityName));
  }

  toString() => name;
}

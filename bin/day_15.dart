import 'dart:io';

List<Ingredient> ingredients;
int bestScore = 0;
var tries = 0;
List<Ingredient> bestIncredients;

main() async {
  var input = await new File('bin/day_15_input.txt').readAsString();
  var lines = input.split('\n');
  ingredients = lines.map((input) => new Ingredient.fromInput(input)).toList();
  print(ingredients);

  mix(ingredients);
  print('Best Score: $bestScore');
  print('Total tries: $tries');
}

mix(List<Ingredient> remainingIngredients, [int remainingSpoons = 100]) {
  // Copy the original list
  remainingIngredients = remainingIngredients.toList();
  var thisIngredient = remainingIngredients.first;
  if (remainingIngredients.length == 1) {
    thisIngredient.spoons = remainingSpoons;
    var score = getScore();
    var calories = getCalories();
    tries++;
    if (calories == 500 && score > bestScore) {
      print('Best score $score');
      bestScore = score;
      print(ingredients);
    }
  } else {
    remainingIngredients.removeAt(0);
    for (var i = 1; i < remainingSpoons - remainingIngredients.length; i++) {
      thisIngredient.spoons = i;
      mix(remainingIngredients, remainingSpoons - i);
    }
  }
}

int getScore() {
  if (ingredients.fold(0, (prev, ing) => prev + ing.spoons) > 100) {
    throw new ArgumentError(ingredients);
  }
  var sum = ingredients.first.properties.map((_) => 0).toList();

  ingredients.forEach((ingredient) {
    for (var i = 0; i < ingredient.properties.length; i++) {
      sum[i] += ingredient.properties[i] * ingredient.spoons;
    }
  });

  if (sum.any((sum) => sum <= 0)) return 0;

  return (sum..removeLast()).reduce((property1, property2) => property1 * property2);
}

int getCalories() {
  return ingredients.fold(0, (prevValue, ing) => prevValue + ing.properties.last * ing.spoons);
}

class Ingredient {
  String name;
  List<int> properties = [];

  int spoons = 1;

  /// Candy: capacity 0, durability -1, flavor 0, texture 5, calories 8
  Ingredient.fromInput(String input) {
    var regex = new RegExp(
        r'(\w+)\: capacity ([-]?\d+)\, durability ([-]?\d+)\, flavor ([-]?\d+)\, texture ([-]?\d+)\, calories ([-]?\d+)');
    var match = regex.firstMatch(input);
    name = match[1];
    for (var i = 2; i <= 6; i++) {
      properties.add(int.parse(match[i]));
    }
  }

  toString() => '$name ($spoons): $properties';
}

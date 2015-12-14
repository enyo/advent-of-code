String alphabet = 'abcdefghijklmnopqrstuvwxyz';

List<int> forbiddenLetters = ['i', 'o', 'l'].map(numberForLetter).toList();

main() {
  List<int> letters = 'hepxcrrq'.codeUnits.map((code) => new String.fromCharCode(code)).map(numberForLetter).toList();

  while (!isValid(letters)) {
    increaseLetters(letters);
  }

  // Second Star
  increaseLetters(letters);
  while (!isValid(letters)) {
    increaseLetters(letters);
  }

  print(letters.map(letterForNumber));
}

int numberForLetter(String letter) {
  return alphabet.indexOf(letter);
}

String letterForNumber(int number) {
  return alphabet.substring(number, number + 1);
}

increaseLetters(List<int> letters) {
  for (var i = letters.length - 1; i >= 0; i--) {
    if (letters[i] < 25) {
      letters[i]++;
      break;
    } else {
      letters[i] = 0;
    }
  }
}

bool isValid(List<int> letters) {
  // Check for invalid letters
  for (var letter in letters) {
    if (forbiddenLetters.contains(letter)) return false;
  }

  // Check for increase straight
  var streak, prevLetter = null;
  for (var letter in letters) {
    if (prevLetter == letter - 1) {
      streak++;
      if (streak == 3) break;
    } else {
      streak = 1;
    }
    prevLetter = letter;
  }
  if (streak < 3) return false;

  // Check for two pairs
  var count = 0;
  prevLetter = null;
  for (var letter in letters) {
    if (letter == prevLetter) {
      count++;
      if (count == 2) {
        return true;
      }
      prevLetter = null;
    } else {
      prevLetter = letter;
    }
  }

  return false;
}

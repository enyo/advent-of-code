import 'package:crypto/crypto.dart';

main() async {
  var input = 'ckczppom';

  var currentString = input, count = 1;

  var start = new DateTime.now();
  while(!isValidMd5(currentString)) {
    currentString = '$input${count++}';
    if (count > 10000000) throw new Error();
  }

  print(currentString);
  print(getHash(currentString));
  print('Time: ${new DateTime.now().difference(start).inMilliseconds/1000}s');
}

isValidMd5(String input) {
  var hash = getHash(input);
  return hash.startsWith('000000');
}

String getHash(String input) {
  var md5 = new MD5();
  md5.add(input.codeUnits);
  return CryptoUtils.bytesToHex(md5.close()).toString();
}

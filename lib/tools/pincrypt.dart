//Saves the hash of the pin in FlutterSecureStorage
import 'package:steel_crypt/steel_crypt.dart';

String createPin(String pin) {
  HashCrypt hasher = HashCrypt(algo: HashAlgo.Sha_256);
  return hasher.hash(inp: pin);
}

bool checkPin(String pin, String hashedPin) {
  HashCrypt hasher = HashCrypt(algo: HashAlgo.Sha_256);
  return hasher.check(plain: pin, hashed: hashedPin);
}

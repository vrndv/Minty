// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/export.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:typed_data';

final storage = FlutterSecureStorage();

//CREATE PRIVATE AND PUBLIC KEY PAIR FOR E2E

Future<Map<String, String>> createRSAKeys(String pin) async {
  final SecureRandom = FortunaRandom()
    ..seed(KeyParameter(Uint8List.fromList(List<int>.generate(32, (i) => i))));

  final KeyGen = RSAKeyGenerator()
    ..init(
      ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse("65537"), 2048, 64),
        SecureRandom,
      ),
    );

  final pair = KeyGen.generateKeyPair();
  final PublicKey = pair.publicKey as RSAPublicKey;
  final PrivateKey = pair.privateKey as RSAPrivateKey;

  final PubKeyJson = jsonEncode({
    "modulus": PublicKey.modulus.toString(),
    "exponent": PublicKey.exponent.toString(),
  });

  final PrivKeyJson = jsonEncode({
    "modulus": PrivateKey.modulus.toString(),
    "exponent": PrivateKey.exponent.toString(),
  });
  await storage.write(key: "privateKey", value: PrivKeyJson); //Soring the private key in secure storage


  String encryptedPvtKey = await encryptPrivKey(PrivKeyJson, pin);
  return {
    "pubKey": PubKeyJson,
    "encryptedPrivKey":encryptedPvtKey
  };
}

//ENCRYPT THE PRIVATE KEY TO STORE IN DATABASE

String encryptPrivKey(String PrivKeyJson, String pin) {
  final key = Key.fromUtf8(pin.padRight(32, '0'));
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));

  return encrypter.encrypt(PrivKeyJson, iv: iv).base64;
}

//DECRYPT THE PRIVATE KEY TO STORE IN APP AFTER REINSTALL

String decryptPrivKey(String encryptedPrivKey, String pin) {
  final key = Key.fromUtf8(pin.padRight(32, '0'));
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  print(encrypter.decrypt(Encrypted.fromBase64(encryptedPrivKey), iv: iv));
  return encrypter.decrypt(Encrypted.fromBase64(encryptedPrivKey), iv: iv);
}

//CONVERT JSON BACK TO RSA PRIVATE KEY

RSAPrivateKey parsePrivateKeyFromJson(String PrivKeyJson) {
  Map pk = jsonDecode(PrivKeyJson);
  final modulus = BigInt.parse(pk["modulus"]);
  final exponent = BigInt.parse(pk["exponent"]);
  return RSAPrivateKey(modulus, exponent, null, null);
}

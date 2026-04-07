import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionUtils {

  static final paddingMode = 'PKCS7';
  static final key = encrypt.Key.fromUtf8('1984tiago02pratis05medicesuccess');
  static final iv = encrypt.IV.fromLength(16);

  static String encryptCode(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: paddingMode));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String decryptCode(String encryptedBase64) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc, padding: paddingMode));

    final encrypted = encrypt.Encrypted.fromBase64(encryptedBase64);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}

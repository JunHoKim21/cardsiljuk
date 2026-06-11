import 'dart:convert';
import 'package:crypto/crypto.dart';

class RequestSigner {
  final String _secretKey;

  RequestSigner(this._secretKey);

  /// Generates an HMAC-SHA256 signature for the given payload and timestamp.
  String generateSignature(String payload, String timestamp) {
    // Message to sign: timestamp + '.' + payload
    final String message = '$timestamp.$payload';
    
    // Decode the secret key (assuming UTF-8 for this mockup)
    final List<int> keyBytes = utf8.encode(_secretKey);
    final List<int> messageBytes = utf8.encode(message);

    final Hmac hmac = Hmac(sha256, keyBytes);
    final Digest digest = hmac.convert(messageBytes);

    // Return the base64 encoded signature
    return base64Encode(digest.bytes);
  }

  /// Helper to get current timestamp in seconds
  String getCurrentTimestamp() {
    return (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
  }
}

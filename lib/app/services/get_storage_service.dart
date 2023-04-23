import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class GetStorageService {
  const GetStorageService(this._storage);

  final GetStorage _storage;

  String? get sessionPayload {
    return _storage.read<String?>('sessionPayload');
  }

  int? get currentUserId {
    final String? data = _storage.read<String?>('sessionPayload');
    if (data == null) return null;
    final Map<String, Object?> payload =
        json.decode(data) as Map<String, Object?>;
    return payload['userId'] as int?;
  }

  Future<void> savePayloadSession(String payloadSession) {
    return _storage.write('sessionPayload', payloadSession);
  }
}

import 'package:get_storage/get_storage.dart';

class GetStorageService {
  const GetStorageService(this._storage);

  final GetStorage _storage;

  String? get sessionPayload {
    return _storage.read<String?>('sessionPayload');
  }

  Future<void> savePayloadSession(String payloadSession) {
    return _storage.write('sessionPayload', payloadSession);
  }
}

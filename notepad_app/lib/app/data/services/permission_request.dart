import 'package:permission_handler/permission_handler.dart' as phandler;

class PermissionRequest {
  static PermissionRequest? _instance;

  PermissionRequest._();

  static PermissionRequest getInstance() {
    _instance = _instance ?? PermissionRequest._();
    return _instance!;
  }

  Future<bool> requestStoragePermissions() async {
    phandler.PermissionStatus permission =
        await phandler.Permission.manageExternalStorage.request();
    return permission == phandler.PermissionStatus.granted;
  }
}

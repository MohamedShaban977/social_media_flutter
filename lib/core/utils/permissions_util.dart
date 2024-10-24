import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<PermissionStatus> requestPermission({
    required Permission permission,
  }) async {
    final permissionStatus = await permission.status;
    if (permissionStatus.isDenied) {
      await permission.request();
    }
    return permissionStatus;
  }
}

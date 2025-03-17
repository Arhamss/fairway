import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<void> requestCameraAndGalleryPermission({
    required void Function() grantedCallback,
    void Function()? deniedCallback,
  }) async {
    final isPermissionPermanentlyDenied =
        await isPermanentlyDenied(Permission.photos) ||
            await isPermanentlyDenied(Permission.camera);
    if (isPermissionPermanentlyDenied) {
      deniedCallback?.call();
    } else {
      final photosPermissionGranted = await requestPermission(
        Permission.photos,
      );
      final cameraPermissionGranted = await requestPermission(
        Permission.camera,
      );
      if (photosPermissionGranted && cameraPermissionGranted) {
        grantedCallback();
      }
    }
  }

  static Future<void> requestNotificationsPermission({
    void Function()? deniedCallback,
  }) async {
    final isPermissionPermanentlyDenied =
        await isPermanentlyDenied(Permission.notification);
    if (isPermissionPermanentlyDenied) {
      deniedCallback?.call();
    } else {
      await requestPermission(Permission.notification);
    }
  }

  static Future<void> requestStoragePermission({
    void Function()? deniedCallback,
  }) async {
    final isPermissionPermanentlyDenied =
        await isPermanentlyDenied(Permission.storage);
    if (isPermissionPermanentlyDenied) {
      deniedCallback?.call();
    } else {
      await requestPermission(Permission.storage);
    }
  }

  // Request a specific permission
  static Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  // Check if a specific permission is granted
  static Future<bool> isGranted(Permission permission) async {
    final status = await permission.status;
    return status == PermissionStatus.granted;
  }

  // Check if a specific permission is permanently denied
  static Future<bool> isPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status == PermissionStatus.permanentlyDenied;
  }

  // Request multiple permissions at once
  static Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
    List<Permission> permissions,
  ) async {
    final statusMap = await permissions.request();
    return statusMap;
  }

  // Check multiple permissions
  static Future<bool> arePermissionsGranted(
    List<Permission> permissions,
  ) async {
    for (final permission in permissions) {
      if (!(await isGranted(permission))) {
        return false;
      }
    }
    return true;
  }

  // Open app settings
  static Future<bool> openAppSettingsPage() async {
    final settingsOpened = await openAppSettings();
    return settingsOpened;
  }
}

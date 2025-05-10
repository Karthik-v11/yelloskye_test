import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadFile(BuildContext context, String url, String filename) async {
  var _permissionStatus = await Permission.storage.status;
log(_permissionStatus.toString());
  try {
    requestStoragePermission();
    // Ask permission
    // final status = await Permission.storage.request();
     var status = await Permission.photos.status;
    if (!status.isGranted) {
       status = await Permission.photos.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission is required')),
        );
        return;
      }
    }
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Storage permission denied'),
      ));
      return;
    }

    final dir = await getExternalStorageDirectory(); // or getDownloadsDirectory() if using desktop
    final savePath = '${dir!.path}/$filename';

    await Dio().download(url, savePath);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Downloaded to $savePath'),
    ));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Download failed: $e'),
    ));
  }
}

Future<void> requestStoragePermission() async {
  PermissionStatus status;

  if (Platform.isAndroid) {
    if (await Permission.photos.isDenied ||
        await Permission.videos.isDenied ||
        await Permission.storage.isDenied) {
      // Android 13+ split permissions
      status = await Permission.photos.request();
      if (status.isDenied) {
        status = await Permission.videos.request();
      }
    } else {
      status = await Permission.storage.request(); // Fallback
    }
  } else {
    status = await Permission.storage.request(); // iOS/macOS
  }

  if (status.isGranted) {
    print('Permission granted');
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  } else {
    status = await Permission.photos.request();

    print('Permission denied');
  }
}


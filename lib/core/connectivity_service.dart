import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/constants/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConnectivityService {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool isDialogOpen = false;

  void startListening(BuildContext context) {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        if (isDialogOpen) {
          context.pop();
          isDialogOpen = false;
        }
      } else {
        isDialogOpen = true;
        showDialog<dynamic>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                backgroundColor: AppColors.white,
                title: Text(
                  'No Internet Connection',
                  style: context.h3,
                ),
                content: Text(
                  'Please check your internet connection and try again',
                  style: context.b2,
                ),
              ),
            );
          },
        );
      }
    });
  }

  void stopListening() {
    _subscription.cancel();
  }
}

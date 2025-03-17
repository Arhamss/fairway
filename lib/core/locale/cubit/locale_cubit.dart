import 'package:equatable/equatable.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit({
    AppPreferences? cache,
    this.context,
  })  : _cache = cache ?? Injector.resolve<AppPreferences>(),
        super(const LocaleState()) {
    _initLocale();
  }

  final AppPreferences _cache;
  final BuildContext? context;

  void _initLocale() {
    final savedLocale = _cache.getAppLocale();
    if ((savedLocale ?? '').isNotEmpty) {
      emit(
        state.copyWith(
          locale: Locale(savedLocale ?? 'en'),
        ),
      );
    } else {
      debugPrint('Saved locale was empty');
      emit(
        state.copyWith(
          locale: const Locale('en'),
        ),
      );
    }
  }

  void setLocale(String languageCode) {
    _cache.setAppLocale(languageCode);
    emit(
      state.copyWith(
        locale: Locale(languageCode),
      ),
    );
    if (context != null) {
      Phoenix.rebirth(context!);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

// States
abstract class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState(this.locale);

  @override
  List<Object?> get props => [locale];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial(super.locale);
}

class LanguageChanged extends LanguageState {
  const LanguageChanged(super.locale);
}

// Cubit
class LanguageCubit extends Cubit<LanguageState> {
  static const String supportedLanguagesKey = 'supported_languages';

  LanguageCubit() : super(const LanguageInitial(Locale('en', ''))) {
    _initialize();
  }

  /// Initialize language from SharedPreferences
  Future<void> _initialize() async {
    try {
      final savedLanguage = await SharedPreferencesHelper.getLanguage();
      final locale = Locale(savedLanguage, '');
      emit(LanguageInitial(locale));
    } catch (e) {
      print('Error initializing language: $e');
      emit(const LanguageInitial(Locale('en', '')));
    }
  }

  /// Change language and persist to SharedPreferences
  Future<void> changeLanguage(String languageCode) async {
    try {
      final locale = Locale(languageCode, '');
      await SharedPreferencesHelper.saveLanguage(languageCode);
      emit(LanguageChanged(locale));
    } catch (e) {
      print('Error changing language: $e');
    }
  }

  /// Toggle between English and Arabic
  Future<void> toggleLanguage() async {
    final currentLanguage = state.locale.languageCode;
    final newLanguage = currentLanguage == 'en' ? 'ar' : 'en';
    await changeLanguage(newLanguage);
  }

  /// Get supported locales
  static List<Locale> getSupportedLocales() {
    return const [
      Locale('en', ''),
      Locale('ar', ''),
    ];
  }
}

import 'dart:ui';


import 'package:doori_mobileapp/localization/constant.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  LocalizationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppLanguageConstants.languages[0].languageCode.toString(),
      AppLanguageConstants.languages[0].countryCode);

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  List<LanguageModel> _languages = [];
  Locale get locale => _locale;
  List<LanguageModel> get languages => _languages;

  void loadCurrentLanguage() {
    // only gets called during installation or rebooting
    _locale = Locale(sharedPreferences.getString(AppLanguageConstants.LANGUAGE_CODE) ??
        AppLanguageConstants.languages[0].languageCode.toString(),
        sharedPreferences.getString(AppLanguageConstants.COUNTRY_CODE) ??
            AppLanguageConstants.languages[0].countryCode);

    for (int index = 0; index < AppLanguageConstants.languages.length; index++) {
      if (AppLanguageConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    printf('-----selectedLanguage---$_selectedIndex');
    _languages = [];
    _languages.addAll(AppLanguageConstants.languages);
    update();
  }

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    saveLanguage(_locale);
    update();
  }

  void setSelectedIndex(int index) {
    printf('selectedIndex-$index');
    _selectedIndex = index;
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(
        AppLanguageConstants.LANGUAGE_CODE, locale.languageCode);
    sharedPreferences.setString(AppLanguageConstants.COUNTRY_CODE, locale.countryCode!);
  }

}
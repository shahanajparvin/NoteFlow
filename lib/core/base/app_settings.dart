
import 'package:noteflow/core/constant/pref_keys.dart';
import 'package:noteflow/core/utils/sharedpreferences_helper.dart';

import '../../domain/entities/other/language.dart';

class AppSettings {
  final SharedPreferencesHelper _prefHelper;

  const AppSettings(SharedPreferencesHelper preferencesHelper)
      : _prefHelper = preferencesHelper;


  Language getSelectedLanguage() {
    String code = _prefHelper.getString(AppKey.keyCurrentLanguage,
        defaultValue: Language.english.languageCode);
    return Language.getLanguageByCode(code);
  }

  Future<void> setSelectedLanguage(Language language) async {
    await _prefHelper.setString(AppKey.keyCurrentLanguage, language.languageCode);
  }


  Future<void> logoutUser() async {
    Language language = getSelectedLanguage();
    _prefHelper.clear();
    await setSelectedLanguage(language);
  }

}

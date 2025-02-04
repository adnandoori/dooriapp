class AppLanguageConstants {
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';

  /*static List<LanguageModel> languages = [
    LanguageModel(imageUrl: "🇺🇸", languageName: 'English',
      countryCode: 'US', languageCode: 'en', isSelected: null,),
    LanguageModel(imageUrl: "🇵🇰", languageName: 'Urdu',
      countryCode: 'PK', languageCode: 'ur',),
  ];*/

  static List<LanguageModel> languages = [
    LanguageModel(
        title: 'English', subTitle: '', languageCode: 'en', countryCode: '+1'),
    LanguageModel(
        title: 'हिंदी',
        subTitle: 'Hindi',
        languageCode: 'hi',
        countryCode: '+91'),
    LanguageModel(
        title: 'ગુજરાતી',
        subTitle: 'Gujarati',
        languageCode: 'gu',
        countryCode: '+91'),
    LanguageModel(
        title: 'मराठी',
        subTitle: 'Marathi',
        languageCode: 'mh',
        countryCode: '+91'),
    LanguageModel(
        title: 'বাংলা',
        subTitle: 'Bangla',
        countryCode: 'IN',
        languageCode: 'bn'),
    LanguageModel(
        title: 'ଓଡିଆ', subTitle: 'Odia', countryCode: 'IN', languageCode: 'or'),
    LanguageModel(
        title: 'മലയാളം',
        subTitle: 'Malayalam',
        countryCode: 'IN',
        languageCode: 'ml'),
    LanguageModel(
        title: 'ಕನ್ನಡ',
        subTitle: 'Kannada',
        countryCode: 'IN',
        languageCode: 'kn'),
    LanguageModel(
        title: 'தமிழ்',
        subTitle: 'Tamil',
        countryCode: 'IN',
        languageCode: 'ta'),
    LanguageModel(
        title: 'తెలుగు',
        subTitle: 'Telugu',
        countryCode: 'IN',
        languageCode: 'te'),
    LanguageModel(
        title: 'ਪੰਜਾਬੀ',
        subTitle: 'Punjabi',
        countryCode: 'IN',
        languageCode: 'pa'),
    LanguageModel(
        title: 'Polski',
        subTitle: 'Polish',
        countryCode: '+48',
        languageCode: 'pl'),
    LanguageModel(
        title: 'slovenský',
        subTitle: 'Slovak',
        countryCode: '+421',
        languageCode: 'sk'),
    LanguageModel(
        title: 'čeština',
        subTitle: 'Czech',
        countryCode: '+420',
        languageCode: 'cs'),
    LanguageModel(
        title: 'Deutsch',
        subTitle: 'German',
        countryCode: '+49',
        languageCode: 'de'),
    LanguageModel(
        title: 'Magyar',
        subTitle: 'Hungarian',
        countryCode: '+36',
        languageCode: 'hu'),
    LanguageModel(
        title: 'Српски',
        subTitle: 'Serbian',
        countryCode: '+381',
        languageCode: 'sr')
  ];
}

class LanguageModel {
  String? title;
  String? subTitle;
  String? languageCode;
  String? countryCode;

  LanguageModel({
    this.title,
    this.subTitle,
    this.languageCode,
    this.countryCode,
  });
}

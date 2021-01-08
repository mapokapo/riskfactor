class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language({this.id, this.name, this.flag, this.languageCode});

  static List<Language> languageList() {
    return [Languages.english, Languages.bosnian];
  }
}

class Languages {
  static Language english =
      Language(id: 1, flag: '🇬🇧', languageCode: 'en', name: 'English');
  static Language bosnian =
      Language(id: 2, flag: '🇧🇦', languageCode: 'bs', name: 'Bosanski');
}

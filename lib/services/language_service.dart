enum LanguageTypeEnum {
  english,
  czech,
}

const String ENGLISH = "en";
const String CZECH = "cz";

extension LanguageTypeExtension on LanguageTypeEnum {
  String getValue() {
    switch (this) {
      case LanguageTypeEnum.english:
        return ENGLISH;
      case LanguageTypeEnum.czech:
        return CZECH;
    }
  }
}

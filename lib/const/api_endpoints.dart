class ApiEndpoints {
  static const String API_VERSION = "v1";
  static const String TEST_BASE_URL = "http://127.0.0.1:8000/api/$API_VERSION/";
  static const String TEST_ANDROID_BASE_URL = "http://10.0.2.2:8000/api/$API_VERSION/";
  static const String BASE_URL = "https://wineapp.mrhappy.cz/api/$API_VERSION/";

  static const String loginUrl = "login";
  static const String registerUrl = "register";
  static const String logoutUrl = "logout";
  
  static const String userUrl = "user";
  static const String projectUrl = "project";
  static const String projectSettingsUrl = "projectSettings";
  static const String userProjectUrl = "userProject";
  static const String listUrl = "list";

  static const String vineyardUrl = "vineyard";
  static const String vineyardWineUrl = "vineyardWine";
  static const String vineyardRecordUrl = "vineyardRecord";
  static const String vineyardRecordTypeUrl = "vineyardRecordType";
  static const String wineUrl = "wine";
  static const String wineVarietyUrl = "wineVariety";
  static const String wineClassificationUrl = "wineClassification";
  static const String wineEvidenceUrl = "wineEvidence";
  static const String volumeUrl = "volume";
  static const String wineRecordUrl = "wineRecord";
  static const String wineRecordTypeUrl = "wineRecordType";
}

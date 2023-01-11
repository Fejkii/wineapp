class ApiEndpoints {
  static const String TEST_BASE_URL = "http://127.0.0.1:8000/api/v1/";
  static const String TEST_ANDROID_BASE_URL = "http://10.0.2.2:8000/api/v1/";
  static const String BASE_URL = "https://wineapp.mrhappy.cz/api/v1/";

  static const String loginUrl = "login";
  static const String registerUrl = "register";
  static const String logoutUrl = "logout";
  static const String userUrl = "user/";
  static const String forgotPasswordUrl = "${userUrl}forgotPassword";
  static const String projectUrl = "project";
  static const String userProjectUrl = "userProject";
  static const String userProjectListUrl = "userProjects";
  static const String projectUserListUrl = "projectUsers";

  static const String vineyardUrl = "vineyard";
  static const String vineyardListUrl = "vineyardList";
  static const String vineyardWineUrl = "vineyardWine";
  static const String vineyardRecordUrl = "vineyardRecord";
  static const String wineUrl = "wine";
  static const String wineListUrl = "wineByProject";
  static const String wineVarietyUrl = "wineVariety";
  static const String wineVarietyListUrl = "wineVarietyByProject";
  static const String wineClassificationUrl = "wineClassification";
  static const String wineEvidenceUrl = "wineEvidence";
  static const String wineEvidenceListUrl = "wineEvidenceByProject";
  static const String wineRecordTypeUrl = "wineRecordType";
  static const String wineRecordUrl = "wineRecord";
}

class AppConstants {
  AppConstants._();

  // stores url
  static String playStore(String applicationId) => 'market://details?id=$applicationId';
  static const String appStore = 'https://apps.apple.com/app/id$bundleIdentifier';
  static const bundleIdentifier = '1471773622';

  //google API Key
  static const googleAPIKey = "AIzaSyBcZcPRzzV_EwrL__oJ9MpmtUDKX8NkOBo";

  //languages code
  static const String langCode = 'languageCode';
  static const String enLangCode = 'en';
  static const String arLangCode = 'ar';
  static const String enCountryCode = 'US';
  static const String arCountryCode = 'SA';

  //shared preferences keys
  static const String prefKeyIsDarkMode = 'prefKeyIsDarkMode';
  static const String prefKeyUser = 'prefKeyUser';
  static const String prefKeyAccessToken = 'prefKeyAccessToken';
  static const String prefKeyCheckUpdateVersion = 'prefKeyCheckUpdateVersion';
  static const String prefKeyCanCheckUpdate = 'prefKeyCanCheckUpdate';
  static const String prefLatLongEvent = 'prefLatLongEvent';

  /// argument route keys
  static const String routeVerificationKey = 'routeVerificationKey';
  static const String routeSetNewPasswordKey = 'routeSetNewPasswordKey';
  static const String routeSelectHobbiesKey = 'routeSelectHobbiesKey';
  static const String routeEventIdKey = 'event_id';
  static const String routeEventTypeKey = 'event_type';
  static const String routeEventIndexKey = 'index';
  static const String routeJoinersKey = 'routeJoinersKey';

  //patterns date time
  static const patternYMMMD = 'yMMMd';
  static const patternHMMA = 'h:mm a';
  static const patternEEEDDMMMYYYY = 'EEE, dd MMM yyyy';
  static const patternDDMMMYYYY = 'dd MMM yyyy';
  static const patternMMMDDYYYYHHMMA = 'MMMM dd, yyyy, hh:mm a';
  static const patternMMMDDYYYY = 'MMM dd, yyyy';
  static const patternMMMMDDYYYY = 'MMMM dd, yyyy,';
  static const patternHHMMA = 'hh:mm a';


  //Videos
  static youtubeVideoThumbnailLink(String id) => 'https://img.youtube.com/vi/$id/mqdefault.jpg';
  static String get googleDrive => 'drive.google.com';
  static googleDriveVideoThumbnailLink(String id) => 'https://drive.google.com/thumbnail?id=$id';
  static googleDriveLink(String id) => 'https://drive.google.com/uc?export=download&id=$id';
  static dailymotionLink(String id) => 'https://www.dailymotion.com/thumbnail/video/$id';
  static dailyMotionHTMLString(String videoId) =>
      '<html><body>' +
      '<iframe id="player" frameborder="0" allowfullscreen="true" allow="autoplay" title="Dailymotion video player" width="100%" height="100%" src="https://www.dailymotion.com/embed/video/$videoId?api=postMessage&amp;id=player&amp;mute=false&amp;origin=https%3A%2F%2Fqualif.securite-routiere.gouv.fr&amp;queue-enable=false"></iframe>' +
      '</body></html>';

  //Others
  static const splashDelay = 3;
  static const toastDurationForIosWeb = 2;
  static const resendCodeDelay = 120;
  static const registerSteps = 3;
  static const searchDelayTime = 1;
  static const postTitleMaxLength = 60;
  static const postDescriptionMaxLength = 500;
  static const postMediaMax = 10;
  static const beginnerLevelId = 1;
  static const intermediateLevelId = 2;
  static const advancedLevelId = 3;
  static const animationDurationMilliseconds = 300;
  static const kCount = 1000;
  static const video = "video";
  static const image = "image";
  static const minimumRecordingDurationInSeconds = 3;
  static const maximumRecordingDurationInSeconds = 180;
  static const maxAssetsPost = 10;
  static const maxAssetsEvent = 5;
  static const scaleThousand = 1000;
  static const scaleMillion = 1000000;

  /*instance name*/
  static const instanceNameDioS3 = "DioS3";

}

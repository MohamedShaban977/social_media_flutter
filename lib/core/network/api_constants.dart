class ApiConstants {
  ApiConstants._();

  /*Base url*/
  static const String baseUrlStaging = 'https://apistaging.hauui.com/api/v2/';
  static const String baseUrlProduction = 'http://15.188.16.25/api/v1'; //same baseUrlStaging

  /*Request first page*/
  static const firstPage = 1;

  /*Request page size*/
  static const defaultPageSize = 10;
  static const pageSize500 = 500;

  /*Terms of use*/
  static const termsOfUseUrl = 'https://apistaging.hauui.com/api/v2/terms_of_use';

  /*Privacy policy*/
  static const privacyPolicyUrl = 'https://apistaging.hauui.com/api/v2/policies';

  /*Common query parameters*/
  static const perPage = 'per_page';
  static const page = 'page';

  /*APIs*/
  /*Login*/
  static const String apiLogin = 'sessions';

  /*Verify forget password OTP*/
  static String apiVerifyForgetPasswordOTP(String resetPasswordCode) => 'passwords/$resetPasswordCode';

  /*Forget password*/
  static const String apiForgetPassword = 'passwords';

  /*Check if user exists*/
  static const String apiCheckUserExists = 'check_user_exists';

  /*Register*/
  static const String apiRegister = 'users';

  /*resend OTP*/
  static String apiResendOTP(int userId) => 'users/$userId';

  /*Verify otp*/
  static String apiVerifyOtp(int userId) => 'users/$userId';

  /*Get levels*/
  static const String apiLevels = 'levels';

  /*Get hobbies*/
  static const String apiHobbies = 'hobbies';

  /*Get user hobbies*/
  static String apiUserHobbies(String userId) => 'users/$userId/hobbies';

  /*Get suggested hobbies*/
  static const String apiSuggestHobbiesList = 'list_hobbies';

  /*Suggest hobbies*/
  static const String apiSuggestedHobbies = 'suggested_hobbies';

  /*Update profile city */
  static String apiUpdateProfileCity(int? userId) => 'users/$userId';

  /*Lookups*/
  // countries
  static const String apiCountries = 'countries';

  // cities
  static String apiCitiesByCountry(int countryId) => 'countries/$countryId/cities';

  // timezones
  static const String apiTimezones = 'lookups/timezones';

  /*Posts*/
  static const String apiPosts = 'posts';

  /*Popular posts*/
  static const String apiPopularPosts = 'top_posts';

  /*Users*/
  static const String apiUsers = 'users';

  /*User follow or unfollow */
  static String apiFollowings(int? userId, {int? unfollowedId}) =>
      'users/$userId/followings${unfollowedId != null ? '/$unfollowedId' : ''}';

  /*check force update*/
  static const String apiCheckForceUpdate = 'app_versions/check_force_update';

  /*Event for me*/
  static const String apiEventForMe = 'events_for_me';

  /*my Events*/
  static const String apiMyEvent = 'my_events';

  /*Discover Event*/
  static const String apiDiscoverEvent = 'events';

  /*Event Details*/
  static String apiEventDetails(int eventId) => 'events/$eventId';

  /*Join Or Leave Even*/
  static String apiJoinOrLeaveEvent(String eventId, [String? userId]) =>
      'events/$eventId/attendees${userId != null ? '/$userId' : ''}';

  /*save unsave event*/
  static const String apiSaveUnsaveEvent = 'bookmarks/events';

  /*Delete Event*/
  static String apiDeleteEvent(int eventId) => 'events/$eventId';

  /*hidden Event*/
  static const String apihiddenEvents = 'hidden_events';

  /*Report Reasons Event*/
  static const String apiReportReasonsEvent = 'events_report_reasons';

  /*reported events action*/
  static const String apiReportedEvents = 'reported_events';

  /*Vimeo*/
  static String apiVimeoThumbnail(String videoId) => 'http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/$videoId';

  /*Like and unLike post*/
  static String apiLikePost(String postId) => 'posts/$postId/likes';

  /*Save and un save post*/
  static String apiSavePost(String userId) => 'users/$userId/bookmarks';

  /*Block user*/
  static String get apiBlockUser => 'blocked_users';

  /*Delete post*/
  static String apiDeletePost(int postId) => 'posts/$postId';

  /*Report post*/
  static String get apiReportPost => '/reported_posts';

  /*Report reasons*/
  static String get apiReportReasons => '/report_reasons';
  /*Get suggested hashtags*/
  static const String apiGetSuggestedHashtags = 'hashtags/suggested_hashtags';

  /*Get profile*/
  static String apiGetProfile(int userId) => 'users/$userId';

  /*Get ranks*/
  static const apiGetRanks = 'lookups/list_ranks';

  /*Joiners Event*/
  static String apiJoinersEvent(int eventId) => 'events/$eventId/attendees';

  /*Event You May Like*/
  static String apiEventYouMayLike(int eventId) => 'events/$eventId/similar_events';

  /*Generate presigned url*/
  static const apiGeneratePresignedUrl = 'uploads';

  /*Create Event*/
  static const apiCreateEvent = 'events';

  /*Edit Event*/
  static String apiEditEvent(int eventId) => 'events/$eventId';
}

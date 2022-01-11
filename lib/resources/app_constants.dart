class AppConstants {
  static const double APP_VERSION = 1.0;

  static const String URL_POLICY =
      'https://www.termsandcondiitionssample.com/live.php?token=wCByiKpLOyYRlpi9bwdyH0p0SV93PX3r';
  static const String URL_TERMS_AND_CONDITION =
      'https://www.termsandcondiitionssample.com/live.php?token=wCByiKpLOyYRlpi9bwdyH0p0SV93PX3r';

  ///appStore link
  static const String APP_STORE_LINK = 'https://google.com.np';
  static const String SERVICE_PROVIDER_APP_STORE_LINK = 'https://google.com.np';
}

class AppEndPoints {
  ///base url
  static const String BASE_URL = 'https://pos.globalmobile.com.np';

  ///Key
  static const String CLIENT_ID = '2';
  static const String CLIENT_SECRET =
      '0b4A1sus2hz9E3AatyxPZJLd1t7AKre4zZTXCAgl';

  ///[end_point] list

  ///user login/logOut
  static const String USER_LOGIN = '/api/user/oauth/token';
  static const String USER_LOGOUT = '/api/user/logout';

  ///user signin
  static const String USER_SIGN_UP = '/api/user/signup';

  /// check api if online or not
  static const String CHECK_API = '/api/user/checkapi';

  static const String CHECK_EMAIL = '/api/user/checkemail';

  /// check api if online or not
  static const String CHANGE_PASSWORD = '/api/user/change/password';
  static const String FORGOT_PASSWORD = '/api/user/forgot/password';
  static const String RESET_PASSWORD = '/api/user/reset/password';

  ///get user details
  static const String GET_USER_DETAIL_S = '/api/user/details';
  static const String UPDATE_USER_DETAIL = '/api/user/update/profile';

  ///get Service Categories
  static const String GET_SERVICE_CATEGORIES = '/api/user/services';

  ///location service
  static const String UPDATE_USER_LOCATION_UPDATE_USER_LOCATION =
      '/api/user/update/location';
  static const String USER_LOCATION = '/api/user/location';

  ///service
  static const String GET_SERVICE_PROVIDER = '/api/user/show/providers';

  ///upcoming trip detail
  static const String UPCOMING_TRIPS = '/api/user/upcoming/trips';

  static const String USER_TRIPS = '/api/user/trips';

  static const String GET_UPCOMING_TRIP_DETAIL =
      '/api/user/upcoming/trip/details';

  ///dispute
  static const String GET_DISPUTE_LIST_USER =
      '/api/user/dispute-list?dispute_type=user';

  ///notification
  static const String GET_NOTIFICAION_LIST = '/api/user/notifications/all';

  ///banner
  static const String GET_BANNER_IMAGE = '/api/user/banner';

  ///wwallet
  static const String USER_WALLET = '/api/user/wallet/passbook';

  ///promoCode
  static const String GET_PROMO_CODE = '/api/user/promocodes_list';

  ///help
  static const String GET_HELP = '/api/user/help';

  static const String CANCEL_ORDER = '/api/user/cancel/request';

  ///send message
  static const String SEND_MESSAGE = '/api/user/chat';

  ///validate Otp
  static const String VALIDATE_OTP = '/api/user/check-otp';

  ///order service
  static const String ORDER = '/api/user/send/request';
  static const String InsTNT_ORDER = '/api/user/send/request';
  static const String CHECK_ORDER = '/api/user/request/check';
  static const String SUBMIT_REVIEW_1 = '/api/user/rate/provider';

  ///CALCULATE_FARE
  static const String CALCULATE_FARE = '/api/user/estimated/fare';
}

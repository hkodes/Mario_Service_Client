enum LoginType { manual, social }
enum DeviceType { android, ios }
enum LocationType { automatic, manual, remote }
enum GenderType { MALE, FEMALE, OTHER }
enum UserAddressType { home, recent, work, others }

enum ApiStatus { showCarousel, showLogin, showError, showDashBoard ,showOrderMap}

class EnumUtil {
  static T fromStringToEnum<T>(Iterable<T> values, String stringType) {
    return values.firstWhere(
        (f) =>
            "${f.toString().substring(f.toString().indexOf('.') + 1)}"
                .toString() ==
            stringType,
        orElse: () => null);
  }

  static bool checkIfStringEnumEqual<T>(T enumValue, String data) {
    if ((enumValue
            .toString()
            .toLowerCase()
            .substring(enumValue.toString().indexOf('.') + 1) ==
        data.toLowerCase())) {
      return true;
    }
    return false;
  }

  static String getStringFromEnum<T, X>(Iterable<T> enumItem, X enumValue) {
    T value = enumItem
        .firstWhere((element) => element.toString() == enumValue.toString());
    if (value == null) {
      throw (Exception("Enum value not found in enumm"));
    } else
      return value.toString().substring(value.toString().indexOf('.') + 1);
  }
//UserAddressType.values[updateUserAddressRequestEntity.userAddressType.index]
}

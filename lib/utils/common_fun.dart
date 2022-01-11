import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mario_service/utils/snack_util.dart';

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      .buffer
      .asUint8List();
}

String getFullName(String firstName, String lastName) {
  return firstName + " " + lastName;
}

String getPhone(String code, String phone) {
  return code + "-$phone";
}

String parseDisplayDate(DateTime dateTime) {
  final f = new DateFormat.yMMMMd('en_US');
  return f.format(dateTime);
}

String parseDisplayDateYear(DateTime dateTime) {
  final f = new DateFormat.yMMM('en_US');
  return f.format(dateTime);
}

String parseDate(DateTime dateTime) {
  final f = new DateFormat('yyyy-MM-dd');
  return f.format(dateTime);
}

String parseTime2(DateTime dateTime) {
  final f = new DateFormat('hh:mm:ss');
  return f.format(dateTime);
}

String getDayFromDateTime(DateTime dateTime) {
  if (dateTime.weekday == 1) {
    return "Mon";
  } else if (dateTime.weekday == 2) {
    return "Tue";
  } else if (dateTime.weekday == 3) {
    return "Wed";
  } else if (dateTime.weekday == 4) {
    return "Thu";
  } else if (dateTime.weekday == 5) {
    return "Fri";
  } else if (dateTime.weekday == 6) {
    return "Sat";
  } else if (dateTime.weekday == 7) {
    return "Sun";
  }
  return '';
}

String parseHours(DateTime dateTime) {
  final f = new DateFormat('hh:mm');
  return f.format(dateTime);
}

String parseHoursAMPM(DateTime dateTime) {
  final f = new DateFormat('hh:mm aa');
  return f.format(dateTime);
}

int getEpochFromDate(DateTime dateEpoch) {
  return dateEpoch.toUtc().millisecondsSinceEpoch;
}

String parseTime(DateTime dateTime) {
  return DateFormat.jm().format(dateTime);
}

// String timeAgo(DateTime dateTime) {
//   Duration dT = DateTime.now().difference(dateTime);
//   DateTime diff = new DateTime.now().subtract(dT);
//   return timeago.format(diff);
// }

String parseDuration(DateTime dateTime) {
  double hour = double.parse(dateTime.hour.toString());
  double min = double.parse(dateTime.minute.toString());
  double time = hour + min / 60;
  return time.toStringAsFixed(2).toString();
}

String parseDurationHour(int toDate, int fromDate) {
  DateTime toDateDateTime = getDateFromEpoch(toDate);
  DateTime fromDateDateTime = getDateFromEpoch(fromDate);
  Duration duration = toDateDateTime.difference(fromDateDateTime);

  return duration.inDays.toString();
}

DateTime getDateFromEpoch(int date) {
  return DateTime.fromMillisecondsSinceEpoch(date).toUtc();
}

// toUtcvoid popAfterBuild(BuildContext context, String message) {
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     Navigator.pop(context);
//     ToastUtils.showToast(message, ToastType.ERROR);
//   });
// }

Random _rnd = Random();

String randomStringGen(int size) {
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  return String.fromCharCodes(Iterable.generate(
      size, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

copyToClipBoard(String string, BuildContext context) {
  Clipboard.setData(new ClipboardData(text: string));
  showSnackSuccess(context, "$string copied");
}

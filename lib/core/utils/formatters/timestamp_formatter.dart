import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimestampFormatter {
  static String getDateFromTimestamp(
    Timestamp timestamp, {
    String dateFormatPattern = 'MMM d',
  }) {
    var format = DateFormat(dateFormatPattern);
    var date = DateTime.fromMillisecondsSinceEpoch(
      timestamp.millisecondsSinceEpoch,
    );
    return format.format(date);
  }

  static String getTimeFromTimestamp(
    Timestamp timestamp, {
    String dateFormatPattern = 'h:mma',
  }) {
    var format = DateFormat(dateFormatPattern);
    var date = DateTime.fromMillisecondsSinceEpoch(
      timestamp.millisecondsSinceEpoch,
    );
    return format.format(date).toLowerCase();
  }

  String getChatTileTime(Timestamp timestamp) {
    int difference = DateTime.now().millisecondsSinceEpoch -
        timestamp.millisecondsSinceEpoch;
    String result = '';

    if (difference < 60000) {
      result = 'now';
    } else if (difference < 3600000) {
      result = countMinutes(difference);
    } else if (difference < 86400000) {
      result = countHours(difference);
    } else if (difference / 1000 < 31536000) {
      result = countDays(difference);
    } else {
      result = countYears(difference);
    }

    return result;
  }

  String countMinutes(int difference) {
    int count = (difference / 60000).truncate();
    return count.toString() + 'm';
  }

  String countHours(int difference) {
    int count = (difference / 3600000).truncate();
    return count.toString() + 'h';
  }

  String countDays(int difference) {
    int count = (difference / 86400000).truncate();
    return count.toString() + 'd';
  }

  String countYears(int difference) {
    int count = (difference / 31536000000).truncate();
    return count.toString() + 'y';
  }
}

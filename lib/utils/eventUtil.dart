import 'package:flutter/material.dart';
import 'package:flutterApp/theme.dart';

class EventUtil {
  static String getMonth(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jan";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "";
    }
  }

  static String getStatus(int acceptType) {
    switch (acceptType) {
      case 1:
        return "Accept Invitation";
      case 2:
        return "Invitation Accepted";
      case 3:
        return "Pay";
      case 4:
        return "Payment finished";
      case -1:
        return "Scan Bill";
      case -2:
        return "Send Invitation";
      case -3:
        return "Split Bill";
      case -4:
        return "Check Payment";
      default:
        return "";
    }
  }

  static Color getColor(int acceptType) {
    switch (acceptType) {
      case 1:
      case 3:
      case -1:
      case -2:
      case -3:
        return Colors.red.withOpacity(0.6);
      case 2:
      case 4:
      case -4:
        return MyColors.primaryColorLight;
      default:
        return Colors.black;
    }
  }

  static IconData getIcon(int acceptType) {
    switch (acceptType) {
      case -1:
      case -3:
        return Icons.sync;
      case 1:
        return Icons.warning;
      case 2:
        return Icons.check;
      case 3:
        return Icons.warning;
      case 4:
      case -4:
        return Icons.assignment_turned_in;
      default:
        return Icons.delete_forever;
    }
  }
}

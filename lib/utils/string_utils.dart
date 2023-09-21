import 'dart:developer';

import 'package:flutter/foundation.dart';

class StringUtils {
  static String no = "No";
  static String yes = "Yes";
}

logs(String msg) {
  if (kDebugMode) {
    log(msg);
  }
}

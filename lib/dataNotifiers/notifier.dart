
import 'package:flutter/material.dart';

ValueNotifier<int> currentPageNotifier = ValueNotifier(0);
ValueNotifier<String> currentUser = ValueNotifier("guest");
ValueNotifier<String> currentEmail = ValueNotifier("guest@gmail.com");
ValueNotifier<bool> currentTheme = ValueNotifier(false); //true = light
ValueNotifier<String> userID = ValueNotifier("Null");
ValueNotifier<bool> isSearch=ValueNotifier(false);
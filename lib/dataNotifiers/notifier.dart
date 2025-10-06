
import 'package:flutter/material.dart';

ValueNotifier<int> currentPageNotifier = ValueNotifier(0);
ValueNotifier<String> currentUser = ValueNotifier("guest");
ValueNotifier<String> currentEmail = ValueNotifier("guest@gmail.com");
ValueNotifier<String>  currentPFP= ValueNotifier("1");
ValueNotifier<String> userID = ValueNotifier("Null");
ValueNotifier<bool> currentTheme = ValueNotifier(false); //true = light
ValueNotifier<bool> isSearch=ValueNotifier(false);
ValueNotifier<bool> isProfanity=ValueNotifier(true);
ValueNotifier<int> newVer = ValueNotifier(1);
ValueNotifier<int> currVer = ValueNotifier(22);
ValueNotifier<String> Strversion = ValueNotifier("null");
ValueNotifier<bool> isLogged=ValueNotifier(false);
ValueNotifier<int> chatLen = ValueNotifier(0);

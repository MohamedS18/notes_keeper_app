import 'package:flutter/material.dart';

class States extends ChangeNotifier {
  String username = "";
  bool isDarkMode = false;
  static bool isLogged = false;



  void setIsDarkMode(){
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  static void setIsLogged(bool val){
    isLogged = val;
  }

  void setUsername(String newName) {
    username = newName;
    notifyListeners(); // 🔥 Updates UI automatically
  }
}

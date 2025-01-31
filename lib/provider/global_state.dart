import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Define el ChangeNotifier
class GlobalState extends ChangeNotifier {
  String title = 'Predictor pérdida de Cabello';
  ImageProvider image = const AssetImage(
      'assets/hair.png'); // Asegúrate de tener esta imagen en tus assets
  Color backgroundColor = Colors.blue;

  void changeTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void changeImage(ImageProvider newImage) {
    image = newImage;
    notifyListeners();
  }

  void changeBackgroundColor(Color newBackgroundColor) {
    backgroundColor = newBackgroundColor;
    notifyListeners();
  }
}

// 2. Crea el Provider usando ChangeNotifierProvider.autoDispose (o simplemente ChangeNotifierProvider)
final globalStateProvider = ChangeNotifierProvider((ref) => GlobalState());

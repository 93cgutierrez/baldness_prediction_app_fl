import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DialogUtil {
  //simple dialog
  static simpleDialog({
    required BuildContext context,
    required String title,
    required String content,
    Color backgroundColor = Colors.grey,
    String? image,
    String animation = 'assets/error.json',
    required String primaryButtonText,
  }) {
    if (context.mounted) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: backgroundColor,
          title: Row(
            children: [
              image == null
                  ? Lottie.asset(
                      repeat: false,
                      backgroundLoading: true,
                      animation,
                      width: 100,
                      height: 100,
                    )
                  : Image.asset(
                      image,
                      width: 100,
                      height: 100,
                    ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            textAlign: TextAlign.center,
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Color del texto
                //backgroundColor: Colors.blue, // Color de fondo del botón
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0), // Padding del botón
                textStyle: const TextStyle(fontSize: 16), // Estilo del texto
                shape: RoundedRectangleBorder(
                  // Forma del botón
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(primaryButtonText),
            ),
          ],
        ),
      );
    }
  }
}

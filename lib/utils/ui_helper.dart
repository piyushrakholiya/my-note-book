import 'package:flutter/material.dart';

class UiHelper {
  static Future<void> customAlertBox({
    required BuildContext context,
    required String text,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  static TextField customTextField({
    required TextEditingController controller,
    required String text,
    required IconData? iconData,
    required bool isHide,
  }) {
    return TextField(
      controller: controller,
      obscureText: isHide,

      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(21),
          borderSide: BorderSide(color: Colors.blue),
        ),
        label: Text(text),
        suffixIcon: Icon(iconData),
      ),
    );
  }

  static ElevatedButton customButton({
    required String text,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(200, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
      ),
      child: Text(text),
    );
  }
}

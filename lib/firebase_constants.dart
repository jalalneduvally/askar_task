import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class constants {
  static const product ="product";
}
void showMessage(BuildContext context,{required String text,required Color color}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: color,
          content: Text(text))
  );
}
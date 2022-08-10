import 'package:flutter/material.dart';

void showMessage(String msg, Color color,bcontext) {
    ScaffoldMessenger.of(bcontext).showSnackBar(SnackBar(
      content: Container(
          height: 30.0,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(20.0))),
          child: Center(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          )),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    ));
  }
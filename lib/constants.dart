import 'package:flutter/material.dart';

const String apiUrl = "https://dummyapi.io/data/v1";
const String hiveBoxId = "idKey";
const String boxUserId = "idKey";

final kInputTextDecoration = InputDecoration(
  hintStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      width: 2,
      color: Color(0xffb2b1b1),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      width: 2,
      color: Color(0xff6f6f6f),
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      width: 2,
      color: Colors.red.shade400,
    ),
  ),
  suffixIconColor: Color(0xff6f6f6f),
);

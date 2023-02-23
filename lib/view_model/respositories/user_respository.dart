import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:socify/model/data/user.dart';
import 'package:socify/model/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:socify/view/widgets/show_snackbar.dart';

class UserRepositories {
  late final MediaService _mediaService;
  late BuildContext _context;
  late final UserData parentUserData;
  UserRepositories(BuildContext context) {
    _mediaService = MediaService();
    _context = context;
    parentUserData = Provider.of<UserData>(
      _context,
      listen: false,
    );
  }

  Future<UserDataList?> getUserList({required String page}) async {
    try {
      UserDataList data = UserDataList.fromJson(
        await _mediaService.get("/user?page=$page&limit=10"),
      );
      return data;
    } catch (e) {
      showSnackBar(
        _context,
        e.toString(),
        Colors.red,
      );
    }
  }

  Future<UserData?> getUserData({required String id}) async {
    try {
      parentUserData.fromJson(
        await _mediaService.get("/user/$id"),
      );
    } catch (e) {
      print(e);
      showSnackBar(
        _context,
        e.toString(),
        Colors.red,
      );
    }
  }

  Future<dynamic> createUser({required UserData userData}) async {
    try {
      parentUserData.fromJson(
        await _mediaService.post(
          "/user/create",
          {
            "firstName": userData.firstName,
            "lastName": userData.lastName,
            "picture": userData.picture,
            "email": userData.email
          },
        ),
      );
    } catch (e) {
      showSnackBar(
        _context,
        e.toString(),
        Colors.red,
      );
    }
  }

  Future<UserData?> updateUser(
      {required String id, required Map<String, dynamic> body}) async {
    try {
      UserData data = parentUserData.fromJson(
        await _mediaService.update(
          "/user/${id}",
          body,
        ),
      );
      return data;
    } catch (e) {
      showSnackBar(
        _context,
        e.toString(),
        Colors.red,
      );
    }
  }

  Future<dynamic> deleteUser({required UserData userData}) async {
    try {
      UserData data = parentUserData.fromJson(
        await _mediaService.delete("/user/${userData.id}"),
      );
      if (userData.id == data.id) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      showSnackBar(
        _context,
        e.toString(),
        Colors.red,
      );
    }
  }
}

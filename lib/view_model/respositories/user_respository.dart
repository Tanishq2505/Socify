import 'package:socify/model/data/user.dart';
import 'package:socify/model/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:socify/view/widgets/show_snackbar.dart';

class UserRepositories {
  late final MediaService _mediaService;
  late BuildContext _context;
  UserRepositories(BuildContext context) {
    _mediaService = MediaService();
    _context = context;
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
      UserData data = UserData.fromJson(
        await _mediaService.get("/user/$id"),
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

  Future<UserData?> createUser({required UserData userData}) async {
    try {
      UserData data = UserData.fromJson(
        await _mediaService.post(
          "/user/create",
          userData.toJson(),
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

  Future<UserData?> updateUser({required UserData userData}) async {
    try {
      UserData data = UserData.fromJson(
        await _mediaService.update(
          "/user/${userData.id}",
          userData.toJson(),
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
      UserData data = UserData.fromJson(
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

import 'package:socify/model/data/post.dart';
import 'package:socify/model/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:socify/view/widgets/show_snackbar.dart';

class PostRepositories {
  late final MediaService _mediaService;
  late BuildContext _context;
  PostRepositories(BuildContext context) {
    _mediaService = MediaService();
    _context = context;
  }

  Future<PostDataList?> getPostList({required String page}) async {
    try {
      PostDataList data = PostDataList.fromJson(
        await _mediaService.get("/post?page=$page&limit=10"),
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

  Future<PostDataList?> getPostListByUser({required String id}) async {
    try {
      PostDataList data = PostDataList.fromJson(
        await _mediaService.get("/user/$id/post"),
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

  Future<PostDataList?> getPostListByTag(
      {required String tag, required String page}) async {
    try {
      PostDataList data = PostDataList.fromJson(
        await _mediaService.get("/tag/$tag/post?page=$page&limit=10"),
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

  Future<PostData?> getPostData({required String id}) async {
    try {
      PostData data = PostData.fromJson(
        await _mediaService.get("/post/$id"),
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

  Future<PostData?> createPost({required PostData postData}) async {
    try {
      PostData data = PostData.fromJson(
        await _mediaService.post(
          "/post/create",
          postData.toJson(),
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

  Future<PostData?> updatePost({required PostData postData}) async {
    try {
      PostData data = PostData.fromJson(
        await _mediaService.update(
          "/post/${postData.id}",
          postData.toJson(),
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

  Future<dynamic> deleteUser({required PostData userData}) async {
    try {
      PostData data = PostData.fromJson(
        await _mediaService.delete("/post/${userData.id}"),
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

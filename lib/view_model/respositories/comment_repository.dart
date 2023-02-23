import 'package:socify/model/data/comment.dart';
import 'package:socify/model/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:socify/view/widgets/show_snackbar.dart';

class CommentRepositories {
  late final MediaService _mediaService;
  late BuildContext _context;
  CommentRepositories(BuildContext context) {
    _mediaService = MediaService();
    _context = context;
  }

  Future<CommentListData?> getCommentList({required String page}) async {
    try {
      CommentListData data = CommentListData.fromJson(
        await _mediaService.get("/comment?page=$page&limit=10"),
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

  Future<CommentListData?> getCommentListByPost({required String id}) async {
    try {
      CommentListData data = CommentListData.fromJson(
        await _mediaService.get("/post/$id/comment"),
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

  Future<CommentListData?> getCommentListByUser(
      {required String id, required String page}) async {
    try {
      CommentListData data = CommentListData.fromJson(
        await _mediaService.get("/user/$id/comment?page=$page&limit=10"),
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

  Future<CommentData?> createComment(
      {required Map<String, dynamic> commentData}) async {
    try {
      CommentData data = CommentData.fromJson(
        await _mediaService.post(
          "/comment/create",
          commentData,
        ),
      );
      return data;
    } catch (e) {
      print(e);
      showSnackBar(
        _context,
        e.toString(),
        Colors.red,
      );
    }
  }

  Future<dynamic> deleteUser({required CommentData commentData}) async {
    try {
      CommentData data = CommentData.fromJson(
        await _mediaService.delete("/comment/${commentData.id}"),
      );
      if (commentData.id == data.id) {
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

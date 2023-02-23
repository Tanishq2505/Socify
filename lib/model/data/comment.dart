import 'package:socify/model/data/user.dart';

class CommentListData {
  List<CommentData>? data;
  int? total;
  int? page;
  int? limit;

  CommentListData({this.data, this.total, this.page, this.limit});

  CommentListData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CommentData>[];
      json['data'].forEach((v) {
        data!.add(new CommentData.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    return data;
  }
}

class CommentData {
  String? id;
  String? message;
  UserData? owner;
  String? post;
  String? publishDate;

  CommentData({this.id, this.message, this.owner, this.post, this.publishDate});

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    owner =
        json['owner'] != null ? new UserData().fromJson(json['owner']) : null;
    post = json['post'];
    publishDate = json['publishDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    data['post'] = this.post;
    data['publishDate'] = this.publishDate;
    return data;
  }
}

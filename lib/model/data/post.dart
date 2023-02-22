class PostDataList {
  List<PostData>? data;
  int? total;
  int? page;
  int? limit;

  PostDataList({this.data, this.total, this.page, this.limit});

  PostDataList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PostData>[];
      json['data'].forEach((v) {
        data!.add(new PostData.fromJson(v));
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

class PostData {
  String? id;
  String? image;
  int? likes;
  String? link;
  List<String>? tags;
  String? text;
  String? publishDate;
  Owner? owner;

  PostData(
      {this.id,
      this.image,
      this.likes,
      this.link,
      this.tags,
      this.text,
      this.publishDate,
      this.owner});

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    likes = json['likes'];
    link = json['link'];
    tags = json['tags'].cast<String>();
    text = json['text'];
    publishDate = json['publishDate'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['likes'] = this.likes;
    data['link'] = this.link;
    data['tags'] = this.tags;
    data['text'] = this.text;
    data['publishDate'] = this.publishDate;
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    return data;
  }
}

class Owner {
  String? id;
  String? title;
  String? firstName;
  String? lastName;
  String? picture;

  Owner({this.id, this.title, this.firstName, this.lastName, this.picture});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['picture'] = this.picture;
    return data;
  }
}

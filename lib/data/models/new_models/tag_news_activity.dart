// import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

class TagNewsActivityResponse {
  TagNewsActivityResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final List<TagNewsActivity> data;

  factory TagNewsActivityResponse.fromJson(Map<String, dynamic> json) =>
      TagNewsActivityResponse(
        status: json["status"],
        data: json["data"].length == 0
            ? []
            : List<TagNewsActivity>.from(
                json["data"].map((x) => TagNewsActivity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TagNewsActivity {
  TagNewsActivity({
    this.index,
    @required this.id,
    @required this.name,
    @required this.slug,
  });

  final int index;
  final int id;
  final String name;
  final String slug;

  factory TagNewsActivity.fromJson(Map<String, dynamic> json) =>
      TagNewsActivity(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
      };
}

// class TagNewsActivityResponse {
//   TagNewsActivityResponse({
//     @required this.status,
//     @required this.data,
//   });

//   final String status;
//   final List<TagNewsActivity> data;

//   factory TagNewsActivityResponse.fromJson(Map<String, dynamic> json) =>
//       TagNewsActivityResponse(
//         status: json["status"],
//         data: json["data"].length == 0
//             ? []
//             : List<TagNewsActivity>.from(
//                 json["data"].map((x) => TagNewsActivity.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class TagNewsActivity {
//   TagNewsActivity({
//     this.index,
//     @required this.id,
//     @required this.name,
//     @required this.slug,
//     @required this.createdAt,
//     @required this.updatedAt,
//     @required this.posts,
//   });

//   final int index;
//   final int id;
//   final String name;
//   final String slug;
//   final String createdAt;
//   final String updatedAt;
//   List<Posts> posts;

//   factory TagNewsActivity.fromJson(Map<String, dynamic> json) =>
//       TagNewsActivity(
//         id: json["id"],
//         name: json["name"],
//         slug: json["slug"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         posts: json["posts"] == null
//             ? []
//             : json["posts"].length == 0
//                 ? []
//                 : List<Posts>.from(json["posts"].map((x) => Posts.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "slug": slug,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "posts": posts,
//       };
// }

// class Posts {
//   Posts({
//     this.index,
//     @required this.id,
//     @required this.cover,
//     @required this.title,
//     @required this.slug,
//     @required this.description,
//     @required this.createdAt,
//     @required this.updatedAt,
//   });

//   final int index;
//   final int id;
//   final String cover;
//   final String title;
//   final String slug;
//   final String description;
//   final String createdAt;
//   final String updatedAt;

//   factory Posts.fromJson(Map<String, dynamic> json) => Posts(
//         id: json["id"],
//         cover: json["cover"],
//         title: json["title"],
//         slug: json["slug"],
//         description: json["description"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "cover": cover,
//         "title": title,
//         "slug": slug,
//         "description": description,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//       };
// }

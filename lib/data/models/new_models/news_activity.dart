import 'package:flutter/cupertino.dart';
import 'package:marketplace/data/models/new_models/tag_news_activity.dart';

class NewsActivityResponse {
  NewsActivityResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final List<NewsActivity> data;

  factory NewsActivityResponse.fromJson(Map<String, dynamic> json) =>
      NewsActivityResponse(
        status: json["status"],
        data: json["data"].length == 0
            ? []
            : List<NewsActivity>.from(
                json["data"].map((x) => NewsActivity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NewsActivity {
  NewsActivity({
    this.index,
    @required this.id,
    @required this.cover,
    @required this.title,
    @required this.slug,
    @required this.description,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.tags,
  });

  final int index;
  final int id;
  final String cover;
  final String title;
  final String slug;
  final String description;
  final String createdAt;
  final String updatedAt;
  final List<int> tags;

  factory NewsActivity.fromJson(Map<String, dynamic> json) => NewsActivity(
      id: json["id"],
      cover: json["cover"],
      title: json["title"],
      slug: json["slug"],
      description: json["description"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      tags: List<int>.from(json["tags"].map((x) => x)));

  Map<String, dynamic> toJson() => {
        "id": id,
        "cover": cover,
        "title": title,
        "slug": slug,
        "description": description,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

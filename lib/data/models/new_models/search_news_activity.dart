import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/data/models/new_models/search_news_activity.dart';

class SearchNewsActivityResponse {
  SearchNewsActivityResponse({
    @required this.message,
    @required this.data,
  });

  final String message;
  final List<NewsActivity> data;

  factory SearchNewsActivityResponse.fromJson(Map<String, dynamic> json) =>
      SearchNewsActivityResponse(
        message: json["message"],
        data: json["data"].length == 0
            ? []
            : List<NewsActivity>.from(
                json["data"].map((x) => NewsActivity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
      };
}

class SearchDataNewsActivityOld {
  SearchDataNewsActivityOld({
    @required this.newsActivitySearch,
  });

  final List<NewsActivity> newsActivitySearch;

  factory SearchDataNewsActivityOld.fromJson(Map<String, dynamic> json) =>
      SearchDataNewsActivityOld(
        newsActivitySearch: json["posts"].length == 0
            ? []
            : List<NewsActivity>.from(
                json["posts"].map((x) => NewsActivity.fromJson(x))),
      );
}

import 'dart:convert';

List<Events> eventFromJson(String str) => List<Events>.from(json.decode(str).map((x) => Events.fromJson(x)));

String eventToJson(List<Events> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Events {

  String url;
  String name;
  String endDate;
  String icon;

  Events({

    this.url,
    this.name,
    this.endDate,
    this.icon,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(

    url: json["url"],
    name: json["name"],
    endDate: json["endDate"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {

    "url": url,
    "name": name,
    "endDate": endDate,
    "icon": icon,
  };
}
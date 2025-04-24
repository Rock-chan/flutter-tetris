class PrivacyEntity {
  PrivacyEntity({
    this.id,
    this.link,
    this.isPrivacy,
  });

  PrivacyEntity.fromJson(dynamic json) {
    id = json['id'];
    link = json['link'];
    isPrivacy = json['webView'];
  }

  int? id;
  String? link;
  bool? isPrivacy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['link'] = link;
    map['webView'] = isPrivacy;
    return map;
  }
}

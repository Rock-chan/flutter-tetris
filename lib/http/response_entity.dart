/// code : 200
/// message : "success!"
/// data : {"id":"2e05baee03214d978312a793541a33ba","userName":"Rockchen","phoneNum":"13532613687","createTime":"1721362371949","avatar":"asdfdasfasdfdsa","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjJlMDViYWVlMDMyMTRkOTc4MzEyYTc5MzU0MWEzM2JhIiwidXNlck5hbWUiOiJSb2NrY2hlbiIsImV4cCI6MTcyMjc3NjM2N30.SLh3gb6RBONQNwsRV00Y1dFNzWoT_J5XyJDpwwNQRwc"}
library;

class ResponseEntity {
  ResponseEntity({
    this.code,
    this.message,
    this.data,
  });

  ResponseEntity.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }

  int? code;
  String? message;
  dynamic data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (data != null) {
      map['data'] = data;
    }
    return map;
  }
}

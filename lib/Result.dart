class Result{
  int code;
  var data;
  String msg;
  bool success;
  Result({this.code, this.data, this.msg, this.success});

  Result.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'];
    msg = json['msg'];
    success = json['success'];
  }
  bool isOk(){
     return code == 200;
  }
}
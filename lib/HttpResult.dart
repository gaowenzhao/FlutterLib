class HttpResult {
  var data;
  bool success;
  int code;
  var headers;

  HttpResult(this.data, this.success, this.code, {this.headers});
}
import 'package:flutterlib/net/HttpRequest.dart';
import 'package:flutterlib/net/HttpResult.dart';
import 'package:flutterlib/net/Result.dart';
class HttpApi{
   static get(String url,{param,Function success,Function error}) async {
    HttpResult data = await HttpRequest.get(url,param:param);
    _handleData(data,success,error: error);
  }
  static post(String url,{param,Function success,Function error})async{
    HttpResult data = await HttpRequest.post(url,param:param);
    _handleData(data,success,error: error);
  }
  static _handleData(HttpResult data,Function success, {Function error}){
    if (data.success) {
      Result result = Result.fromJson(data.data);
      result.isOk()? success(result.data):(error!=null)? error(result.code,result.msg) : print("error:noSuchMethod");
    } else {
       (error!=null)?error(data.code,data.data):print("error:noSuchMethod");
    }
  }
}
import 'package:package_info/package_info.dart';
class PackInfoUtils{
    static geVersionName() async{
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    }
   static getVersionCode()async{
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.buildNumber;
    }
    static getAppName() async{
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.appName;
    }
    static getPackageName() async{
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.packageName;
    }
}
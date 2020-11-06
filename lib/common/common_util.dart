
import 'package:url_launcher/url_launcher.dart';

/// 统一跳转到外部浏览器，并打开指定地址
jumpWeb(String url) async {
  if(await canLaunch(url)){
    await launch(url);
  } else {
    throw 'Can not launch $url';
  }
}

String assetsImg(String name, {String path: 'assets/', String fileType: 'png'}){
  return '$path$name.$fileType';
}
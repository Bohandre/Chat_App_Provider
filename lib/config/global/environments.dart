import 'dart:io';

class Environments {
  static String ip = '192.168.0.13';

  static String apiUrl =
      Platform.isAndroid ? 'http://$ip:3000/api' : 'http://0.0.0.0:3000/api';

  static String socketUrl =
      Platform.isAndroid ? 'http://$ip:3000' : 'http://0.0.0.0:3000';
}

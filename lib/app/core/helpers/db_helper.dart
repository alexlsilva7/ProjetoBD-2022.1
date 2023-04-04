import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbHelper {
  static String _host = 'localhost';
  static int _port = 3307;
  static String _user = 'root';
  static String _password = 'root_pass';
  static String _db = 'projeto-bd';
  //mysql -u root -p projeto-bd

  static Future<void> initConfig() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('host') == null) {
      throw Exception('Host não configurado!');
    } else {
      _host = prefs.getString('host')!;
      _port = prefs.getInt('port')!;
      _user = prefs.getString('user')!;
      _password = prefs.getString('password')!;
      _db = prefs.getString('db')!;
    }
  }

  static Future<ConnectionSettings> getConfig() async {
    final prefs = await SharedPreferences.getInstance();

    var host = prefs.getString('host');
    var port = prefs.getInt('port');
    var user = prefs.getString('user');
    var password = prefs.getString('password');
    var db = prefs.getString('db');

    if (host == null ||
        port == null ||
        user == null ||
        password == null ||
        db == null) {
      return ConnectionSettings(
        host: _host,
        port: _port,
        user: _user,
        password: _password,
        db: _db,
      );
    } else {
      return ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db,
      );
    }
  }

  static Future<void> setConfig(ConnectionSettings connectionSettings) async {
    _host = connectionSettings.host;
    _port = connectionSettings.port;
    _user = connectionSettings.user!;
    _password = connectionSettings.password!;
    _db = connectionSettings.db!;

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('host', _host);
    prefs.setInt('port', _port);
    prefs.setString('user', _user);
    prefs.setString('password', _password);
    prefs.setString('db', _db);
  }

  static Future<MySqlConnection> getConnection() async {
    return await MySqlConnection.connect(ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
      password: _password,
      db: _db,
    ));
  }
}

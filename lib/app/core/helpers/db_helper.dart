import 'package:mysql1/mysql1.dart';

class DbHelper {
  static const _host = 'localhost';
  static const _port = 3307;
  static const _user = 'root';
  static const _password = 'root_pass';
  static const _db = 'projeto-bd';
  //mysql -u root -p projeto-bd

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

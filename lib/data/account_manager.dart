// for coding accounts

class UserAccount {
  final String username;
  final String password;

  UserAccount({required this.username, required this.password});
}

class AccountManager {
  static final List<UserAccount> _accounts = [
    UserAccount(username: "Admin", password: "admin123"),
  ];

  static bool validateLogin(String username, String password) {
    return _accounts.any((account) => account.username == username && account.password == password);
  }
}
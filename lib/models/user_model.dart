class UserModel {
  String name;
  String email;
  String password;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
  });

  // Getter
  String get userName => name;

  String get userEmail => email;

  // Setter
  set userName(String newName) {
    name = newName;
  }

  set userEmail(String newEmail) {
    email = newEmail;
  }

  // Function / Method
  String getUserInfo() {
    return '$name - $email';
  }

  // Function untuk mengubah data pengguna
  void updateProfile({
    String? newName,
    String? newEmail,
  }) {
    if (newName != null && newName.isNotEmpty) {
      name = newName;
    }

    if (newEmail != null && newEmail.isNotEmpty) {
      email = newEmail;
    }
  }
}
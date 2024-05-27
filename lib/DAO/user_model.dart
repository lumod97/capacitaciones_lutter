class UserModel {
  final int? id;
  final String? user_name;
  final String? id_user;
  final String? password;
  
  

  UserModel({this.id, this.user_name, this.id_user, this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_name': user_name,
      'id_user': id_user,
      'password': password
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      user_name: map['user_name'],
      id_user: map['id_user'],
      password: map['password']
    );
  }
}

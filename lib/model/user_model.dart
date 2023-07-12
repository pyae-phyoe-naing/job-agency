import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final User? user;
  final String? cloudMessageToken;
  final String? city;
  final String role;
  final double price;
  UserModel(
      {this.user, this.cloudMessageToken,this.city, this.role = 'user', this.price = 0});


  Map<String, dynamic> toJson() => {
        'cloudMessageToken': cloudMessageToken,
        'role': role,
        'displayName': user?.displayName,
        'email': user?.email,
        'photoURL': user?.photoURL,
        'price': price,
        'city':city
      };

  Map<String, dynamic> toUpdate() => {
        'cloudMessageToken': cloudMessageToken,
        'displayName': user?.displayName,
        'email': user?.email,
        'photoURL': user?.photoURL,
        'price': price,
        'city':city
      };
}

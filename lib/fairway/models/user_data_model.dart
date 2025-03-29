import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  const UserData({
    required this.id,
    required this.name,
    required this.email,
    // required this.phone,
    required this.location,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] as Map<String, dynamic>? ?? json;
    return UserData(
      id: userData['id'] as String,
      name: userData['name'] as String,
      email: userData['email'] as String,
      // phone: userData['phone'] as String,
      location: userData['location'] as String,
    );
  }
  final String id;
  final String name;
  final String email;
  // final String phone;
  final String location;

  @override
  List<Object?> get props => [id, name, email, location];
}


import 'package:flutter/foundation.dart';

enum UserRole { customer, doctor, seller }

class User {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final int age;
  
  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.age,
  });
}

class UserProvider with ChangeNotifier {
  UserRole _role = UserRole.customer;
  
  final Map<UserRole, User> _userDetails = {
    UserRole.customer: User(
      name: 'Gujjar',
      email: 'Gujjar@example.com',
      phone: '+91 98765 43210',
      address: 'Kendumundi Road, Northern Division',
      city: 'Dhanbad, Jharkhand',
      age: 28,
    ),
     UserRole.doctor: User(
      name: 'Dr. Rachit',
      email: 'dr.rachit@petnest.pro',
      phone: '+91 91234 56789',
      address: 'Veterinary Clinic, Main St',
      city: 'Dhanbad, Jharkhand',
      age: 35,
    ),
     UserRole.seller: User(
      name: 'Rachit',
      email: 'rachit.pets@seller.net',
      phone: '+91 87654 32109',
      address: 'Pet Supply Store, Market Rd',
      city: 'Dhanbad, Jharkhand',
      age: 28,
    ),
  };

  UserRole get role => _role;
  User get currentUser => _userDetails[_role]!;

  String get userName =>"Aayush";

  String get email => "aayush@gmail.com";

  String get city => "Meerut";

  String get address => "south";

  String get phone => "787485486";

  get age => "16";

  void setRole(UserRole newRole) {
    if (_role != newRole) {
      _role = newRole;
      notifyListeners();
    }
  }
}

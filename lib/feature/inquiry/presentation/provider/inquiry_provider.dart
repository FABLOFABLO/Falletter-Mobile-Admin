import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminContact {
  final String name;
  final String role;
  final String description;
  final String mobile;
  final String email;

  const AdminContact({
    required this.name,
    required this.role,
    required this.description,
    required this.mobile,
    required this.email,
  });
}

final inquiryAdminsProvider = Provider<List<AdminContact>>((ref) {
  return const [
    AdminContact(
      name: '김시흔',
      role: '관리자',
      description: 'Backend Engineer | FABLO',
      mobile: '010-6645-3576',
      email: 'siheun9@gmail.com',
    ),
    AdminContact(
      name: '최승우',
      role: '운영자',
      description: 'Flutter Developer | FABLO',
      mobile: '010-4041-2250',
      email: 'choi0250655@gmail.com',
    ),
    AdminContact(
      name: '이지아',
      role: '운영자',
      description: 'Flutter Developer | FABLO',
      mobile: '010-5956-1450',
      email: 'hx.un0707@gmail.com',
    ),
    AdminContact(
      name: '김수인',
      role: '운영자',
      description: 'Designer | FABLO',
      mobile: '010-6879-7520',
      email: 'suink0523@gmail.com',
    ),
  ];
});

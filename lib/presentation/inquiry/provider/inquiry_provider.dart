import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminContact {
  final String name;
  final String role;

  const AdminContact({
    required this.name,
    required this.role,
  });
}

final inquiryAdminsProvider = Provider<List<AdminContact>>((ref) {
  return const [
    AdminContact(name: '유하은', role: '관리자'),
    AdminContact(name: '정지윤', role: '관리자'),
    AdminContact(name: '최승우', role: '운영자'),
    AdminContact(name: '이지아', role: '운영자'),
    AdminContact(name: '이승현', role: '운영자'),
    AdminContact(name: '김수인', role: '운영자'),
  ];
});
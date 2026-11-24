import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/core/error/app_error_type.dart';
import 'package:falletter_mobile_admin/core/error/app_exception.dart';
import 'package:flutter/material.dart';

/// 에러 종류에 맞는 문구를 스낵바로 보여준다.
/// [error]가 [AppException]이 아니면 unknown 문구를 쓴다.
void showErrorSnackBar(
  BuildContext context,
  Object error, {
  double bottomMargin = 20,
}) {
  final type = error is AppException ? error.type : AppErrorType.unknown;
  final bottomInset = MediaQuery.of(context).viewInsets.bottom;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + bottomMargin),
        backgroundColor: FalletterColor.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
        content: Text(
          type.message,
          style: FalletterTextStyle.body2.copyWith(color: FalletterColor.white),
        ),
      ),
    );
}

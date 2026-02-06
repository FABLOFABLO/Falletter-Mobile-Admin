import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/button/elevated_button.dart';
import 'package:falletter_mobile_admin/core/components/text_form_field/text_form_field.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/presentation/notice/provider/notice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoticeWriteView extends ConsumerStatefulWidget {
  const NoticeWriteView({super.key});

  @override
  ConsumerState<NoticeWriteView> createState() => _NoticeWriteViewState();
}

class _NoticeWriteViewState extends ConsumerState<NoticeWriteView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool get _canSave =>
      _titleController.text.trim().isNotEmpty &&
          _contentController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  void _onChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onSave() {
    ref.read(noticeProvider.notifier).addNotice(
      title: _titleController.text,
      content: _contentController.text,
      teacher: '관리자', /// 연동 시 수정
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FalletterColor.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(showBack: true, showLogout: false),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: '제목 입력',
                          contentPadding: EdgeInsets.all(14),
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomTextFormField(
                        controller: _contentController,
                        maxLines: 23,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: '내용입력',
                          contentPadding: EdgeInsets.all(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: CustomElevatedButton(
                  onPressed: _canSave ? _onSave : null,
                  child: const Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

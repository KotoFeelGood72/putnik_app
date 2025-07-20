import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:putnik_app/services/user/user_repository.dart';
import 'package:putnik_app/models/user_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

@RoutePage()
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String? _gender;
  bool _loading = false;
  UserModel? _userModel;
  File? _pickedImage;
  String? _avatarUrl;

  final List<String> _genders = ['Мужской', 'Женский', 'Другое'];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userModel = await UserRepository().getUser(user.uid);
    if (userModel != null) {
      setState(() {
        _userModel = userModel;
        _nameCtrl.text = userModel.name ?? '';
        _surnameCtrl.text = userModel.surname ?? '';
        _ageCtrl.text = userModel.age?.toString() ?? '';
        _cityCtrl.text = userModel.city ?? '';
        _bioCtrl.text = userModel.bio ?? '';
        _gender = userModel.gender;
        _emailCtrl.text = userModel.email ?? '';
        _avatarUrl = userModel.avatar;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
        _avatarUrl = null; // Показываем локальное превью
      });
    }
  }

  Future<String?> _uploadImage(File file, String uid) async {
    // TODO: Реализовать загрузку в Firebase Storage и вернуть ссылку
    return null;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    String? avatarUrl = _avatarUrl;
    if (_pickedImage != null) {
      avatarUrl = await _uploadImage(_pickedImage!, user.uid) ?? _avatarUrl;
    }
    final updatedUser = UserModel(
      uid: user.uid,
      name: _nameCtrl.text.trim(),
      surname: _surnameCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text.trim()),
      city: _cityCtrl.text.trim(),
      gender: _gender,
      bio: _bioCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      avatar: avatarUrl,
    );
    await UserRepository().saveUser(updatedUser);
    if (mounted) Navigator.of(context).pop(true);
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _ageCtrl.dispose();
    _cityCtrl.dispose();
    _bioCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const NewAppBar(title: 'Редактировать профиль'),
      body:
          _userModel == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    // Карточка профиля (форма)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.bg,
                                        width: 3,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 44,
                                      backgroundColor: AppColors.blue
                                          .withOpacity(0.10),
                                      backgroundImage:
                                          _pickedImage != null
                                              ? FileImage(_pickedImage!)
                                              : (_avatarUrl != null &&
                                                  _avatarUrl!.isNotEmpty)
                                              ? NetworkImage(_avatarUrl!)
                                                  as ImageProvider
                                              : null,
                                      child:
                                          (_pickedImage == null &&
                                                  (_avatarUrl == null ||
                                                      _avatarUrl!.isEmpty))
                                              ? const Icon(
                                                Icons.person,
                                                size: 44,
                                                color: AppColors.blue,
                                              )
                                              : null,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: _pickImage,
                                      borderRadius: BorderRadius.circular(24),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 22,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _nameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Имя',
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Введите имя'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _surnameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Фамилия',
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Введите фамилию'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _ageCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Возраст',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Введите возраст';
                                final age = int.tryParse(v);
                                if (age == null || age < 0 || age > 120)
                                  return 'Некорректный возраст';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _cityCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Город',
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Введите город'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _gender,
                              items:
                                  _genders
                                      .map(
                                        (g) => DropdownMenuItem(
                                          value: g,
                                          child: Text(g),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) => setState(() => _gender = val),
                              decoration: const InputDecoration(
                                labelText: 'Пол',
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Выберите пол'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _bioCtrl,
                              decoration: const InputDecoration(
                                labelText: 'О себе',
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Введите email'
                                          : null,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.blue,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: _loading ? null : _saveProfile,
                                child:
                                    _loading
                                        ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                        : const Text(
                                          'Сохранить',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
    );
  }
}

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:putnik_app/present/components/button/btn.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

class TaskModals extends StatefulWidget {
  const TaskModals({super.key});

  @override
  State<TaskModals> createState() => _TaskModalsState();
}

class _TaskModalsState extends State<TaskModals> {
  final List<File> _images = [];

  Future<void> _pickImage() async {
    if (_images.length >= 5) return;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Почистить зубы',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Я буду счастлив, если ты будешь чистить зубы\n2 минуты перед сном',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.black),
            ),
            const SizedBox(height: 24),
            const Text('Прогресс', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Row(
              children: const [
                Text('1/10', style: TextStyle(color: AppColors.border)),
                SizedBox(width: 8),
                // Expanded(
                //   child: ProgressLineBar(
                //     current: 40,
                //     total: 200,
                //     showDot: true,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Награда', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/star-shadow.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(height: 4),
                    const Text('+100'),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/earth.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(height: 4),
                    const Text('+100'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Время на выполнение',
              style: TextStyle(fontSize: 14, color: AppColors.black),
            ),
            const SizedBox(height: 4),
            const Text(
              '23:59',
              style: TextStyle(color: AppColors.black, fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildImageGrid(),
            const SizedBox(height: 16),
            Btn(text: 'Отправить на проверку', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return SizedBox(
      height: 250,
      child: GridView.builder(
        itemCount: _images.length < 5 ? _images.length + 1 : 5,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index < _images.length) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, size: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return GestureDetector(
              onTap: _pickImage,
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [6, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt, size: 36, color: Colors.purple),
                      SizedBox(height: 8),
                      Text(
                        'Сделать снимок',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'до 5 снимков будет достаточно',
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

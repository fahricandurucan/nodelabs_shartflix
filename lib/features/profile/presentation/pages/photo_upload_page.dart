import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:nodelabs_shartflix/core/constants/app_colors.dart';
import 'package:nodelabs_shartflix/features/auth/presentation/widgets/loading_gif_widget.dart';

import '../../../../core/services/api_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class PhotoUploadPage extends StatefulWidget {
  const PhotoUploadPage({super.key});

  @override
  State<PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();
  bool _isUploading = false;



  Future<void> _pickImageFromGallery() async {
    try {
      logDebug('📸 Picking image from gallery...');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        logDebug('✅ Image selected: ${image.path}');
        setState(() {
          _selectedImage = File(image.path);
        });
      } else {
        logDebug('❌ No image selected');
      }
    } catch (e) {
      logDebug('❌ Image picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fotoğraf seçilirken hata oluştu: ${e.toString()}'),
          backgroundColor: AppColors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      logDebug('📸 Picking image from camera...');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        logDebug('✅ Image selected: ${image.path}');
        setState(() {
          _selectedImage = File(image.path);
        });
      } else {
        logDebug('❌ No image selected');
      }
    } catch (e) {
      logDebug('❌ Camera error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kamera hatası: ${e.toString()}'),
          backgroundColor: AppColors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }



  Future<void> _uploadPhoto() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen önce bir fotoğraf seçin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      logDebug('📤 Starting photo upload...');
      logDebug('📁 File path: ${_selectedImage!.path}');
      
      // Use Auth Bloc to upload photo
      context.read<AuthBloc>().add(UploadPhotoRequested(_selectedImage!.path));
      
      // Listen for the result
      await for (final state in context.read<AuthBloc>().stream) {
        if (state is PhotoUploaded) {
          logDebug('✅ Upload successful: ${state.photoUrl}');
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fotoğraf başarıyla yüklendi!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate back to profile
          if (mounted) {
            context.go('/profile');
          }
          break;
        } else if (state is AuthError) {
          logDebug('❌ Upload error: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Yükleme sırasında hata oluştu: ${state.message}'),
              backgroundColor: AppColors.red,
            ),
          );
          break;
        } else if (state is Authenticated) {
          // Skip Authenticated state, we only want PhotoUploaded
          continue;
        }
      }
    } catch (e) {
      logDebug('❌ Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yükleme sırasında hata oluştu: ${e.toString()}'),
          backgroundColor: AppColors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title:  Text(
            'select_photo'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title:  Text(
                  'camera'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title:  Text(
                  'gallery'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.go('/profile');
            },
          ),
        ),
        title:  Text(
          'profile_photo'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Title
             Text(
              'upload_profile_photo'.tr(),
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),

            // Description Text
             Text(
              'upload_profile_photo_description'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48.h),

            // Photo Upload Area
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.grey.shade600,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18.r),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 40.sp,
                            ),
                          ),
                          SizedBox(height: 16.h),
                           Text(
                            'add_photo'.tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                           Text(
                            'select_from_camera_or_gallery'.tr(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 48.h),

            // Continue Button
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadPhoto,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: _isUploading
                  ?  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const LoadingGifWidget(color: Colors.white,)
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'loading'.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  :  Text(
                      'upload_photo'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:equatable/equatable.dart'; // Add this if you're using Equatable

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit() : super(ImagePickerInitial());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    emit(ImagePickerLoading());
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print('Image picked from gallery: ${image.path}');
        emit(ImagePickerSuccess(File(image.path)));
        print('ImagePickerSuccess emitted');
      } else {
        emit(ImagePickerError('No image selected'));
      }
    } catch (e) {
      emit(ImagePickerError('Failed to pick image: $e'));
    }
  }


  Future<void> capturePhoto() async {
    emit(ImagePickerLoading());
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        print('Photo captured: ${photo.path}');
        emit(ImagePickerSuccess(File(photo.path)));
      } else {
        emit(ImagePickerError('No photo captured'));
      }
    } catch (e) {
      emit(ImagePickerError('Failed to capture photo: $e'));
    }
  }
}

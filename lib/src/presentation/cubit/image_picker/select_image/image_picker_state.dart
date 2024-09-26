part of 'image_picker_cubit.dart';

// Cubit States
abstract class ImagePickerState {}

class ImagePickerInitial extends ImagePickerState {}

class ImagePickerLoading extends ImagePickerState {}

class ImagePickerSuccess extends ImagePickerState {
  final File image;
  ImagePickerSuccess(this.image);
}

class ImagePickerError extends ImagePickerState {
  final String message;
  ImagePickerError(this.message);
}

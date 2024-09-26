import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/image_picker/export_image_picker_cubits.dart';

class ImagePickerWidget extends StatelessWidget {
  final ValueChanged<File>? onImageSelected;

  const ImagePickerWidget({Key? key, this.onImageSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ImagePickerCubit, ImagePickerState>(
    
      builder: (context, state) {

        return GestureDetector(
          onTap: () {
            print('ImagePickerWidget tapped');
            _showImageSourceDialog(context);
          },
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey[200],
            child: Icon(
              Icons.camera_alt,
              size: 20.0,
              color: Colors.black,
            ),
          ),
        );
      },
    );

  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select an option"),
          actions: [
            TextButton(
              onPressed: () {
                print('Selected Gallery option');
                context.read<ImagePickerCubit>().pickImageFromGallery();
                Navigator.of(context).pop();
              },
              child: Text("Gallery"),
            ),
            TextButton(
              onPressed: () {
                print('Selected Camera option');
                context.read<ImagePickerCubit>().capturePhoto();
                Navigator.of(context).pop();
              },
              child: Text("Camera"),
            ),
          ],
        );
      },
    );
  }
}
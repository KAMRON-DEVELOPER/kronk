import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';

class ImageCropper extends StatefulWidget {
  final int resizeWidth;
  final int resizeHeight;
  final Function(Uint8List?) onImageCropped;
  const ImageCropper({
    super.key,
    required this.resizeWidth,
    required this.resizeHeight,
    required this.onImageCropped,
  });
  @override
  State<ImageCropper> createState() => _ImageCropperState();
}

class _ImageCropperState extends State<ImageCropper> {
  final _cropController = CropController();
  Uint8List? _pickedImage;
  Uint8List? _croppedImage;
  bool _isCleared = true;

  Future<void> _uploadImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    Uint8List? bytes = await pickedFile?.readAsBytes();
    Uint8List? resizedBytes =
        await resizeImage(bytes!, widget.resizeWidth, widget.resizeHeight);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = resizedBytes;
        _isCleared = false;
      });
    }
  }

  Future<Uint8List> resizeImage(
      Uint8List imageData, int width, int height) async {
    Uint8List compressedImage = await FlutterImageCompress.compressWithList(
      imageData,
      minWidth: width,
      minHeight: height,
      quality: 95,
    );
    return compressedImage;
  }

  void _crop() {
    if (_pickedImage != null) {
      _cropController.cropCircle();
    }
  }

  void _clear() {
    setState(() {
      _pickedImage = null;
      _croppedImage = null;
      _isCleared = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_croppedImage!= null);
    return Container(
      width: 320,
      height: 380,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.indigoAccent.withBlue(160),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purpleAccent, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (_pickedImage != null)
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1)),
              child: Crop(
                controller: _cropController,
                image: _pickedImage!,
                aspectRatio: 1 / 1, // Todo: fixed aspect ratio
                interactive: true, // Todo: zoom
                fixCropRect: true, // Todo: fixed crop, not move
                radius: 126, // Todo: half of the box
                baseColor: Colors.black87,
                maskColor: Colors.white.withOpacity(0.3),
                onCropped: (value) {
                  setState(() {
                    _croppedImage = value;
                  });
                  widget.onImageCropped(value);
                },
                initialRectBuilder: (viewportRect, imageRect) {
                  return Rect.fromLTRB(
                    viewportRect.left + 24,
                    viewportRect.top + 24,
                    viewportRect.right - 24,
                    viewportRect.bottom - 24,
                  );
                },
                cornerDotBuilder: (size, edgeAlignment) {
                  return Container(color: Colors.transparent);
                },
                progressIndicator: const CircularProgressIndicator(),
              ),
            )
          else
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.black54,
                border: Border.all(color: Colors.deepOrange, width: 1),
              ),
              child: const Icon(Iconsax.document_upload_bold, size: 64),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_isCleared)
                MaterialButton(
                  onPressed: Navigator.of(context).pop,
                  color: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Text("cancel"),
                )
              else
                MaterialButton(
                  onPressed: _clear,
                  color: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Text("clear"),
                ),
              if (_pickedImage == null)
                MaterialButton(
                  onPressed: _uploadImage,
                  color: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Text("upload"),
                )
              else
                MaterialButton(
                  onPressed: _crop,
                  color: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Text("crop"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

void showImageSelector({
  required BuildContext context,
  required int resizeWidth,
  required int resizeHeight,
  required int screenWidth,
  required int screenHeight,
  required Function(Uint8List?) onImageSelected,
}) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    barrierLabel: "",
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: animation.value,
        child: Opacity(
          opacity: animation.value,
          child: Dialog(
            backgroundColor: Colors.greenAccent.withOpacity(0.2),
            // clipBehavior: Clip.antiAlias,
            insetPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: ImageCropper(
                resizeHeight: resizeHeight,
                resizeWidth: resizeWidth,
                onImageCropped: (croppedImage) {
                  if (croppedImage != null) {
                    onImageSelected(croppedImage);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox.shrink();
    },
  );
}

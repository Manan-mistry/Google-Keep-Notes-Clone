import 'dart:io';
import 'package:keeps_note_clone/generated/l10n.dart';
import 'package:keeps_note_clone/screens/notes_detail_page.dart';
import 'package:keeps_note_clone/utils/app_theme.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:keeps_note_clone/utils/permission_handler.dart';
import 'package:keeps_note_clone/utils/screens.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CustomTabBar extends StatefulWidget {
  final Function onNotesChanged;

  const CustomTabBar({super.key, required this.onNotesChanged});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {

  final ImagePicker _picker = ImagePicker();
  String profile = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipPath(
            clipper: NotchedClipper(),
            child: Container(
              width: size.width,
              height: 70,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.7),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
                color: AppColor.cardColor,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      logPrint("Checkbox clicked");
                    },
                    icon: Icon(
                      Icons.check_box_outlined,
                      color: AppColor.white.withOpacity(0.8),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      logPrint("Color clicked");
                    },
                    icon: Icon(
                      Icons.brush_outlined,
                      color: AppColor.white.withOpacity(0.8),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      logPrint("Microphone clicked");
                    },
                    icon: const Icon(
                      Icons.mic_none_outlined,
                      color: AppColor.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      logPrint("Gallery clicked");
                      _showOptionsForPicker(context);
                    },
                    icon: const Icon(
                      Icons.photo_outlined,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            child: Container(
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.only(right: 45, bottom: 0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      settings: const RouteSettings(name: Screens.notesDetails),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return NotesDetailPage(
                          note: null,
                          image: profile,
                        );
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0); // Slide in from right
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  ).then((onValue) {
                    widget.onNotesChanged(onValue);
                  });
                },
                tooltip: 'Add Note',
                backgroundColor: AppColor.cardColor,
                child: Icon(
                  Icons.add,
                  color: AppColor.white.withOpacity(0.8),
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showOptionsForPicker(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: AppColor.bgColor,
              title: Text(
                S.of(context).add_image,
                style: CustomTheme.primaryTextStyle.merge(const TextStyle(fontSize: 26)),
              ),
              content: Container(
                color: AppColor.bgColor,
                constraints: const BoxConstraints(
                  minWidth: 260,
                  maxWidth: 260,
                  maxHeight: 100,
                ),
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.camera_alt_outlined,
                        color: AppColor.white,
                      ),
                      title: Text(
                        S.of(context).take_photo,
                        style: const TextStyle(
                          color: AppColor.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      minTileHeight: 40,
                      onTap: () {
                        logPrint("Camera Clicked");
                        checkPermission(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(
                        Icons.photo_size_select_actual_outlined,
                        color: AppColor.white,
                      ),
                      title: Text(
                        S.of(context).choose_image,
                        style: const TextStyle(
                          color: AppColor.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      minTileHeight: 40,
                      onTap: () {
                        logPrint("Gallery Clicked");
                        checkPermission(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  checkPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      bool canProceed = await PermissionHandlerService.handleCameraPermission(context);
      logPrint("Camera Permission =  $canProceed");
      if (canProceed) {
        chooseImage(source);
      }
    }
    else if (source == ImageSource.gallery) {
      chooseImage(source);
    }
  }
  chooseImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      try {
        final pickedFile = await (_picker.pickImage(source: ImageSource.camera)) as XFile;
        if (pickedFile != null) {
          _cropImage(pickedFile.path);
        } else {
          // Handle the case when no image is picked
          logPrint("No image picked.");
          return null;
        }
      } catch (e) {
        if (e is! TypeError) {
          Fluttertoast.showToast(
            msg: 'Image size should be less than 15Mb.',
            toastLength: Toast.LENGTH_SHORT,
            fontSize: 16,
          );
        }
        logPrint("Camera Image Fail $e");
      }
    }
    else {
      try {
        final pickedFile = await (_picker.pickImage(source: ImageSource.gallery)) as XFile;
        if (pickedFile != null) {
          _cropImage(pickedFile.path);
        } else {
          // Handle the case when no image is picked
          logPrint("No image picked.");
          return null;
        }
        // _cropImage(pickedFile.path);
      } catch (e) {
        if (e is! TypeError) {
          Fluttertoast.showToast(
            msg: 'Image size should be less than 15Mb.',
            toastLength: Toast.LENGTH_SHORT,
            fontSize: 16,
          );
        }
        logPrint("Gallery Image Fail $e");
      }
    }
  }
  _cropImage(String path) async {
    try {
      CroppedFile? croppedImage = (await ImageCropper.platform.cropImage(
          sourcePath: path,
          // aspectRatio: CropAspectRatioPreset.square,
      ));
      if (croppedImage != null) {
        setState(() {
          profile = croppedImage.path;
          logPrint("Cropped image = $profile");
        });
      }
    } catch (e) {
      logPrint("Error during cropping: $e");
    }
  }
}

class NotchedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double cornerRadius = 12;
    const double dipHeight = 30;

    final Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 110 - (cornerRadius / 2), 0);
    path.cubicTo(
      size.width - 110 + (cornerRadius / 2),
      cornerRadius, // Add corner radius to the top control point
      size.width - 110 + (cornerRadius / 2),
      dipHeight / 2,
      size.width - 110 + (cornerRadius),
      dipHeight,
    );
    path.lineTo(size.width - 110 + cornerRadius, dipHeight);
    path.cubicTo(
      size.width - 110 - cornerRadius,
      cornerRadius, // Add corner radius to the top control point
      size.width - 100 + cornerRadius,
      dipHeight - cornerRadius,
      size.width - 45,
      dipHeight - cornerRadius,
    );

    path.lineTo(size.width - 45 + cornerRadius, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


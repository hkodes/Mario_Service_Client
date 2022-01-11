import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mario_service/utils/theme.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showImageSourceDialog(BuildContext context,
      [Function(String url) param1]) {
    _handleImage(
        PickedFile picker, Function(String url) param1, BuildContext context) {
      if (picker != null) {
        param1(picker.path);
        Navigator.pop(context, picker.path);
      }
    }

    _item(String text, IconData icon, Function() onTap) {
      return Center(
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: onTap,
          child: Container(
            height: 100,
            width: 100,
            decoration: new BoxDecoration(
              color: ThemeLightColor.primary_color,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                ),
                Text(
                  text,
                ),
              ],
            ),
          ),
        ),
      );
    }

    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              height: MediaQuery.of(context).size.width / 2,
              child: Card(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Please Select a source of image",
                        ),
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _item("Camera", Icons.camera, () async {
                              PickedFile picker = await ImagePicker().getImage(
                                  source: ImageSource.camera,
                                  preferredCameraDevice: CameraDevice.front);

                              _handleImage(picker, param1, context);
                            }),
                            _item(
                              "Photos",
                              Icons.photo_size_select_actual,
                              () async {
                                PickedFile picker = await ImagePicker()
                                    .getImage(
                                        source: ImageSource.gallery,
                                        preferredCameraDevice:
                                            CameraDevice.front);
                                _handleImage(picker, param1, context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}

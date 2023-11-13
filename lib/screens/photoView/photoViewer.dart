import 'package:closer/color/MyColors.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/main.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screenshot/screenshot.dart';

class PhotoViewer extends StatelessWidget {
  final image;
  const PhotoViewer({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical:AppHeight.h6, horizontal: AppPadding.p20),
          child: GestureDetector(onTap: () => {Navigator.of(navigatorKey.currentContext!).pop()}, child: const Icon(Icons.close, color: AppColors.mainColor,)),
        ),
        Expanded(
          child: PhotoView(
            imageProvider: NetworkImage(image),
          ),
        ),
      ],
    );
  }
}

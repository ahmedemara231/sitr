import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

import '../../../../../core/extensions/align_helper.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widgets/image_widgets/cached_image.dart';

class ImageViewScreen extends StatelessWidget {
  final String url;
  const ImageViewScreen({super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PinchZoom(
        maxScale: 2.5,
        child: CachedImage(
            height: context.height / 2,
            width: context.width,
            url: url,
        ),
      ).centerWidget,
    );
  }
}

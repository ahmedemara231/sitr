import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/image_widgets/cached_image.dart';

class HomeImage extends StatelessWidget {
  final String url;
  const HomeImage({super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return CachedImage(url: url, borderRadius: BorderRadius.circular(8.r));
  }
}

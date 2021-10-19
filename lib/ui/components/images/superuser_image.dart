import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/images/empty_image.dart';

class SuperuserImage extends StatelessWidget {
  final url;
  final radius;
  final bordered;
  final reversed;

  SuperuserImage({
    this.url,
    this.radius,
    this.bordered = true,
    this.reversed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: url == null || url == ''
          ? EmptyImage(
              size: radius * 2,
              isReversed: reversed,
            )
          : CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
            ),
      width: radius * 2,
      height: radius * 2,
      padding: bordered && url != null && url != ''
          ? const EdgeInsets.all(1.0)
          : null, // borde width
      decoration: BoxDecoration(
        color: ConstantColors.IMAGE_BORDER, // border color
        shape: BoxShape.circle,
      ),
    );
  }
}

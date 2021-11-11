import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/providers/camera_provider.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class FilterPreview extends StatelessWidget {
  const FilterPreview({
    Key? key,
    required this.filter,
    required this.image,
  }) : super(key: key);

  final String filter;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Container();
    }

    final cameraProvider = Provider.of<CameraProvider>(
      context,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        cameraProvider.setFilter(filter);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 54.0,
              height: 54.0,
              decoration: BoxDecoration(
                border: cameraProvider.filter == filter
                    ? Border.all(color: ConstantColors.TURQUOISE, width: 3.0)
                    : Border.all(width: 0.0),
                borderRadius: BorderRadius.circular(27.0),
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: MemoryImage(
                    image!,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: Text(
                filter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cameraProvider.filter == filter
                      ? ConstantColors.TURQUOISE
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

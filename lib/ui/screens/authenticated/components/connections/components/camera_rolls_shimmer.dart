import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';

class CameraRollsShimmer extends StatelessWidget {
  const CameraRollsShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (_, __) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8.0),
                      height: 32.0,
                      width: 32.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width / 1.5,
                          height: 8.0,
                          color: Colors.white,
                          margin: const EdgeInsets.only(
                            top: 10.0,
                          ),
                        ),
                        Container(
                          width: size.width / 2,
                          height: 8.0,
                          color: Colors.white,
                          margin: EdgeInsets.only(
                            top: 3.0,
                            bottom: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: ConstantValues.MEDIA_TILE_HEIGHT,
                  child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        height: ConstantValues.MEDIA_TILE_HEIGHT,
                        width: ConstantValues.MEDIA_TILE_WIDTH,
                        color: Colors.white,
                        margin: const EdgeInsets.only(
                          right: 2.0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

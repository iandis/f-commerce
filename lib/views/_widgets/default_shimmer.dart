import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DefaultShimmer extends StatelessWidget {
  const DefaultShimmer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1000),
      baseColor: const Color(0xFFEEEEEE), // Colors.grey[200]
      highlightColor: const Color(0xFFF5F5F5), // Colors.grey[100]
      child: child,
    );
  }
}

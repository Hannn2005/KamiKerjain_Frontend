import 'package:flutter/material.dart';

/// Gambar jasa dari URL (Cloudinary) dengan placeholder bila kosong / gagal dimuat.
class JasaImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final double iconSize;

  const JasaImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
    this.iconSize = 40,
  }) : super(key: key);

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
        child: Icon(Icons.image, size: iconSize, color: Colors.grey),
      );

  @override
  Widget build(BuildContext context) {
    final u = url;
    return ClipRRect(
      borderRadius: borderRadius,
      child: (u == null || u.isEmpty)
          ? _placeholder()
          : Image.network(
              u,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : _placeholder(),
            ),
    );
  }
}

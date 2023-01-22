import 'package:flutter/material.dart';
import 'package:movie_app/theme/app_typography.dart';

class MovieListCard extends StatelessWidget {
  final Function() onTap;
  final String contentImage;
  final double width;
  final double height;
  final double padding;
  final String movieName;
  final int movieId;

  const MovieListCard({
    this.padding = 8,
    this.width = 150,
    this.height = 200,
    required this.movieName,
    required this.movieId,
    required this.onTap,
    required this.contentImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                right: 0,
                child: Image.asset(
                  contentImage,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: width,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                  ),
                  child: Text(
                    movieName,
                    maxLines: 2,
                    style: AppTypography.bodyText2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

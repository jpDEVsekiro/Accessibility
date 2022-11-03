import 'package:aps_dsd/src/ui/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class RattingBar extends StatelessWidget {
  const RattingBar({
    Key? key,
    required this.title,
    required this.ignoreGesture,
    this.rating = 0,
    this.onRatingUpdate,
  }) : super(key: key);
  final String title;
  final bool ignoreGesture;
  final double rating;
  final void Function(double)? onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.05, vertical: context.height * 0.015),
          child: SizedBox(
            width: context.width * 8,
            child: TextApp(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: context.width * 0.05,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
              maxLines: 2,
            ),
          ),
        ),
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          glow: false,
          ignoreGestures: ignoreGesture,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: context.width * 0.01),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
            size: context.width * 0.12,
          ),
          onRatingUpdate: onRatingUpdate ?? (_) {},
        )
      ],
    );
  }
}

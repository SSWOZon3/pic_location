import 'dart:ui';
import 'package:flutter/material.dart';

import '../screens/review_screen.dart';

class ItemInList extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String markerId;

  const ItemInList(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.markerId});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTapUp: (TapUpDetails tapUpDetails) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ReviewScreen(markerId: markerId),
        ));
      },
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // TODO: Basarse en el dispositivo
        margin: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Hero(
              tag: markerId,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaY: 10.0, sigmaX: 10.0),
                // TODO: Qué pasa cuando no tenemos imageUrl
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Hero(
                tag: title + markerId,
                child: Text(title,
                    style: TextStyle(
                        wordSpacing: 0,
                        color: Colors.white,
                        fontSize: screenSize.width * 0.06,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

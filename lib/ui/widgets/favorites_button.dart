import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pic_location/providers/user_provider.dart';

class AnimatedFavoritesIconButton extends StatefulWidget {
  final String notFavorite = 'assets/icons/not_favorite.png';
  final String favorite = 'assets/icons/favorite.png';
  bool isFavorite;
  Function function;

  AnimatedFavoritesIconButton({
    Key? key,
    required this.isFavorite,
    required this.function,
  }) : super(key: key);

  @override
  AnimatedFavoritesIconButtonState createState() =>
      AnimatedFavoritesIconButtonState();
}

class AnimatedFavoritesIconButtonState
    extends State<AnimatedFavoritesIconButton> {

  void _toggleImage() {
    setState(() {
      widget.isFavorite = !widget.isFavorite;
    });
    widget.function.call(widget.isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleImage,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Image.asset(
          widget.isFavorite ? widget.favorite : widget.notFavorite,
          key: ValueKey<bool>(widget.isFavorite),
          // Proporciona una clave única para cada imagen
          width: 50,
          // TODO: Fijar con respecto al tamaño del dispositivo
          height: 50,
        ),
      ),
    );
  }
}

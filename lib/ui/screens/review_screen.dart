import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pic_location/providers/user_provider.dart';
import '../../providers/review_state.dart';
import '../widgets/favorites_button.dart';
import 'package:collection/collection.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  final String markerId;

  const ReviewScreen({Key? key, required this.markerId}) : super(key: key);

  @override
  ReviewScreenState createState() => ReviewScreenState();
}

class ReviewScreenState extends ConsumerState<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(reviewStateProvider.notifier).getReviewData(widget.markerId);
  }

  @override
  Widget build(BuildContext context) {
    final reviewData = ref.watch(reviewStateProvider);
    final userData = ref.watch(userStateProvider);
    final userProvider = ref.read(userStateProvider.notifier);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: reviewData.id != ''
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: screenSize.width * 0.02),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(
                                0, 4),
                          ),
                        ],
                      ),
                      child: Hero(
                        tag: reviewData.id,
                        child: Image.network(
                          reviewData.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(screenSize.width * 0.03),
                          child: Hero(
                            tag: reviewData.title + reviewData.id,
                            child: Text(reviewData.title,
                                style: TextStyle(
                                    fontSize: screenSize.width * 0.06,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              screenSize.width * 0.03,
                              0,
                              screenSize.width * 0.03,
                              screenSize.width * 0.03),
                          child: Text(reviewData.description,
                              style: TextStyle(
                                fontSize: screenSize.width * 0.05,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.width * 0.02),
                    AnimatedFavoritesIconButton(
                        isFavorite: userData.favorites.firstWhereOrNull(
                                    (review) => review.id == reviewData.id) !=
                                null
                            ? true
                            : false,
                        function: (bool isFavorite) {
                          isFavorite
                              ? ref
                                  .read(userStateProvider.notifier)
                                  .addReviewToFavorites(reviewData.id)
                              : ref
                                  .read(userStateProvider.notifier)
                                  .removeReviewFromFavorites(reviewData.id);
                        }),
                    // TODO: Coger la ciudad a la que pertenece
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pic_location/providers/user_provider.dart';
import 'package:pic_location/ui/widgets/item_in_list.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // ref.read(userStateProvider.notifier).getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoritos"),
      ),
      body: ListView.builder(
        itemCount: userData.favorites.length,
        itemBuilder: (context, index) {
          return ItemInList(
              title: userData.favorites[index].title,
              imageUrl: userData.favorites[index].imageUrl,
              markerId: userData.favorites[index].id,
          );
          //'https://www.blogdelfotografo.com/wp-content/uploads/2019/02/johannes-plenio-629984-unsplash.jpg'
        },
      ),
    );
  }
}

//                userData.favorites[index].title,
//Image.network(
//                     'https://www.blogdelfotografo.com/wp-content/uploads/2019/02/johannes-plenio-629984-unsplash.jpg',
//                     fit: BoxFit.cover,
//                     height: 200.0,
//                     width: double.infinity,
//                     loadingBuilder: (BuildContext context, Widget child,
//                         ImageChunkEvent? loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         child: Container(
//                           height: 200.0, // Ajustar según tu diseño
//                           width: double.infinity,
//                           color: Colors.white,
//                         ),
//                       );
//                     },
//                   ),

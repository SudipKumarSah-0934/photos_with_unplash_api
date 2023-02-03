import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:photos_with_unplash_api/components/components.dart';
import 'package:photos_with_unplash_api/controller/home_vew_controller.dart';
import 'package:photos_with_unplash_api/service/api_service.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final HomeViewController _homeViewController = Get.put(HomeViewController());

  @override
  Widget build(BuildContext context) {
    ApiService().getMethod(
        'https://api.unsplash.com/photos/?per_page=30&order_by=popular&client_id=dmBjIcTCWhQ7wKqk8X6xix44b75p-H9dpxVlQScGFfc');
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              MyAppBar(size: size),
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildTabBar(),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      flex: 13,
                      child: Obx(
                        () => _homeViewController.isLoading.value
                            ? Center(
                                child: customLoading(),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: GridView.custom(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    gridDelegate: SliverQuiltedGridDelegate(
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                      crossAxisCount: 4,
                                      pattern: [
                                        QuiltedGridTile(2, 2),
                                        QuiltedGridTile(1, 1),
                                        QuiltedGridTile(1, 1),
                                        QuiltedGridTile(1, 2),
                                      ],
                                    ),
                                    childrenDelegate:
                                        SliverChildBuilderDelegate(
                                            childCount: _homeViewController
                                                .photos
                                                .length, (context, index) {
                                      return CachedNetworkImage(
                                        imageUrl: _homeViewController
                                            .photos[index].urls!['small'],
                                        imageBuilder: (ctx, img) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: img,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                        placeholder: (context, url) => Center(
                                          child: customLoading(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                          child: errorIcon(),
                                        ),
                                      );
                                    })),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return ListView.builder(
        itemCount: _homeViewController.orders.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: ((context, index) {
          return Obx(
            () => GestureDetector(
              onTap: () {
                _homeViewController.orderFunc(_homeViewController.orders[index]);
                _homeViewController.selectedIndex.value = index;
              },
              child: AnimatedContainer(
                margin: EdgeInsets.fromLTRB(index == 0 ? 1 : 5, 0, 5, 0),
                duration: Duration(seconds: 3),
                width: 100,
                decoration: BoxDecoration(
                  color: index == _homeViewController.selectedIndex.value
                      ? Colors.grey[700]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(
                      index == _homeViewController.selectedIndex.value
                          ? 18
                          : 15),
                ),
                child: Center(
                  child: Text(
                    _homeViewController.orders[index],
                    style: TextStyle(
                      color: index == _homeViewController.selectedIndex.value
                          ? Colors.white
                          : Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        width: size.width,
        height: size.height / 3.5,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.darken),
            image: AssetImage('lib/res/images/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Text(
              'What would you like \n to Find',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
              width: double.infinity,
              height: 50,
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 228, 228, 228),
                  contentPadding: EdgeInsets.only(top: 5),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: Color.fromARGB(255, 146, 146, 146),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 131, 131, 131),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

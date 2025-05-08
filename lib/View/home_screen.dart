import 'package:rigz/Model/CategoryModel.dart';
import 'package:rigz/View/cart_screen.dart';
import 'package:rigz/View/search_screen.dart';
import 'package:rigz/View/widget/category_Widget.dart';
import 'package:flutter/material.dart';
import 'package:rigz/View/widget/productShowcase_Slider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:rigz/ViewModel/home_ViewModel.dart';
import 'package:rigz/bloc/Cart/bloc.dart';
import 'package:rigz/bloc/Cart/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class homeScreen extends StatelessWidget {
  final homeController = HomeViewmodel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height / 5,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 10),
                title: Row(
                  children: [
                    const Text("Rigz"),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => searchScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.search),
                    ),
                    //TODO: create new bloc state to choose the pc parts and put as whole in cart
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.desktop_windows_rounded),
                    // ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => cartScreen()),
                        );
                      },
                      icon: BlocSelector<productBloc, productsState, int>(
                        selector: (state) => state.products.length,
                        builder: (context, int length) {
                          print(length);
                          return badges.Badge(
                            badgeContent: Text(length.toString()),
                            badgeAnimation: const badges.BadgeAnimation.scale(),
                            child: const Icon(Icons.shopping_bag_outlined),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: homeController.categories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error while Feathing the Data"),
                    );
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Center();
                  }
                  List<CategoryModel> snapData = snapshot.data!;

                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapData.length,
                      itemBuilder:
                          (context, index) =>
                              category_Widget(category: snapData[index]),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: productShowcase_Slider(
                title: "Special Offers",
                products: homeController.special_Offers(),
              ),
            ),
            SliverToBoxAdapter(
              child: productShowcase_Slider(
                title: "Almost Gone",
                products: homeController.almost_Gone(),
              ),
            ),
            SliverToBoxAdapter(
              child: productShowcase_Slider(
                title: "New Arrive",
                products: homeController.new_Arrive(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

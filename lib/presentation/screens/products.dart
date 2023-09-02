import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/presentation/models/product_model.dart';
import 'package:store_app/shared/components/form.dart';
import 'package:store_app/shared/constants/colors.dart';

import '../../business_logic/cubit/shop/shop_cubit.dart';
import '../../business_logic/cubit/shop/shop_states.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({super.key});
  final TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  // Header
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Welcome, ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  'Emile',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            Text(
                              'in',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              'SOFTAGI',
                              style: TextStyle(
                                  fontSize: 38.0,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.buttonColor),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: AppColors.iconColor,
                                  ),
                                ),
                                Positioned(
                                  top: -0.5,
                                  left: 22,
                                  child: CircleAvatar(
                                      backgroundColor: AppColors.errorColor,
                                      radius: 6,
                                      child: Text(
                                        '2',
                                        style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/profile.jpg'),
                              radius: 30,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  defaultFormField(
                      controller: search,
                      type: TextInputType.text,
                      label: 'Search',
                      formColor: Colors.white,
                      prefix: Icons.search,
                      suffix: Icons.clear,
                      suffixColor: AppColors.iconColor,
                      suffixPressed: () {}),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ConditionalBuilder(
                      condition: ShopCubit.get(context).homeModel != null,
                      builder: (context) => productsModelBuilder(
                          ShopCubit.get(context).homeModel),
                      fallback: (BuildContext context) =>
                          const Center(child: CircularProgressIndicator()))
                ],
              ),
            )),
          ),
        );
      },
    );
  }

  Widget productsModelBuilder(HomeModel? model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
              items: model!.data!.banners
                  .map((e) => Image(
                        image: NetworkImage(e.image),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
              options: CarouselOptions(
                  height: 200.0,
                  initialPage: 0,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal)),
          const SizedBox(
            height: 20,
          ),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            childAspectRatio: 1 / 1.6,
            children: List.generate(model.data!.products.length,
                (index) => buildGridProducts(model.data!.products[index])),
          )
        ],
      );
}

Widget buildGridProducts(ProductModel model) => InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 18),
                    child: Image(
                      image: NetworkImage(model.image),
                      width: 170,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 0,
                    child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.buttonColor),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.favorite_border_outlined,
                            color: AppColors.iconColor,
                          ),
                          onPressed: () {},
                        ))),
                if (model.discount != 0)
                  Positioned(
                      child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: BorderRadius.circular(29)),
                    child: const Text(
                      'Discount',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '${model.name}',
                style: const TextStyle(
                  color: AppColors.fontColor,
                  fontSize: 14,
                  height: 1.2,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EG ${model.oldPrice.round()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                      if (model.discount != 0)
                        Text('EG ${model.price.round()}',
                            style: const TextStyle(
                                fontSize: 14, color: AppColors.bluredColor)),
                    ],
                  ),
                ),
                if (model.discount != 0)
                  Positioned(
                      top: 8,
                      left: 90,
                      child: RotationTransition(
                        turns: const AlwaysStoppedAnimation(-15 / 180),
                        child: Container(
                          decoration:
                              const BoxDecoration(color: AppColors.errorColor),
                          width: 45,
                          height: 1.5,
                        ),
                      ))
              ],
            )
          ],
        ),
      ),
    );

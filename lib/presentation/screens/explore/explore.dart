import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/home/shop_states.dart';
import 'package:store_app/presentation/models/categories_model.dart';
import 'package:store_app/presentation/models/favorites_model.dart';
import 'package:store_app/presentation/screens/explore/category_details.dart';
import 'package:store_app/presentation/screens/home/product_details.dart';
import 'package:store_app/shared/components/button.dart';
import 'package:store_app/shared/components/navigate.dart';
import 'package:store_app/shared/components/progress_indicator.dart';
import 'package:store_app/shared/constants/colors.dart';

class FavouritsScreen extends StatefulWidget {
  const FavouritsScreen({super.key});

  @override
  State<FavouritsScreen> createState() => _FavouritsScreenState();
}

class _FavouritsScreenState extends State<FavouritsScreen> {
  bool? inFav;
  @override
  void initState() {
    inFav = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopStates>(
      builder: (context, state) {
        //  ShopCubit.get(context).getCategoriesData();
        print(ShopCubit.get(context).categoriesModel);
        //  print(ShopCubit.get(context).userModel!.data!.token);
        return Scaffold(
          appBar: AppBar(
            title: Text('Softagi'.toUpperCase()),
            centerTitle: true,
            titleTextStyle: const TextStyle(
                color: AppColors.containerColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Poppins'),
            elevation: 0,
            backgroundColor: AppColors.buttonColor,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        defaultButton(
                          width: 150,
                          height: 36,
                          onPressed: () {
                            setState(() {
                              inFav = false;
                            });
                          },
                          isUpperCase: false,
                          text: 'Categories',
                          fontSize: 15,
                          color: inFav == false
                              ? AppColors.buttonColor
                              : AppColors.containerColor,
                          textColor: inFav == false
                              ? AppColors.containerColor
                              : AppColors.fontColor,
                        ),
                        defaultButton(
                          width: 150,
                          height: 36,
                          onPressed: () {
                            setState(() {
                              inFav = true;
                            });
                          },
                          isUpperCase: false,
                          text: 'Favorites',
                          fontSize: 15,
                          color: inFav == true
                              ? AppColors.buttonColor
                              : AppColors.containerColor,
                          textColor: inFav == true
                              ? AppColors.containerColor
                              : AppColors.fontColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: ConditionalBuilder(
                        condition:
                            ShopCubit.get(context).favoritesModel != null &&
                                ShopCubit.get(context).categoriesModel != null,
                        builder: (context) => ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => inFav == true
                                ? buildFavoritesModel(ShopCubit.get(context)
                                    .favoritesModel!
                                    .data!
                                    .data![index])
                                : buildCategoryModel(
                                    ShopCubit.get(context)
                                        .categoriesModel!
                                        .data!
                                        .data[index],
                                    index),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10.0,
                                ),
                            itemCount: inFav == true
                                ? ShopCubit.get(context)
                                    .favoritesModel!
                                    .data!
                                    .data!
                                    .length
                                : ShopCubit.get(context)
                                    .categoriesModel!
                                    .data!
                                    .data
                                    .length),
                        fallback: (BuildContext context) =>
                            defaultCircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFavoritesModel(FavoritesData model) => InkWell(
        onTap: () {
          navigateTo(context, ProductDetailsScreen(product_id: model.id));
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              boxShadow: [
                const BoxShadow(color: AppColors.bluredColor, blurRadius: 5)
              ],
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: AppColors.buttonOpacityColor, width: 0.3),
              color: AppColors.containerColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: CachedNetworkImage(
                      imageUrl: model.product!.image,
                      placeholder: (context, url) =>
                          defaultCircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (model.product!.discount != 0)
                    Container(
                      width: 70,
                      decoration: BoxDecoration(
                          color: AppColors.errorColor,
                          borderRadius: BorderRadius.circular(29)),
                      child: const Text(
                        'Discount',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.containerColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // navigateTo(context,
                        //     ProductDetailsScreen(product_id: model.id));
                      },
                      child: Text(
                        '${model.product!.name}',
                        style: const TextStyle(
                          color: AppColors.fontColor,
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'EG ${model.product!.oldPrice}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              if (model.product!.discount != 0)
                                Stack(
                                  children: [
                                    Text('EG ${model.product!.price.round()}',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.bluredColor)),
                                    Positioned(
                                        top: 5,
                                        left: 10,
                                        child: RotationTransition(
                                          turns: const AlwaysStoppedAnimation(
                                              -10 / 180),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: AppColors.errorColor),
                                            width: 60,
                                            height: 1.7,
                                          ),
                                        )),
                                  ],
                                ),
                              CircleAvatar(
                                backgroundColor: AppColors.containerColor,
                                child: IconButton(
                                  iconSize: 24,
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    ShopCubit.get(context)
                                                .favorites[model.product!.id] ==
                                            true
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color: ShopCubit.get(context)
                                                .favorites[model.product!.id] ==
                                            true
                                        ? AppColors.errorColor
                                        : AppColors.iconColor,
                                  ),
                                  onPressed: () {
                                    ShopCubit.get(context)
                                        .changeFavorits(model.product!.id);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildCategoryModel(DataModel model, int index) => Container(
        width: double.infinity,
        height: 120,
        decoration: const BoxDecoration(color: AppColors.containerColor),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CachedNetworkImage(
              imageUrl: model.image,
              height: 120.0,
              width: 120.0,
              fit: BoxFit.cover,
              placeholder: (context, url) => defaultCircularProgressIndicator(),
              errorWidget: (context, url, error) {
                print('error in cat image : ');
                return const Icon(Icons.error);
              },
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Text(
                '${model.name}'.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.fontColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  ShopCubit.get(context).getCategoriesDetailsData(
                      ShopCubit.get(context)
                          .categoriesModel!
                          .data!
                          .data[index]
                          .id!);
                  navigateTo(
                    context,
                    CategoryDetailsScreen(
                      index: index,
                     id: ShopCubit.get(context)
                          .categoriesModel!
                          .data!
                          .data[index]
                          .id!
                    ),
                  );
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.iconColor,
                ))
          ]),
        ),
      );
}

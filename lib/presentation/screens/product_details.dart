import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_app/business_logic/cubit/products/products_cubit.dart';
import 'package:store_app/business_logic/cubit/products/products_state.dart';
import 'package:store_app/business_logic/cubit/shop/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/shop/shop_states.dart';
import 'package:store_app/presentation/models/product_details_model.dart';
import 'package:store_app/shared/components/button.dart';
import 'package:store_app/shared/components/navigate.dart';

import '../../shared/constants/colors.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int index;

  ProductDetailsScreen({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  CarouselController carouselController = CarouselController();
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    ProductDetailsModel? productModel =
        ProductCubit.get(context).productDetailsModel;
    Widget additionalImage = Image(
      image: NetworkImage(productModel!.data!.data[widget.index].image),
      width: 300,
      height: 300,
      fit: BoxFit.contain,
    );
    List<Widget> existingImages = productModel.data!.data[widget.index].images
        .map((e) => Image(
              image: NetworkImage(e),
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ))
        .toList();
    setState(() {
      if (productModel.data!.data[widget.index].images.length == 1) {
        existingImages.insert(0, additionalImage);
      }
    });
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return BlocConsumer<ProductCubit, ProductStates>(
          listener: (context, state) {
            print(widget.index);
          },
          builder: (context, state) {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: AppColors.containerColor,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: IconButton(
                        onPressed: () {
                          navigateBack(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.fontColor,
                        )),
                  ),
                  actions: [
                    IconButton(
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        ShopCubit.get(context).favorites[
                                    productModel.data!.data[widget.index].id] ==
                                true
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: ShopCubit.get(context).favorites[
                                    productModel.data!.data[widget.index].id] ==
                                true
                            ? AppColors.errorColor
                            : AppColors.iconColor,
                      ),
                      onPressed: () {
                        ShopCubit.get(context).changeFavorits(
                            productModel.data!.data[widget.index].id);
                      },
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: AppColors.fontColor,
                        )),
                  ],
                ),
                backgroundColor: AppColors.backgroundColor,
                body: ConditionalBuilder(
                  condition:
                      ProductCubit.get(context).productDetailsModel != null,
                  builder: (context) => SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 300,
                          decoration: const BoxDecoration(
                              color: AppColors.containerColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(29),
                                  bottomRight: Radius.circular(29))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Column(
                                    children: [
                                      Column(
                                        children: [
                                          CarouselSlider(
                                              carouselController:
                                                  carouselController,
                                              items: existingImages,
                                              options: CarouselOptions(
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      activeIndex = index;
                                                      carouselController
                                                          .jumpToPage(index);
                                                    });
                                                  },
                                                  height: 200.0,
                                                  initialPage: 0,
                                                  viewportFraction: 1.0,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  enableInfiniteScroll: false)),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          AnimatedSmoothIndicator(
                                              onDotClicked: (index) =>
                                                  carouselController
                                                      .jumpToPage(index),
                                              effect: const ExpandingDotsEffect(
                                                  activeDotColor:
                                                      AppColors.buttonColor,
                                                  dotColor: AppColors.elevColor,
                                                  dotWidth: 15,
                                                  dotHeight: 8,
                                                  spacing: 5,
                                                  expansionFactor: 2),
                                              activeIndex: activeIndex,
                                              count: existingImages.length),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                  if (productModel
                                          .data!.data[widget.index].discount !=
                                      0)
                                    Container(
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: AppColors.errorColor,
                                          borderRadius:
                                              BorderRadius.circular(29)),
                                      child: const Text(
                                        'Discount',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.containerColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productModel.data!.data[widget.index].name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Description:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                productModel
                                    .data!.data[widget.index].description,
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(
                                height: 100.0,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  fallback: (BuildContext context) =>
                      const Center(child: CircularProgressIndicator()),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endContained,
                floatingActionButton: Container(
                    height: 80,
                    padding: EdgeInsets.zero,
                    color: AppColors.backgroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 45.0, right: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${productModel.data!.data[widget.index].oldPrice}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (productModel
                                          .data!.data[widget.index].discount !=
                                      0)
                                    Text(
                                      '${productModel.data!.data[widget.index].price}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: defaultButton(
                              onPressed: () {},
                              text: 'Add To Cart',
                              textColor: AppColors.containerColor,
                              isUpperCase: false),
                        )
                      ],
                    )),
              ),
            );
          },
        );
      },
    );
  }
}

// Row(
                              
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Price:',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                         '${productModel.data!.data[widget.index].oldPrice}',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                   defaultButton(
//                                       onPressed: () {},
//                                       text: '',
//                                       width: 250,
//                                       height: 60)
//                                 ]),
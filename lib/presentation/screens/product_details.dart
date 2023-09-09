import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/products/products_cubit.dart';
import 'package:store_app/business_logic/cubit/products/products_state.dart';
import 'package:store_app/shared/components/navigate.dart';

import '../../shared/constants/colors.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int index;
  dynamic id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String image = '';
  String? name;
  bool? inFavorites;
  bool? inCart;
  ProductDetailsScreen({
    Key? key,
    required this.index,
    required this.id,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.image,
    this.name,
    this.inFavorites,
    this.inCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductStates>(
      listener: (context, state) {
        print(index);
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.fontColor,
              ),
              onPressed: () {
                navigateBack(context);
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: AppColors.fontColor,
                  ))
            ],
          ),
          backgroundColor: AppColors.backgroundColor,
          body: ConditionalBuilder(
            condition: state is! ProductLoadingDataState,
            builder: (context) => SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Image(
                      image: NetworkImage(image),
                      width: 200,
                      height: 200,
                    )
                  ],
                ),
              ),
            ),
            fallback: (BuildContext context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

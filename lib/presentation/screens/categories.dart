import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/shop/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/shop/shop_states.dart';
import 'package:store_app/presentation/models/categories_model.dart';
import 'package:store_app/shared/constants/colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Softagi'.toUpperCase()),
            //centerTitle: true,
            titleTextStyle: TextStyle(
                color: AppColors.containerColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Poppins'),
            elevation: 0,
            backgroundColor: AppColors.buttonColor,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: AppColors.iconColor,
                  weight: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
          backgroundColor: AppColors.backgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10, left: 25),
                  //   child: Text(
                  //     'Categories',
                  //     style: TextStyle(
                  //         fontSize: 28.0,
                  //         fontWeight: FontWeight.w900,
                  //         color: AppColors.fontColor),
                  //   ),
                  // ),
                  SizedBox(
                      child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => buildCategoryModel(
                              ShopCubit.get(context)
                                  .categoriesModel!
                                  .data!
                                  .data[index]),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20.0),
                          itemCount: ShopCubit.get(context)
                              .categoriesModel!
                              .data!
                              .data
                              .length))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCategoryModel(DataModel model) => Container(
        width: double.infinity,
        height: 150,
        decoration: const BoxDecoration(color: AppColors.containerColor),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Image(
              image: NetworkImage(model.image),
              height: 150.0,
              width: 150.0,
              fit: BoxFit.cover,
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
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.iconColor,
                ))
          ]),
        ),
      );
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/presentation/models/categories_model.dart';
import 'package:store_app/presentation/models/product_model.dart';
import 'package:store_app/presentation/screens/product_details.dart';
import 'package:store_app/shared/components/form.dart';
import 'package:store_app/shared/components/navigate.dart';
import 'package:store_app/shared/components/remove_background.dart';
import 'package:store_app/shared/components/toast.dart';
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
        if (state is ShopSuccessChangeFavoritsDataState) {
          if (state.model!.status == false) {
            defaultToast(
                message: state.model!.message, state: ToastState.ERROR);
          }
        }
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
                      condition: ShopCubit.get(context).homeModel != null &&
                          ShopCubit.get(context).categoriesModel != null,
                      builder: (context) => productsModelBuilder(
                          ShopCubit.get(context).homeModel,
                          ShopCubit.get(context).categoriesModel,
                          context),
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

  Widget productsModelBuilder(HomeModel? homeModel,
          CategoriesModel? categoriesModel, BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
              items: homeModel!.data!.banners
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  height: 100.0,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => buildCategoriesModel(
                          categoriesModel.data!.data[index]),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10.0),
                      itemCount: categoriesModel!.data!.data.length),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'New Products',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            childAspectRatio: 1 / 1.6,
            children: List.generate(
                homeModel.data!.products.length,
                (index) => buildGridProducts(
                    homeModel.data!.products[index], context, index)),
          )
        ],
      );
}

Widget buildCategoriesModel(DataModel dataModel) => Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Image(
            image: NetworkImage(
              dataModel.image,
            ),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(color: AppColors.buttonOpacityColor),
          child: Center(
            child: Text(
              dataModel.name.toUpperCase(),
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ))
      ],
    );

Widget buildGridProducts(ProductModel model, BuildContext context, index) {
  //RemoveBackgroud.removeBackground(model.image);
  return InkWell(
    onTap: () {
      print(index);
      navigateTo(
          context,
          ProductDetailsScreen(
            index: index,
            id: model.id,
            price: model.price,
            oldPrice: model.oldPrice,
            discount: model.discount,
            image: model.image,
            name: model.name,
            inCart: model.inCart,
            inFavorites: model.inFavorites,
          ));
    },
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
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
                  right: 5,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor:
                        ShopCubit.get(context).favorits[model.id] == true
                            ? AppColors.buttonColor
                            : AppColors.elevColor,
                    child: IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        ShopCubit.get(context).favorits[model.id] == true
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        ShopCubit.get(context).changeFavorits(model.id);
                      },
                    ),
                  )),
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
                fontWeight: FontWeight.w500,
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
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    if (model.discount != 0)
                      Stack(
                        children: [
                          Text('EG ${model.price.round()}',
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.bluredColor)),
                          Positioned(
                              top: 5,
                              left: 10,
                              child: RotationTransition(
                                turns: const AlwaysStoppedAnimation(-10 / 180),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: AppColors.errorColor),
                                  width: 60,
                                  height: 1.7,
                                ),
                              )),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

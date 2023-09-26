import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/presentation/models/categories_model.dart';
import 'package:store_app/presentation/models/product_model.dart';
import 'package:store_app/presentation/screens/home/carts.dart';
import 'package:store_app/presentation/screens/profile/edit_profile.dart';
import 'package:store_app/presentation/screens/home/product_details.dart';
import 'package:store_app/presentation/screens/home/search.dart';
import 'package:store_app/shared/components/button.dart';
import 'package:store_app/shared/components/form.dart';
import 'package:store_app/shared/components/navigate.dart';
import 'package:store_app/shared/components/progress_indicator.dart';
import 'package:store_app/shared/components/toast.dart';
import 'package:store_app/shared/constants/colors.dart';
import 'package:store_app/shared/constants/strings.dart';

import '../../../business_logic/cubit/home/shop_states.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController search = TextEditingController();
  String image = '';
  bool isCategoryPressed = false;
  int categoryIndex = 0;
  @override

  // void changeImage(String imagePath) async{
  //   image = await RemoveBackgroud.removeBg(imagePath);
  //     ShopCubit.get(context).state;
  // }
  @override
  // void initState() {
  //   super.initState();

  //   // Use the user's email address to construct the Firebase Storage reference
  //   final String userEmail = emailAddress!;
  //   final String fileName = 'profile_image.jpg';
  //   if(userEmail!=null){

  //   final Reference storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('user_images/$userEmail/$fileName');

  //   // Download the image
  //   storageReference.getDownloadURL().then((url) {
  //     setState(() {
  //       imageUrl = url;
  //     });
  //   }).catchError((error) {
  //     print('Error downloading image: $error');
  //   });
  //   // Trigger the image upload when the screen is first loaded
  //   //uploadImage();
  //   }
  // }
  String? imageUrl;
  void getImage() {
    final String userEmail = emailAddress!;
    final String fileName = 'profile_image.jpg';
    if (userEmail != null) {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_images/$userEmail/$fileName');

      // Download the image
      storageReference.getDownloadURL().then((url) {
        setState(() {
          imageUrl = url;
        });
      }).catchError((error) {
        print('Error downloading image: $error');
      });
      // Trigger the image upload when the screen is first loaded
      //uploadImage();
    }
  }

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
        //print(imageUrl);
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ConditionalBuilder(
                  fallback: (context) => defaultCircularProgressIndicator(),
                  condition: ShopCubit.get(context).userModel != null &&
                      ShopCubit.get(context).cartModel != null &&
                      //  imageUrl != null &&
                      emailAddress != null &&
                      ShopCubit.get(context).homeModel != null,
                  builder: (context) {
                    return Column(
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Welcome, ',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Text(
                                        ShopCubit.get(context)
                                            .userModel!
                                            .data!
                                            .name
                                            .split(' ')[0],
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    ' in',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  const Text(
                                    'SOFTAGI',
                                    style: TextStyle(
                                        fontSize: 38.0,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.buttonColor),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          navigateTo(
                                              context, const CartScreen());
                                        },
                                        child: CircleAvatar(
                                          backgroundColor:
                                              AppColors.containerColor,
                                          radius: 25,
                                          child: IconButton(
                                            onPressed: () {
                                              print('icon presses');
                                              navigateTo(
                                                  context, const CartScreen());
                                            },
                                            icon: const Icon(
                                              Icons.shopping_cart,
                                              color: AppColors.iconColor,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -0.1,
                                        left: 22,
                                        child: CircleAvatar(
                                            backgroundColor:
                                                AppColors.errorColor,
                                            radius: 6,
                                            child: Text(
                                              ShopCubit.get(context)
                                                          .cartModel! !=
                                                      null
                                                  ? '${ShopCubit.get(context).cartModel!.cartData!.cartItemData.length}'
                                                  : '0',
                                              style: const TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.containerColor),
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  if (ShopCubit.get(context)
                                          .userModel!
                                          .data!
                                          .image !=
                                      null)
                                    InkWell(
                                      onTap: () {
                                        navigateTo(
                                            context, EditProfileScreen());
                                      },
                                      child: CircleAvatar(
                                        radius: 30,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            width: 230,
                                            height: 230,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                defaultCircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            imageUrl: ShopCubit.get(context)
                                                .userModel!
                                                .data!
                                                .image!,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (() {
                            showSearch(context: context, delegate: MySearch());
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.containerColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showSearch(
                                          context: context,
                                          delegate: MySearch());
                                    },
                                    icon: const Icon(Icons.search)),
                                const Text(
                                  'Search Product',
                                  style: TextStyle(
                                      color: AppColors.fontColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.close)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ConditionalBuilder(
                            condition: ShopCubit.get(context).homeModel !=
                                    null &&
                                ShopCubit.get(context).categoriesModel != null,
                            builder: (context) => productsModelBuilder(
                                ShopCubit.get(context).homeModel,
                                //ShopCubit.get(context).productDetailsModel,
                                ShopCubit.get(context).categoriesModel,
                                context),
                            fallback: (BuildContext context) =>
                                defaultCircularProgressIndicator())
                      ],
                    );
                  }),
            )),
          ),
        );
      },
    );
  }

  Widget productsModelBuilder(
          HomeModel? homeModel,
          //ProductDetailsModel? productDetailsModel,
          CategoriesModel? categoriesModel,
          BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
              items: homeModel!.data!.banners
                  .map((e) => CachedNetworkImage(
                        imageUrl: e.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            defaultCircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
            padding: const EdgeInsets.only(left: 3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.0,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          buildCategoryItem(context, index),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10.0),
                      itemCount: categoriesModel!.data!.data.length + 1),
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
                ShopCubit.get(context).categoryIndex == 0
                    ? homeModel.data!.products.length
                    : ShopCubit.get(context)
                        .categories[ShopCubit.get(context).categoryIndex - 1]
                        .length, (index) {
              //changeImage(productDetailsModel!.data!.data[index].image);
              return buildGridProducts(
                  ShopCubit.get(context).categoryIndex == 0
                      ? homeModel.data!.products[index]
                      : ShopCubit.get(context).categories[
                          ShopCubit.get(context).categoryIndex - 1][index],
                  context,
                  index);
            }),
          )
        ],
      );

  Widget buildCategoryItem(BuildContext context, int index) {
    Color buttonColor = ShopCubit.get(context).categoryIndex == index
        ? AppColors.containerColor
        : ShopCubit.get(context).categoryColor;
    return SizedBox(
      width: 120,
      height: 30,
      child: defaultButton(
          color: buttonColor,
          onPressed: () {
            ShopCubit.get(context).categoryPressed(index);
          },
          text: ShopCubit.get(context).getCategoryName(index),
          fontSize: 14,
          height: 30,
          isUpperCase: false,
          textColor: AppColors.fontColor),
    );
  }

  Widget buildGridProducts(ProductModel model, BuildContext context, index) {
    // String img =
    //     'https://student.valuxapps.com/storage/uploads/products/1615440689Oojt6.item_XXL_36330138_142814947.jpeg';
    // ShopCubit.get(context).removeBackgroud(img);
    return InkWell(
      onTap: () {
        //print(model.id);
        navigateTo(
            context,
            ProductDetailsScreen(
              product_id: model.id,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.containerColor),
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
                    child: CachedNetworkImage(
                      imageUrl: model.image,
                      placeholder: (context, url) =>
                          defaultCircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: 170,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: AppColors.containerColor,
                    child: IconButton(
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        ShopCubit.get(context).favorites[model.id] == true
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color:
                            ShopCubit.get(context).favorites[model.id] == true
                                ? AppColors.errorColor
                                : AppColors.iconColor,
                      ),
                      onPressed: () {
                        ShopCubit.get(context).changeFavorits(model.id);
                      },
                    ),
                  ),
                ),
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
                          color: AppColors.containerColor),
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
                  fontWeight: FontWeight.bold,
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
                                    fontSize: 13,
                                    color: AppColors.bluredColor)),
                            Positioned(
                                top: 5,
                                left: 10,
                                child: RotationTransition(
                                  turns:
                                      const AlwaysStoppedAnimation(-10 / 180),
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
}
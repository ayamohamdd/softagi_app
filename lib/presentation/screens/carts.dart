import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/home/shop_states.dart';
import 'package:store_app/presentation/layout/layout.dart';
import 'package:store_app/presentation/models/cart_model.dart';
import 'package:store_app/presentation/screens/product_details.dart';
import 'package:store_app/shared/components/button.dart';
import 'package:store_app/shared/components/navigate.dart';
import 'package:store_app/shared/components/progress_indicator.dart';
import 'package:store_app/shared/constants/colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        // print(ShopCubit.get(context)
        //     .cartModel!
        //     .cartData!
        //     .cartItemData[0]
        //     .productData);
        CartData? cartData = ShopCubit.get(context).cartModel!.cartData!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
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
          body: ShopCubit.get(context).cartModel!.cartData!.cartItemData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      Lottie.asset('assets/lotties/animation_lmw2bfz4.json',
                          width: double.infinity, height: 200),
                      const Text(
                        'Hey, your cart is empty!',
                        style: TextStyle(
                            color: AppColors.fontColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        'Go on, stock up and order your faves',
                        style: TextStyle(
                            color: AppColors.fontColorBlured,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultButton(
                          onPressed: () {
                            navigateAndFinish(context, const LayoutScreen());
                          },
                          text: 'Add Items',
                          textColor: AppColors.containerColor,
                          width: 110,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          isUpperCase: false,
                          height: 35)
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 320,
                        child: ConditionalBuilder(
                          condition: ShopCubit.get(context).cartModel != null,
                          builder: (context) {
                            print(ShopCubit.get(context)
                                .cartModel!
                                .cartData!
                                .cartItemData
                                .isEmpty);

                            return ConditionalBuilder(
                                condition:
                                    state is !ShopSuccessChangeCartDataState,
                                fallback: (context) => defaultCircularProgressIndicator(),
                              builder:(context)=> ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                // physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                  buildCartModel(context,
                                      cartData.cartItemData[index], index),
                              
                            
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 10.0,
                                ),
                                itemCount: cartData.cartItemData.length,
                              ),
                            );
                          },
                          fallback: (BuildContext context) => defaultCircularProgressIndicator()
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopLoadingUpdateCartDataState,
                        fallback: (context) =>  defaultLinearProgressIndicator(),
                        builder: (context) => Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                              color: AppColors.containerColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Sub Total: ',
                                      style: TextStyle(
                                          color: AppColors.fontColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('EG ${cartData.subTotal}',
                                        style: const TextStyle(
                                          color: AppColors.bluredColor,
                                          fontSize: 18,
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 0.5,
                                  decoration: const BoxDecoration(
                                      color: AppColors.elevColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tax: ',
                                      style: TextStyle(
                                          color: AppColors.fontColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('EG 0.00',
                                        style: TextStyle(
                                          color: AppColors.bluredColor,
                                          fontSize: 18,
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 0.5,
                                  decoration: const BoxDecoration(
                                      color: AppColors.elevColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total: ',
                                      style: TextStyle(
                                          color: AppColors.fontColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('EG ${cartData.total}',
                                        style: const TextStyle(
                                          color: AppColors.bluredColor,
                                          fontSize: 18,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
          floatingActionButton: cartData.cartItemData.isEmpty
              ? null
              : defaultButton(
                  onPressed: () {},
                  text: 'CheckOut',
                  textColor: AppColors.containerColor,
                  width: 300),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget buildCartModel(BuildContext context, CartItemData model, int index) =>
      Container(
        height: 180,
        width: 220,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.buttonOpacityColor, width: 0.3),
            color: AppColors.containerColor),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      ShopCubit.get(context).changeCart(model.productData!.id!);
                    },
                    icon: const Icon(Icons.close))),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Image(
                        image: NetworkImage(model.productData!.image),
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (model.productData!.discount != 0)
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 100,
                      child: TextButton(
                        onPressed: () {
                          // navigateTo(context,
                          //     ProductDetailsScreen(product_id: model.id));
                        },
                        child: Text(
                          '${model.productData!.name}',
                          style: const TextStyle(
                            color: AppColors.fontColor,
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Text(
                      model.productData!.discount != 0
                          ? 'EG ${model.productData!.price}'
                          : 'EG ${model.productData!.oldPrice}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.fontColor, width: 0.05),
                          color: AppColors.containerColor),
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 30,
                              height: 30,
                              color: AppColors.elevColor,
                              child: IconButton(
                                icon: const Icon(Icons.remove,
                                    size: 15, color: AppColors.fontColor),
                                onPressed: (() {
                                  model.quantity == 1
                                      ? ShopCubit.get(context)
                                          .changeCart(model.productData!.id!)
                                      : ShopCubit.get(context).updateCart(
                                          quantity: --model.quantity,
                                          id: model.id!);
                                }),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('${model.quantity}'),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              width: 30,
                              height: 30,
                              color: AppColors.elevColor,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  size: 15,
                                  color: AppColors.fontColor,
                                ),
                                onPressed: (() {
                                  ShopCubit.get(context).updateCart(
                                      quantity: ++model.quantity,
                                      id: model.id!);
                                }),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      );
}

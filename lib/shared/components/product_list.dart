import 'package:flutter/material.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/presentation/models/search_model.dart';
import 'package:store_app/presentation/screens/home/product_details.dart';
import 'package:store_app/shared/components/navigate.dart';
import 'package:store_app/shared/constants/colors.dart';

Widget buildProductModel(model, context) => InkWell(
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
            border: Border.all(color: AppColors.buttonOpacityColor, width: 0.3),
            color: AppColors.containerColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Image(
                    image: NetworkImage(model.image),
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                if (model.discount != 0)
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
                      '${model.name}',
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
                            // Text(
                            //   'EG ${model.oldPrice}',
                            //   style: const TextStyle(
                            //       fontWeight: FontWeight.bold, fontSize: 15),
                            // ),
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
                                  ShopCubit.get(context).favorites[model.id] ==
                                          true
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: ShopCubit.get(context)
                                              .favorites[model.id] ==
                                          true
                                      ? AppColors.errorColor
                                      : AppColors.iconColor,
                                ),
                                onPressed: () {
                                  ShopCubit.get(context)
                                      .changeFavorits(model.id);
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

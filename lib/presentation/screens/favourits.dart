import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/shop/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/shop/shop_states.dart';
import 'package:store_app/presentation/models/favorites_model.dart';
import 'package:store_app/shared/constants/colors.dart';

class FavouritsScreen extends StatelessWidget {
  const FavouritsScreen({super.key});

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
            centerTitle: true,
            titleTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Poppins'),
            elevation: 0,
            backgroundColor: AppColors.buttonColor,
            actions: [
              IconButton(
                icon:const Icon(Icons.search,color: AppColors.iconColor,weight: 20,),onPressed: (){},),
            ],
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
                itemBuilder: (context,index)=>buildFavoritesModel(
                  ShopCubit.get(context).favoritesModel!.data!.data![index]
                ),
                separatorBuilder: (context,index)=>SizedBox(height: 10.0,),
                itemCount: ShopCubit.get(context).favoritesModel!.data!.data!.length),
          ),
        );
      },
    );
  }

  Widget buildFavoritesModel(FavoritesData model) => InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29), color: Colors.white),
          child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Image(
                        image: NetworkImage(model.product!.image),
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
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
                    color: Colors.white),
                textAlign: TextAlign.center,
                  ),
                ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
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
                      padding: const EdgeInsets.only(left: 10.0,right: 15,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'EG ${model.product!.oldPrice.round()}',
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
                        CircleAvatar(
                          radius: 12,
                          backgroundColor:
                               AppColors.buttonColor,
                          child: IconButton(
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                            icon: Icon(
                               Icons.favorite,
                              color: Colors.white,
                            ),
                            onPressed: () {
                            },
                          ),
                        )
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
}

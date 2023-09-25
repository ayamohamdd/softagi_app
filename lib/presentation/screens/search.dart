import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/home/shop_states.dart';
import 'package:store_app/presentation/models/search_model.dart';
import 'package:store_app/presentation/screens/product_details.dart';
import 'package:store_app/shared/components/navigate.dart';
import 'package:store_app/shared/components/product_list.dart';
import 'package:store_app/shared/components/progress_indicator.dart';
import 'package:store_app/shared/constants/colors.dart';

class MySearch extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
      appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
        elevation: 0.0,
      ),
    );
  }
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            }),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null), //close searchbar
        icon: const Icon(
          Icons.arrow_back,
        ),
      );

  @override
  Widget buildResults(BuildContext context) {
     if (query.isNotEmpty) {
      ShopCubit.get(context).getSearchData(query);
      return BlocBuilder<ShopCubit, ShopStates>(builder: (context, state) {
        return ConditionalBuilder(
            condition: state is! ShopLoadingGetSearchDataState,
            // ||ShopCubit.get(context).searchModel!=null,
            builder: (context) {
              return ShopCubit.get(context).searchModel!.data!.data!.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (context, index) => buildProductModel(
                          ShopCubit.get(context)
                              .searchModel!
                              .data!
                              .data![index],
                          context),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10.0,
                          ),
                      itemCount: ShopCubit.get(context)
                          .searchModel!
                          .data!
                          .data!
                          .length)
                  : const Center(
                      child: Text('Sorry, Product Is Not Found!'),
                    );
            },
            fallback: (context) => defaultCircularProgressIndicator());
      }, );
    } else {
      return const Center(child: Text('Please Enter Product To Search'));
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      ShopCubit.get(context).getSearchData(query);
      return BlocBuilder<ShopCubit, ShopStates>(builder: (context, state) {
        return ConditionalBuilder(
            condition: state is! ShopLoadingGetSearchDataState,
            // ||ShopCubit.get(context).searchModel!=null,
            builder: (context) {
              return ShopCubit.get(context).searchModel!.data!.data!.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (context, index) => buildProductModel(
                          ShopCubit.get(context)
                              .searchModel!
                              .data!
                              .data![index],
                          context),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10.0,
                          ),
                      itemCount: ShopCubit.get(context)
                          .searchModel!
                          .data!
                          .data!
                          .length)
                  : const Center(
                      child: Text('Sorry, Product Is Not Found!'),
                    );
            },
            fallback: (context) => defaultCircularProgressIndicator());
      });
    } else {
      return const Center(child: Text('Please Enter Product To Search'));
    }
  }
}

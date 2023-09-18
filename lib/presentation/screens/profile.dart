import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/home/shop_states.dart';
import 'package:store_app/presentation/models/login_model.dart';
import 'package:store_app/shared/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    ShopCubit.get(context).getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
       
        LoginModel? userModel = ShopCubit.get(context).userModel;
        return Scaffold(
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(child: Image(image: NetworkImage(userModel!.data!.image))),
              Text(userModel.data!.name),
            ],
          )),
        );
      },
    );
  }
}

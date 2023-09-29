import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/auth/login/login_cubit.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/data/local/cache_helper.dart';
import 'package:store_app/data/remote/dio_helper.dart';
import 'package:store_app/presentation/screens/splash.dart';
import 'package:store_app/shared/components/blocObserver.dart';
import 'package:store_app/shared/constants/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //DioHelper.init();
  await CacheHelper.init();
  Bloc.observer = const SimpleBlocObserver();
  //token = CacheHelper.sharedPreferences.getString('login')!;
  runApp(const StoreApp());
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit()..getHomeData()..getCartData()..getFavoritesData()..getUser()..getCategoriesData()..getCategoriesDetailsData(44),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

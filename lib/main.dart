import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/products/products_cubit.dart';
import 'package:store_app/business_logic/cubit/shop/shop_cubit.dart';
import 'package:store_app/data/local/cache_helper.dart';
import 'package:store_app/data/remote/dio_helper.dart';
import 'package:store_app/presentation/screens/splash.dart';
import 'package:store_app/shared/components/blocObserver.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  Bloc.observer = const SimpleBlocObserver();

  runApp(const StoreApp());
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => ShopCubit()..getHomeData()..getCategoriesData()..getFavoritesData()),
            BlocProvider(
            create: (BuildContext context) => ProductCubit()..getProductDetailsData()),
      ],
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

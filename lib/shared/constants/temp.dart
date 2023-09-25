// theme: ThemeData(
//         scaffoldBackgroundColor: AppColors.backgroundColor,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: AppColors.backgroundColor,
//           systemOverlayStyle: SystemUiOverlayStyle(
//             statusBarColor: AppColors.buttonColor,
//             statusBarIconBrightness: Brightness.light,
//           ),
//           elevation: 0.0,
//         ),
//         fontFamily: "Poppins",
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(
//             fontSize: 18.0,
//             color: AppColors.fontColor,
//           ),
//         ),
//       ),
//       // darkTheme: ThemeData(
//       //   scaffoldBackgroundColor: AppColors.backgroundColorDark,
//       //   fontFamily: "Poppins",
//       //   textTheme: const TextTheme(
//       //     bodyLarge: TextStyle(
//       //       fontSize: 18.0,
//       //       color: AppColors.fontColorDark,
//       //     ),
//       //   ),
//       // ),

// BottomNavigationBar(

//                 iconSize: 30,
//                 type: BottomNavigationBarType.fixed,
//                   backgroundColor: AppColors.buttonColor,
//                   //fixedColor: AppColors.backgroundColor,
//                   unselectedItemColor: AppColors.iconColor,
//                   selectedItemColor: Colors.white,
//                   showUnselectedLabels: false,
//                   currentIndex: cubit.currentIndex,
//                   onTap: (index) {
//                     cubit.changeBottom(index);
//                   },
//                   items: const [
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.home), label: 'Home'),
//                     BottomNavigationBarItem(
//                         icon: Icon(Icons.explore), label: 'Explore'),
//                     BottomNavigationBarItem(
//                         icon: Icon(Icons.favorite), label: 'Favourits'),
//                     BottomNavigationBarItem(
//                         icon: Icon(Icons.settings), label: 'Settings'),
//                   ]),

void printFullText(String text) {
  final Pattern = RegExp('.{1,800}');
  Pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final passValid =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}');
  final nameValid = RegExp(r'^[a-z A-Z]+$');
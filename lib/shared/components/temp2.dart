import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:store_app/shared/components/remove_background.dart';
import 'package:store_app/shared/constants/colors.dart';
import 'package:transparent_image/transparent_image.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
 Widget removeWhiteBackgroundImage(String imageUrl) {
  return Stack(
      children: [
        Center(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
}
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Container(
       decoration: BoxDecoration(image: DecorationImage(image: NetworkImage('https://student.valuxapps.com/storage/uploads/products/1615440322npwmU.71DVgBTdyLL._SL1500_.jpg'))),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailNavbar extends StatefulWidget {
  const DetailNavbar({super.key, required this.title, this.right = const SizedBox.shrink()});
  final String title;
  final Widget right;

  @override
  State<DetailNavbar> createState() => DetailNavbarState();
}

class DetailNavbarState extends State<DetailNavbar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 56 + MediaQuery.of(context).padding.top,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16),
        color: Color(0xFF070123),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
              )
            ),
            SizedBox(width: 8),
            Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            Spacer(),
            widget.right
          ],
        ),
      )
    );
  }
}
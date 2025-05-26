
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/wedget/detail_navbar.dart';

class InvitedPage extends StatefulWidget {
  const InvitedPage({super.key});

  @override
  State<InvitedPage> createState() => InvitedPageState();
}

class InvitedPageState extends State<InvitedPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xFF070123),
        child: Column(
          children: [
            DetailNavbar(title: 'Invited friends'),
            ContentBox()
          ],
        ),
      ),
    );
  }

  Widget ContentBox() {
    return Expanded(child: CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 140 + 10 * 108 + MediaQuery.of(context).padding.bottom + 16,
              padding: EdgeInsets.only(top: 16, left: 32),
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/bg/bg_invited.png'), alignment: Alignment.topCenter)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('You’ve shared:', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('10', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'Lexend', height: 1)),
                      Text('/times', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 96,
                    height: 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        foregroundColor: Color(0xFF070123),
                        backgroundColor: Color(0xFF01FFF7),
                        shadowColor: Colors.transparent,
                        overlayColor: Colors.black26,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: (){},
                      child: Text('Share', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700))
                    )
                  )
                ],
              ),
            ),
            Positioned(top: 140, child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF070123),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              child: Column(
                spacing: 16,
                children: [
                  InvitedBox(),
                  InvitedBox(),
                  InvitedBox(),
                  InvitedBox(),
                  InvitedBox(),
                  InvitedBox(),
                  InvitedBox(),
                  InvitedBox(),
                  InvitedBox(),
                  InvitedBox(),
                ],
              ),
            ))
          ],
        )
      )
    ]));
  }
  Widget InvitedBox() {
    return Container(
      height: 92,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFF170C34),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Share to 1 friends', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              Row(
                spacing: 8,
                children: [
                  Container(
                    height: 24,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF38295E),
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/bets.png', width: 16),
                        SizedBox(width: 4),
                        Text('100', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                  Container(
                    height: 24,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF38295E),
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/bets.png', width: 16),
                        SizedBox(width: 4),
                        Text('100', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            width: 71,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFBE71FD), Color(0xFF8033D1)],
                stops: [0, 1], // 调整渐变范围
              ),
              borderRadius: BorderRadius.circular(8)
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white60,
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Color(0xFF38295E),
                shadowColor: Colors.transparent,
                overlayColor: Colors.black26,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: null,
              child: Text('Claim', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
            )
          )
        ],
      ),
    );
  }
}
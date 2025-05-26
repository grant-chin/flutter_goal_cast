// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Widget SoccerItem() {
    return Container(
      width: 370,
      height: 174,
      decoration: BoxDecoration(
        color: Color(0xFF12072F),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 80,
            child: Container(
              width: 276,
              height: 186,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(190, 113, 253, 0.24),
                    offset: Offset(0, 0),
                    blurRadius: 60.3,
                  )
                ],
                borderRadius: BorderRadius.circular(186)
              ),
            )
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('UEFA Champions League', style: TextStyle(color: Colors.white30, fontSize: 14, fontWeight: FontWeight.w500, height: 1)),
                      Text('Today, 3:00 PM', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500, height: 1)),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    spacing: 24,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 129,
                        child: Row(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('ManCity', style: TextStyle(color: Colors.white70)),
                            Image.asset('assets/icons/club/manCity.png', width: 24),
                          ],
                        ),
                      ),
                      Image.asset('assets/icons/VS.png', width: 32),
                      SizedBox(
                        width: 129,
                        child: Row(
                          spacing: 8,
                          children: [
                            Image.asset('assets/icons/club/manCity.png', width: 24),
                            Text('ManCity', style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ]
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: [
                    Container(
                      width: 102,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text('1', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    Container(
                      width: 102,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text('Draw', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    Container(
                      width: 102,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text('2', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
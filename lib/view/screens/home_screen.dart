import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socify/model/data/user.dart';
import 'package:socify/model/services/firebase_auth.dart';
import 'package:socify/view/screens/posts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController(initialPage: 0);
  var _selectedTab = 0;
  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = i;
    });
  }

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.account_circle_outlined,
  ];
  var _bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    UserData userData = context.watch<UserData>();
    FirebaseAuthMethods methods = context.read<FirebaseAuthMethods>();
    print(userData.id);
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            50,
          ),
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: Color(0xffED642B),
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() {
          _bottomNavIndex = index;
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }),
        //other params
      ),
      body: PageView(
        controller: pageController,
        children: [
          PostsScreen(),
          Center(
            child: OutlinedButton(
              onPressed: () {
                methods.signOut(context);
              },
              child: Text("Log Out"),
            ),
          ),
        ],
      ),
    );
  }
}

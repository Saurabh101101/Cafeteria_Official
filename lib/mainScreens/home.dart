
import 'package:cafeteria_official/mainScreens/cart_screen.dart';
import 'package:cafeteria_official/mainScreens/history_screen.dart';
import 'package:flutter/material.dart';


import '../widgets/custom_animated_bottom_bar.dart';
import 'home_screen.dart';
import 'my_orders_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? sellerUID;
  HomeScreen({this.sellerUID});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  int _currentIndex = 0;
  final _inactiveColor = Colors.grey;

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: getBody(),
        bottomNavigationBar: _buildBottomBar()
    );
  }


  Widget _buildBottomBar() {
    return CustomAnimatedBottomBar(

        containerHeight: 63,
        backgroundColor: Colors.black,
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.restaurant_outlined),
            title: Text('MENU', style: TextStyle(color: Colors.white)),
            activeColor: Colors.green,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('MY ORDERS', style: TextStyle(color: Colors.white)),
            activeColor: Colors.purpleAccent,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.alarm_sharp),
            title: Text(
              'HISTORY ', style: TextStyle(color: Colors.white),
            ),
            activeColor: Colors.pink,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          )
        ]);
  }


  Widget getBody() {
    List<Widget> pages = [
      MyHomeScreen(),
      MyOrdersScreen(),
      HistoryScreen()

    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }
}

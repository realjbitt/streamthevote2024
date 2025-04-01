import 'package:flutter/material.dart';
import '../utilities/constants.dart' as c;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  }); // Constructor with named parameters

// Helper function to build each tab with a custom background
  Widget _buildCustomTab(IconData iconData, String text) {
    return Tab(
      height: 75,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(180), // Dark background with opacity
          borderRadius: BorderRadius.circular(10), // Rounded corners for the background
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Padding inside the background
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ensures the Row only takes up as much space as needed
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.blue[900],
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.w900,
              ),
              textScaler: const TextScaler.linear(.7),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140); // appbar height

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 100,
      flexibleSpace: const Image(image: AssetImage('images/flag.jpg'), fit: BoxFit.cover),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 10), // Space between icon
          Stack(
            children: <Widget>[
              Text(
                c.appName,
                style: TextStyle(
                  fontSize: 20,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 7
                    ..color = Colors.white.withAlpha(180), // Solid fill text color
                ),
              ),
              Text(
                c.appName,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue[900], // border text color
                ),
              ),
            ],
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(55.0),
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withAlpha(180), // More opaque at the bottom
                  Colors.white.withAlpha(180), // Fully transparent at the top
                ],
              ),
            ),
            child: TabBar(
              indicatorColor: Colors.blue[600],
              indicatorWeight: 9,
              tabs: [
                _buildCustomTab(Icons.info, 'Info'),
                _buildCustomTab(Icons.location_on, 'Drop Boxes'),
                // _buildCustomTab(Icons.search, 'Research'),
              ],
            )),
      ),
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.brightness_4, color: Colors.yellow[100]),
      //     onPressed: storage.toggleTheme,
      //   ),
      // ],
    );
  }
}

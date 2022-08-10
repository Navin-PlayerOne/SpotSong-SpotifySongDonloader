import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:spotsong/pages/about.dart';
import 'package:spotsong/pages/home_page.dart';

class NewNavBar extends StatelessWidget {
  const NewNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: GNav(
          color: Colors.black,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          activeColor: Colors.black,
          tabBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
          padding: const EdgeInsets.all(13),
          tabs: [
            GButton(
              onPressed: () => const Home(),
              icon: Icons.home_filled,
              text: 'Home',
            ),
            GButton(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              icon: Icons.info_outline,
              text: 'About',
            )
          ],
        ),
      ),
    );
  }
}

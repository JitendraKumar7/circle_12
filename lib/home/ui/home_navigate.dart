import 'package:flutter/material.dart';

import 'about/about.dart';
import 'event/event_page.dart';
import 'feedback/feedback.dart';
import 'home/home_page.dart';
import 'chat/chat_page.dart';
import 'offer/offer_page.dart';
import 'share/share_profile.dart';
import 'xplore/xplore_page.dart';
import 'profile/profile_page.dart';
import 'offer/manage_offer_page.dart';

enum HomeItem {
  HOME,
  CHAT,
  OFFERS,
  XPLORE,
  EVENT,
  ABOUT_APP,
  PROFILE,
  MANAGE_OFFER,
  SHARE_PROFILE,
  SHARE_APP,
  FEEDBACK,
  SUPPORT,
  RATE_REVIEW,
  LOGOUT,
}

class NavigationItem {
  final String title;
  final Widget? body;

  final IconData icon;
  final HomeItem item;

  String get getTitle => title.toUpperCase();

  NavigationItem(this.item, this.icon, this.title, this.body);
}

final List<NavigationItem> navigationItem = [
  ...drawerItem,
  ...bottomBarItem,
];

final List<NavigationItem> bottomBarItem = [
  NavigationItem(
    HomeItem.HOME,
    Icons.home,
    'Home',
    HomePage(),
  ),
  NavigationItem(
    HomeItem.CHAT,
    Icons.message,
    'Chat',
    ChatPage(),
  ),
  NavigationItem(
    HomeItem.OFFERS,
    Icons.local_offer,
    'Offers',
    OfferPage(),
  ),
  NavigationItem(
    HomeItem.XPLORE,
    Icons.business,
    'Xplore',
    XplorePage(),
  ),
  NavigationItem(
    HomeItem.EVENT,
    Icons.event,
    'Events',
    EventPage(),
  ),
];

final List<NavigationItem> drawerItem = [
  NavigationItem(
    HomeItem.ABOUT_APP,
    Icons.messenger,
    'About App',
    AboutPage(),
  ),
  NavigationItem(
    HomeItem.PROFILE,
    Icons.person,
    'Profile',
    ProfilePage(),
  ),
  NavigationItem(
    HomeItem.SHARE_PROFILE,
    Icons.mobile_screen_share,
    'Share Profile',
    ShareProfilePage(),
  ),
  NavigationItem(
    HomeItem.MANAGE_OFFER,
    Icons.local_offer,
    'Manage Offers',
    ManageOfferPage(),
  ),
  NavigationItem(
    HomeItem.SHARE_APP,
    Icons.share,
    'Share App',
    null,
  ),
  NavigationItem(
    HomeItem.FEEDBACK,
    Icons.feedback,
    'Feedback',
    FeedbackPage(),
  ),
  NavigationItem(
    HomeItem.SUPPORT,
    Icons.person,
    'Help & Support',
    null,
  ),
  NavigationItem(
    HomeItem.RATE_REVIEW,
    Icons.rate_review,
    'Rate & Review',
    null,
  ),
  NavigationItem(
    HomeItem.LOGOUT,
    Icons.logout,
    'Logout',
    null,
  ),
];

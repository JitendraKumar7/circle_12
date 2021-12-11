import 'package:circle/boradcast/broadcast.dart';
import 'package:circle/business/profile.dart';
import 'package:circle/home/index.dart';
import 'package:circle/login/login.dart';
import 'package:circle/notification/notification_page.dart';
import 'package:circle/offers/offers.dart';
import 'package:circle/slider/slider.dart';
import 'package:circle/circle/circle.dart';
import 'package:circle/search/search.dart';
import 'package:circle/contact/contact.dart';
import 'package:circle/profile/profile.dart';
import 'package:circle/sign_up/sign_up.dart';
import 'package:circle/youtube/youtube_player.dart';
import 'package:flutter/material.dart';

const String HOME = '/home';
const String LOGIN = '/login';
const String SEARCH = '/search';
const String SLIDER = '/slider';
const String SIGN_UP = '/signup';
const String PROFILE = '/profile';
const String NOTIFICATION = '/notification';

const String PLAYER = '/player';
const String ADD_OFFER = '/addOffer';
const String EDIT_OFFER = '/editOffer';
const String VIEW_OFFER = '/viewOffer';
const String LIST_OFFER = '/listOffers';

const String ADD_CIRCLE = '/addCircle';
const String EDIT_CIRCLE = '/editCircle';
const String VIEW_CIRCLE = '/viewCircle';
const String CHOOSE_CIRCLE = '/ChooseCircle';

const String ADD_BROADCAST = '/addBroadcast';
const String EDIT_BROADCAST = '/editBroadcast';

const String ADD_CONTACT = '/addContact';
const String VIEW_CONTACT = '/viewContact';
const String EDIT_PROFILE = '/editProfile';
const String VIEW_PROFILE = '/viewProfile';
const String VERIFICATION = '/verification';
const String CONTACT_REQUEST = '/contactRequest';

const String BUSINESS_GST = '/gst';
const String BUSINESS_LINKS = '/links';
const String BUSINESS_BANKS = '/banks';
const String BUSINESS_EMAILS = '/emails';
const String BUSINESS_PROFILE = '/basic';
const String BUSINESS_CONTACTS = '/contacts';
const String BUSINESS_KEYWORDS = '/keywords';
const String BUSINESS_LOCATION = '/location';
const String BUSINESS_CATALOGUE = '/catalogue';

Route onGenerateRoute(RouteSettings settings) => MaterialPageRoute(
      builder: (BuildContext context) {
        switch (settings.name) {
          case HOME:
            return IndexPage();
          case LOGIN:
            return LoginPage();
          case SLIDER:
            return SliderPage();
          case VERIFICATION:
            return VerifyPage();
          case PROFILE:
            return ProfilePage();
          case PLAYER:
            return VideoPlayer();
          case SIGN_UP:
            return SignUpPage();
          case SEARCH:
            return SearchPage();

          case NOTIFICATION:
            return NotificationPage();
          case ADD_OFFER:
            return AddOfferPage();
          case EDIT_OFFER:
            return EditOfferPage();
          case VIEW_OFFER:
            return ViewOfferPage();
          case LIST_OFFER:
            return ListOfferPage();
          case ADD_CIRCLE:
            return AddCirclePage();
          case EDIT_CIRCLE:
            return EditCirclePage();
          case ADD_BROADCAST:
            return AddBroadcast();
          case EDIT_BROADCAST:
            return EditBroadcast();

          case ADD_CONTACT:
            return AddContactPage();
          case CONTACT_REQUEST:
            return ContactRequestPage();
          case VIEW_CONTACT:
            return ViewContactPage();
          case VIEW_CIRCLE:
            return ViewCirclePage();
          case CHOOSE_CIRCLE:
            return ChooseCircle();
          case EDIT_PROFILE:
            return EditProfilePage();
          case VIEW_PROFILE:
            return ProfileViewPage();

          // BUSINESS EDIT PAGES
          case BUSINESS_PROFILE:
            return BusinessInfoPage();
          case BUSINESS_CATALOGUE:
            return CataloguePage();
          case BUSINESS_CONTACTS:
            return ContactsPage();
          case BUSINESS_EMAILS:
            return EmailsPage();
          case BUSINESS_GST:
            return GstPage();
          case BUSINESS_KEYWORDS:
            return KeywordsPage();
          case BUSINESS_LINKS:
            return LinksPage();
          case BUSINESS_BANKS:
            return BanksPage();
          case BUSINESS_LOCATION:
            return LocationPage();

          default:
            return Scaffold(
              appBar: AppBar(title: Text('Error')),
              body: Center(
                child: Text(
                  '${settings.name} not found!!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
        }
      },
      settings: settings,
    );

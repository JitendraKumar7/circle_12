import 'package:circle/app/app.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'expandable/expandable.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 3),
      children: [
        TextButton.icon(
          onPressed: () => Navigator.pushNamed(context, PLAYER),
          label: Text('Play Video'.toUpperCase()),
          icon: FaIcon(
            FontAwesomeIcons.youtube,
            color: Color(0xFFE60023),
          ),
        ),
        SizedBox(height: 9),
        ..._about
            .map((item) => Card(
                  margin: EdgeInsets.all(3),
                  child: ExpandableText(item),
                ))
            .toList(),
      ],
    );
  }
}

var _about = [
  {
    "header": "WHAT IS CIRCLE APP",
    "body":
        "<p style=\"text-align: justify;\"We all have a list of friends, relatives and business<br />We keep sharing references to buy or sell any new product or services<br />Circle is all about managing these informal references online. <br />Access multiple seller references of your friends, relatives, associates in this app <br />search by name, business category, city in circles <br />connect with any of the listed sellers to get best deals with additional assurance that the seller is known to you through the list admin<br /><br /></p>"
  },
  {
    "header": "We already have many whatsapp groups. Why this?",
    "body":
        "<div style=\"text-align: justify;\">list app offers a novel way of managing your contacts to promote own &amp; others business.</div>\n<ol>\n<li style=\"text-align: justify;\">Its just not a member communication platform to exchange or publish text &amp; files</li>\n<li style=\"text-align: justify;\">\n<div>All members name in list are search enabled unlike in whatsapp.</div>\n</li>\n<li style=\"text-align: justify;\">\n<div>Members can create a business or professional profile.They can add information about their products &amp; services.</div>\n</li>\n<li style=\"text-align: justify;\">\n<div>All profiles can be searched by business category, names or location wise .</div>\n</li>\n<li style=\"text-align: justify;\">\n<div>In an optimized search process , user can add dyanamic search keyword s for their business , it gets maximum profile view for particular keyword search in app.&nbsp;</div>\n</li>\n<li>\n<div style=\"text-align: justify;\">New posts as offer is available in category wise format .This enables a dynamic category wise search process for app users.</div>\n</li>\n</ol>"
  },
  {
    "header": "HOW TO CREATE A CIRCLE IN APP",
    "body":
        "<p style=\"text-align: justify;\">1) Select one or multiple contacts from the phonebook to start your list<br /><br /><br />2) Share list links with these contacts to let them know that you have added them in your circles.<br /><br /><br />3) Added contacts can signup in the app to start viewing your list and other members listed in it.<br /><br />4. Members in your list can now view &amp; search each others businesses<br /><br />5. your friends, relatives can similarly start their own list and add you in their list. once your number is added in any list by the list admin you start viewing business profiles of all other members in the list.<br /><br /></p>"
  },
  {
    "header": "CAN A NON-MEMBER VIEW ANY CIRCLE LIST",
    "body":
        "<p style=\"text-align: justify;\">Yes if the list admin shares list link and the receiver opens the link in the list app, he can start viewing members of the list inspite of not being a member in that list. viewers of the list can also search for business in the app,<br /><br /></p>"
  },
  {
    "header": "SELF MANAGE YOUR BUSINESS PROFILE",
    "body":
        "<p style=\"text-align: justify;\">The app provides a unique USP to all the list members <br />Even if the members may get listed in multiple circles by multiple friends and relatives, they have self access to own business profile in the settings section. <br />Through this access, users can update their business profile, including business name, location, contact, emails, weblinks, cover image, app search keywords, and catalog .<br /><br /></p>"
  },
  {
    "header": "SHARE BUSINESS CARD",
    "body":
        "<p style=\"text-align: justify;\">The additional benefit of creating a business profile in this app is that you can share your profile with anybody as a BUSINESS CARD,<br /> <br /> </p>"
  },
  {
    "header": "CREATE AND POST OFFERS",
    "body":
        "<p style=\"text-align: justify;\">The app allows users to create multiple type of offers in the app and post it like a story.<br /><br /></p>"
  },
  {
    "header": "HOW CAN A SELLER BENEFIT",
    "body":
        "<p style=\"text-align: justify;\">Circle app is the only platform in the world today where members and their business gets listed and visible to other members if a list admin wants to add it in his /her list. A list admin would never list any unkown or unseen business .<br /><br />This means only verified and trusted business gets visible in the app .The listing of your business in any list can be treated as virtual endorsement by the particular list admin. This app gives free opportunities for thousands of small and home businesses to get listed in their friends and relatives list and reach out to member customers with more surety and trust .<br /><br /></p>"
  },
  {
    "header": "HOW CAN A BUYER BENEFIT",
    "body":
        "<p style=\"text-align: justify;\">When we search for sellers of any product or service on google or any other e-commerce sites we for sure have a doubt of getting cheated by chance or bad luck . But if the seller is referred to us by any or our friends or relatives we get double sure of quality, price and service. <br /><br />This app provides the same experience of buying products and services from trusted sellers, as referred by list admins. <br />search from thousands of listed and referred businesses <br />get the best deals from them with an additional security, and assurance of quality.</p>"
  },
  {
    "header": "CATEGORIES OF CIRCLE",
    "body":
        "<p style=\"text-align: justify;\">Users can create 3 categories of list<br /> <br /> <strong>1. BUSINESS</strong> - You can create &amp; add multiple contacts in a business list. To maximise use, add verified product or service providers from phone book. These contacts can be from any city, place.<br /> As you add them, they will be notified by message.<br /> To authenticate the data, it would be best if you could call members and make them aware about the app and its benefit for their business or profession<br /> <br /><strong>2. SOCIAL</strong> - Create a list of members staying in the same APARTMENT COMPLEX, SOCIETY, RWA.<br />Circle of persons of same club, institution, organisation, chamber of commerce, industry associations, market associations can be created and used as digital business directory.<br />Once added new members can also start adding more members.<br /> To authenticate the data, it would be best if members could be made aware about the app and its benefit for their business or profession<br /> <br /> <strong>3. FAMILY</strong> – Create a list of members in your family . you can add directly blood related or indirectly related family members. <br />Once a family member is added he can also start adding new family members known to him. <br />Thus this list becomes a referral FAMILY TREE to buy products and services from the members in the family.<br /> To authenticate the data, it would be best if members could be made aware about the app and its benefit for their business or profession</p>"
  },
  {
    "header": "WHAT TYPES OF OFFERS/EVENTS/INVITES CAN BE POSTED",
    "body":
        "<p style=\"text-align: justify;\">Circle members can post in 5 different categories<br /> 1. Items sales purchase <br /> 2. Business offers <br /> 3. Social posts <br /> 4. For the family only <br /> 5. Post Invites</p>"
  },
  {
    "header": "WHAT KIND OF BUSINESS PROFILE CAN BE CREATED IN THE APP",
    "body":
        "<p style=\"text-align: justify;\">Circle members can self manage their profile from own account in the app<br /> Any changes in the profile gets auto updated in all circles<br /> Members in Trading, Manufacturing, services, export, import, online<br /> Members in profession like Medical, chartered accountants, engineers, architect<br /> Members working in any Govt office, private jobs, banks, NGO’s, education institutes<br /> Members not working but are studying, doing research or intern in any commercial organisation</p>"
  },
  {
    "header": "FAQ",
    "body":
        "<p style=\"text-align: justify;\"><strong>Is this any MLM or NETWORKING app for like amway or avlon? </strong></p><br /> <p style=\"text-align: justify;\">No, It is a business listing app based on mutual references.</p><br /> <p style=\"text-align: justify;\"><strong>Do I have to pay any amount to join or list my business? </strong></p><br /> <p style=\"text-align: justify;\">No, It's free business promotion through friends, relatives and associates references.</p><br /> <p style=\"text-align: justify;\"><strong>Is it only for businesses working in an online model? </strong></p><br /> <p style=\"text-align: justify;\">No, any model business can list here, irrespective of types and scale.</p><br /> <p style=\"text-align: justify;\"><strong>How many circles can I create in the app?</strong></p><br /> <p style=\"text-align: justify;\">Users can create multiple circles in all categories.</p><br /> <p style=\"text-align: justify;\"><strong>How many businesses can I list/add as a list admin?</strong></p><br /> <p style=\"text-align: justify;\">Users can add multiple business entities in his list as his references.</p><br /> <p style=\"text-align: justify;\"><strong>In how many circles can my business be listed in the app?</strong></p><br /> <p style=\"text-align: justify;\">User can get his business listed in multiple circles. It shall depend on friends and relatives to start their list in app and add you in it.</p><br /> <p style=\"text-align: justify;\"><strong>What is the benefit of listing my friends and relatives in this app?</strong></p><br /> <p style=\"text-align: justify;\">The social norm is to buy from a business one knows or has been referred to by somebody.</p><br /> <p style=\"text-align: justify;\">Listing of friends and relatives business in the app shall assure your list audience about fairness in business deals and may prompt them to buy it actually.</p><br /> <p style=\"text-align: justify;\">This additional business gets generated for your friends and relatives through you.</p><br /> <p style=\"text-align: justify;\"><strong>What is the benefit to my business?</strong></p><br /> <p style=\"text-align: justify;\">To gain maximum, motivate your friends and relatives to list your business in all their circles.</p><br /> <p style=\"text-align: justify;\"><strong>Why should I search here before buying any product or service?</strong></p><br /> <p style=\"text-align: justify;\">The list app only displays those businesses, either listed by you or your friends and relatives or business associates.</p><br /> <p style=\"text-align: justify;\">Thus with an extra dose of trust you are assured of a fair business deal with any one listed in the app.</p><br /> <p style=\"text-align: justify;\"><strong>Can I or anybody else review my business?</strong></p><br /> <p style=\"text-align: justify;\">Anybody other than yourself can review your business.</p><br /> <p style=\"text-align: justify;\"><strong>Can I link my social media profile page?</strong></p><br /> <p style=\"text-align: justify;\">Yes from business dashboard</p><br /> <p style=\"text-align: justify;\"><strong>How can I benefit from the KonnectMyBusiness.com account here?</strong></p><br /> <p style=\"text-align: justify;\">Kmb is a platform to create your digital business card.</p><br /> <p style=\"text-align: justify;\">If you have an online card there in any account then you can link the card with the same login id here as well.</p><br /> <p style=\"text-align: justify;\"><strong>How can I manage my business listing?</strong></p><br /> <p style=\"text-align: justify;\">A business dashboard gets activated once your number is included in any list in the app.</p><br /> <p style=\"text-align: justify;\">Open it in the profile page of the app, start managing from here.</p><br /> <p style=\"text-align: justify;\"><strong>I want to delete my listing from a list in the app?</strong></p><br /> <p style=\"text-align: justify;\">Your business gets added in a list by an admin but you can get the listing removed.</p><br /> <p style=\"text-align: justify;\">Open list list, select list, go to your listing and click delete to remove.</p><br /> <p style=\"text-align: justify;\"><strong>I want to delete my listing in all the circles in the app? </strong></p><br /> <p style=\"text-align: justify;\">Open profile page, select business dashboard, select option disable.</p><br /> <p style=\"text-align: justify;\"><strong>I want to delete all or one of my circles created?</strong></p><br /> <p style=\"text-align: justify;\">You can delete circles one by one.</p><br /> <p style=\"text-align: justify;\">Once deleted you cannot recover it. No one can then view its members also.</p><br /> <p style=\"text-align: justify;\"><strong>What additional offers can I promote in the app? </strong></p><br /> <p style=\"text-align: justify;\">The app can promote these offers</p><br /> <p style=\"text-align: justify;\">1. Specific period business offers</p><br /> <p style=\"text-align: justify;\">2. Jobs available</p><br /> <p style=\"text-align: justify;\">3. Sales and purchase</p><br /> <p style=\"text-align: justify;\">4. Bride /groom for marriage in family list only.</p><br /> <p style=\"text-align: justify;\"><strong>Will my data be used by app?</strong></p><br /> <p style=\"text-align: justify;\">It&rsquo;s a pure business listing app, where one should share only the official address, name, mobile numbers and email ids. We have no control over third party use of this data.</p><br /> <p style=\"text-align: justify;\"><strong>Can fake business be promoted through this app?</strong></p><br /> <p style=\"text-align: justify;\">All information shared here is not verified by us in any manner. The risks stand just like in the brick &amp; mortar model.</p>"
  }
];

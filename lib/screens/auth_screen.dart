import 'package:bartender/providers/auth.dart';
import 'package:bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen();

  Widget userProfile(Auth provider, TextTheme textTheme) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey,
          backgroundImage: provider.imageUrl != null 
            ? NetworkImage(provider.imageUrl)
            : null,
        ),
        Column(children: [
          Text(provider.username, style: textTheme.bodyText1, textAlign: TextAlign.start,),
          if(provider.location != null)
            Text(provider.location, style: textTheme.caption, textAlign: TextAlign.start,)
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        )
      ],),
      SizedBox(height: 40,),
      Container(
        child: Text("${provider.username}'s Custom Cocktails", style: textTheme.headline6),
        padding: const EdgeInsets.only(bottom: 10),
      ),
      CarouselSlider(
          options: CarouselOptions(height: 240.0, viewportFraction: 0.5, enlargeCenterPage: true),
          items: ["first", "second", "third", "fourth"].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: 160,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.amber
                  ),
                  child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                );
              },
            );
          }).toList(),
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context); 
    final textThemes = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text("account")),
      body: provider.isLoggedIn
        ? Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 80),
          child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                userProfile(provider, textThemes),
                FlatButton(
                  child: const Text("Logout", style: TextStyle(color: Colors.red)),
                  onPressed: () => provider.logout(),
                )
            ])
        )
        : AuthFormWrapper()
    );
  }
}

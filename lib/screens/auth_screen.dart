import 'package:bartender/firebase_util.dart';
import 'package:bartender/providers/auth.dart';
import 'package:bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:bartender/widgets/cocktail_gridview.dart';
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
            backgroundColor: Colors.white,
            backgroundImage: provider.profileImage
          ),
          Column(
            children: [
              Text(
                provider.username,
                style: textTheme.headline6,
                textAlign: TextAlign.start,
              ),
              if (provider.location != null)
                Text(
                  provider.location,
                  style: textTheme.overline,
                  textAlign: TextAlign.start,
                )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        ],
      ),
      /*CarouselSlider(
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
        ),*/
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context, listen: false);
    final textThemes = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: provider.isLoggedIn
        ? Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              userProfile(provider, textThemes),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("${provider.username}'s Custom Cocktails", textAlign: TextAlign.start,
                              style: textThemes.headline6)),
              ),
              Expanded(
                // height: 500,
                // child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: findCommunityCocktailByIds(provider.custom),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if(snapshot.hasError) {
                        print("error in collection screen findCommunityCocktailByIds");
                        print(snapshot.error.toString());
                        return Center(child: Text("An error has occured, please try again later!"));
                      }
                      return CocktailGridView(
                        showSearchBar: false,
                        cocktailsList: snapshot.data,
                      );
                    }
                  ),
                ),
              // ),
              TextButton(
                child: const Text("Logout",
                    style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  await provider.logout();
                  Navigator.of(context).pop();
                },
              )
            ]))
          : AuthFormWrapper(showScaffold: true)); 
  }
}

import 'dart:io';
import 'package:home_bartender/firebase_util.dart';
import 'package:home_bartender/providers/auth.dart';
import 'package:home_bartender/screens/community_cocktail_detail_screen.dart';
import 'package:home_bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:home_bartender/model/cocktail.dart';

import 'package:home_bartender/model/ingredient.dart';
import 'package:home_bartender/widgets/customzie_cocktail_screen/ingredients_input_list.dart';
import 'package:home_bartender/widgets/customzie_cocktail_screen/receipe_image_picker.dart';
import 'package:home_bartender/widgets/customzie_cocktail_screen/prepstep_input_list.dart';
import 'package:provider/provider.dart';

class CustomizeCocktailScreen extends StatefulWidget {
  final Cocktail cocktail;

  CustomizeCocktailScreen(this.cocktail);

  @override
  _CustomizeCocktailScreenState createState() =>
      _CustomizeCocktailScreenState();
}

class _CustomizeCocktailScreenState extends State<CustomizeCocktailScreen> {

  List<Ingredient> _ingredientsList;
  List<String> _prepStepsList;
  bool _isPublic;
  CommunityCocktail _customCocktail;
  final _form = GlobalKey<FormState>();
  File _userImageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isPublic = true;
    if(widget.cocktail != null){
      _customCocktail = new CommunityCocktail(
        name: "Custom ${widget.cocktail.name}",
        originalCocktailId: widget.cocktail.id,
        ingredients: List.of(widget.cocktail.ingredients),
        prepSteps: widget.cocktail.prepSteps == null ? [null] : widget.cocktail.prepSteps,
      );
    } else {
      _customCocktail = new CommunityCocktail(
        name: "",
        ingredients: [
          Ingredient.empty()
        ],
        prepSteps: [
          null
        ],
      );
    }
    _ingredientsList = _customCocktail.ingredients;
      _prepStepsList = _customCocktail.prepSteps;
  }

  void _addIngredient() => setState(
      () => _ingredientsList = [..._ingredientsList, Ingredient.empty()]);
  void _addPrepStep() =>
      setState(() => _prepStepsList = [..._prepStepsList, null]);
  void _deleteIngredient() => setState(() => _ingredientsList.removeLast());
  void _deletePrepStep() => setState(() => _prepStepsList.removeLast());

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _saveRecipeName(String val) => _customCocktail.name = val;

  Future<void> _saveForm(Auth authProvider, BuildContext ctx) async {
    if (!_form.currentState.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    _form.currentState.save();

    if (_ingredientsList == null || _prepStepsList == null || _ingredientsList.length == 0 || _prepStepsList.length == 0) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(_ingredientsList.length == 0  
            ? "Please add at least one ingredient"
            : "Please add at least one preparation step"),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      return;
    }
    _customCocktail.ingredients = _ingredientsList;
    _customCocktail.prepSteps = _prepStepsList;
    _customCocktail.isPublic = _isPublic;
    if(_userImageFile == null){
      if(widget.cocktail == null){
        _customCocktail.imageUrl = null;
      } else {
        _customCocktail.imageUrl = widget.cocktail.imageUrl;
      }
    }else {
      String url = await saveImageToFireStore(_userImageFile, 'community_cocktail_image', authProvider.id + '_'+ DateTime.now().toString());
      _customCocktail.imageUrl = url;
    }
    _customCocktail.authorName = authProvider.username;
    _customCocktail.authorId = authProvider.id;
    _customCocktail.createdAt = DateTime.now();
    
    Map<String, dynamic> jsonData = _customCocktail.toJson();
    String docId = await saveCommunityCocktail(jsonData);
    authProvider.addCustom(docId);
    
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text("Custom Recipe added!"),
          backgroundColor: Colors.greenAccent,
          duration: Duration(milliseconds: 2000),
        ),
      );
      
    Navigator.of(context).pushNamed(
      CommunityCocktailDetailScreen.routeName,
      arguments: _customCocktail,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;
    final auth = Provider.of<Auth>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Customize Cocktail'),
          actions: <Widget>[
            TextButton(
              child: Text("Done", style: TextStyle(color: Colors.black)),
              onPressed: () => _saveForm(auth, context),
            ),
          ],
        ),
        body: auth.isLoggedIn 
        ? _isLoading 
        ? Center(child: CircularProgressIndicator.adaptive(),)
        : GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      Container(
                        child: RecipeImagePicker(_pickedImage, _saveRecipeName),
                      ),
                      Row(children: [
                        Expanded(
                            child: Text(
                                "Allow my reciepe to be shown to the community")),
                        Platform.isIOS 
                        ? CupertinoSwitch(
                          value: _isPublic,
                          onChanged: (val) {
                            _customCocktail.isPublic = val;
                            setState(() => _isPublic = val);
                          },
                        )
                        : Switch(
                          activeTrackColor: Colors.greenAccent,
                          value: _isPublic,
                           onChanged: (val) {
                            _customCocktail.isPublic = val;
                            setState(() => _isPublic = val);
                          },
                        )
                      ]),
                      
                      Container(
                        child: IngredientsInputList(
                            _ingredientsList, _deleteIngredient, _addIngredient),
                      ),
                      const SizedBox(height: 5,),
                      Container(
                          child: PrepstepInputList(
                              _prepStepsList, _deletePrepStep, _addPrepStep)),
                      const SizedBox(height: 5,),
                      Container(
                        child: Text("Notes", style: textThemes.headline6),
                        padding: const EdgeInsets.all(10),
                      ),
                      Container(
                        height: 100,
                        child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black54),
                                    borderRadius: BorderRadius.circular(5)),
                                hintText: "Add Notes..."),
                            style: TextStyle(fontSize: 16),
                            keyboardType: TextInputType.multiline,
                            minLines: 4,
                            cursorColor: Colors.black,
                            autocorrect: true,
                            maxLines: null,
                            onSaved: (val) {
                              _customCocktail.notes = val;
                            }),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                )),
          ),
        )
        : AuthFormWrapper()
      );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class Secondpage extends StatefulWidget {
  String squery;
  Secondpage(this.squery, {super.key});

  @override
  State<Secondpage> createState() => _SecondpageState();
}

class _SecondpageState extends State<Secondpage> {
  var search = TextEditingController();
  bool loading = true;

  late final String ulr="";
  late Uri lk = Uri.parse(ulr);

  //ahi RecipeData class no data store thashe list formet maa(api.dart ma class che ee)
  List<RecipeData> recipelist = <RecipeData>[];

  String query = "";
  //APi
  Future recipeApi(String query) async {
    Response api = await get(Uri.parse(
        "https://api.edamam.com/search?q=$query&app_id=f77229e5&app_key=e3cfb1151f6355fcd3f060c728efb17c"));
    Map<String, dynamic> apidata = jsonDecode(api.body);
    // print(apidata);
    List a = apidata["hits"];
    recipelist.clear();
    for (var element in a) {
      //a for loop thi hints list na ader na map print thashe
      //object recipeData name no
      RecipeData recipeData = RecipeData(appurl: '');
      recipeData = RecipeData.fromMap(element[
          "recipe"]); //anathi recipe map na ander na element print thashe
      recipelist.add(
          recipeData); // e data uper na blank recipelist name na list ma print thashee
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    recipeApi(widget.squery);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: double.infinity,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff213A50),
          Color(0xff071938),
        ])),
        child: ListView(
          children:[
            //SEARCH
            SafeArea(
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 12),
                padding: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blueAccent, width: 2)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: search,
                        decoration: const InputDecoration(
                            hintText: "Let's Cook Something New",
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        recipeApi(search.text); //controller ma je search kariu ee as a text ama print karai do
                        // Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //BUILDER
            if(loading)
                LoadingAnimationWidget.hexagonDots(color: Colors.white, size: 100)
            else
               ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: recipelist.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      String ulr=recipelist[index].appurl;
                      Uri lk = Uri.parse(ulr);
                      launchUrl(lk);
                    },
                    child: Card(
                      margin:
                          const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              recipelist[index].appimagesurl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 250,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 60,
                            child: Container(
                                alignment: Alignment.center,
                                decoration:
                                    const BoxDecoration(color: Colors.black38),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    recipelist[index].applable,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )),
                          ),
                          Positioned(
                            right: 0,
                            height: 50,
                            width: 100,
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    Text(
                                      recipelist[index]
                                          .appcalories
                                          .toString()
                                          .substring(0, 5),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

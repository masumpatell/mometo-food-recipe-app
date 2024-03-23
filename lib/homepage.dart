import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mometo/secondpage.dart';
import 'api.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var search = TextEditingController();
  bool loading = true;

  //ahi RecipeData class no data store thashe list formet maa(api.dart ma class che ee)
  List<RecipeData> recipelist = <RecipeData>[];

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
      RecipeData recipeData = RecipeData();
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
    recipeApi("samosa");
    super.initState();
  }

  // late String ulr="";
  // late Uri lk = Uri.parse(ulr);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff213A50),
          Color(0xff071938),
        ])),
        child: ListView(
          children: [
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Secondpage(search.text)),
                        );
                      },
                      child: const Icon(Icons.search,size: 30,),
                    ),
                  ],
                ),
              ),
            ),
            //TEXT
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What Do You Went To Cook Today?",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("Let's Cook Something",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          // backgroundColor: Colors.pink,
                        )),
                  ),
                ],
              ),
            ),
            //SLIDER
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15),
              child: CarouselSlider(
                options: CarouselOptions(height: 250.0,autoPlay: true,autoPlayInterval: const Duration(seconds: 3)),
                items: [
                  "https://media.istockphoto.com/id/1279763992/photo/healthy-food-for-lower-cholesterol-and-heart-care-shot-on-wooden-table.webp?s=2048x2048&w=is&k=20&c=YZD5kYhCtOIFlXC3s6bN0KN3vnbpQdvuGpqfBPC5p5M=",
                  "https://images.unsplash.com/photo-1637646681555-e866bfb1780f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  "https://images.unsplash.com/photo-1551276929-3f75211e0986?q=80&w=1900&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  "https://media.istockphoto.com/id/824753432/photo/thukpa-is-a-tibetan-noodle-soup-which-originated-in-the-eastern-part-of-tibet-amdo-thukpa-is-a.webp?s=2048x2048&w=is&k=20&c=XAg7PFq-HeFtKr5jqP4TitxCrt0PZ_mDP8gb6ErKpK8=",
                  "https://images.unsplash.com/photo-1669626389217-84f0a7bdf9f5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                ].map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(color: Colors.black12,),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover, // adjust as per your requirement
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            //BUILDER
            if(loading)
              LoadingAnimationWidget.hexagonDots(color: Colors.white, size: 100)
            else
              ListView.builder(
                //if-else statement
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
                        margin: const EdgeInsets.only(
                            left: 15.0, right: 15, top: 20),
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
                                  decoration: const BoxDecoration(
                                      color: Colors.black38),
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

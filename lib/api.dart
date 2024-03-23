// https://developer.edamam.com/edamam-recipe-api
// https://api.edamam.com/search?q=chicken&app_id=f77229e5&app_key=e3cfb1151f6355fcd3f060c728efb17c

class RecipeData {
  //Instance Variable
  late String applable;
  late String appurl;
  late String appimagesurl;
  late double appcalories;

  //Constructor:- when we create object for this class then this is automatic call
  RecipeData(
      {this.applable = "Lable",
      this.appcalories = 0.0,
      this.appimagesurl = "Img",
      this.appurl = "Url"}
      );
  factory RecipeData.fromMap(Map recipe){
    return RecipeData(
      applable: recipe["label"],
      appurl: recipe["url"],
        appcalories: recipe["calories"],
      appimagesurl: recipe["image"]
    );

  }

}

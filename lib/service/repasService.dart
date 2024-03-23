import 'dart:convert';
import 'dart:io';
import 'package:diwe_front/model/Meal.dart';
import 'package:diwe_front/repas/carrousel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MealPost {
  final String apiUrl = "${dotenv.env['API_HOST']}meal";
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> postMeal(Map<String, dynamic> mealInfo, File image) async {
    String? jwtToken = await storage.read(key: 'jwt');
    String? apiKey = dotenv.env['X_API_KEY'];
    String? mimeType = lookupMimeType(image.path);
    String fileExtension = mimeType?.split('/')[1] ?? '';
    print(jwtToken);
    print(apiKey);

    if (jwtToken == null || apiKey == null) {
      throw Exception('JWT Token or API Key not found');
    }

    List<int> imageBytes = await image.readAsBytesSync();

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..headers['Authorization'] = 'Bearer $jwtToken'
      ..headers['x-api-key'] = apiKey
      ..files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: basename(image.path),
          contentType: MediaType('image', fileExtension)));

    mealInfo.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Meal.dart data and image uploaded successfully.');
    } else {
      print('Failed to upload meal data and image. Status code: ${response.statusCode}');
      var responseString = await response.stream.bytesToString();
      print('Response from the server: $responseString');
    }
  }

}



class FoodVisorPost {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String foodVisorApiUrl = 'https://vision.foodvisor.io/api/1.0/fr/analysis/';

  Future<void> analyzeImage(String apiKey, File image) async {
    var request = http.MultipartRequest('POST', Uri.parse(foodVisorApiUrl))
      ..headers['Authorization'] = 'Api-Key $apiKey' // La clé API est déjà intégrée ici
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        filename: basename(image.path),
      ));
    print(image);

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var analysisResponse = jsonDecode(responseBody);
      print('Analysis from FoodVisor: $analysisResponse');
      var foodInfo = analysisResponse['items'][0]['food'][0]['food_info'];
      var nutrition = foodInfo['nutrition'];

      var mealInfo = {
        'name': foodInfo['display_name'].toString(), // Ajustez les valeurs selon les résultats de l'API FoodVisor
        'calories': nutrition['calories_100g'],  // Ces valeurs sont des exemples
        'proteins':nutrition['proteins_100g'].toString(),
        'lipids': nutrition['fat_100g'].toString(),
        'glucids': nutrition['carbs_100g'].toString(),
        'fibers': nutrition['fibers_100g'].toString(),
        'calcium':nutrition['calcium_100g'].toString(),
        'date': DateTime.now().toIso8601String(),
      };

      MealPost mealPost = MealPost();
      await mealPost.postMeal(mealInfo, image);
    } else {
      print('Failed to analyze image with FoodVisor. Status code: ${response.statusCode}');
      var responseString = await response.stream.bytesToString();
      print('Response from FoodVisor: $responseString');
    }
  }
}
class FetchMealsException implements Exception {
final String message;

FetchMealsException({required this.message});
}

class MealGet {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String apiUrl = "${dotenv.env['API_HOST']}meal";
  String? apiKey = dotenv.env['X_API_KEY'];

  Future<List<Meals>> fetchMeals() async {
    String? jwtToken = await storage.read(key: 'jwt');

    if (jwtToken == null) {
      throw FetchMealsException(message: 'JWT Token not found');
    }
   print(apiKey);
    print(jwtToken);
    var url = Uri.parse('$apiUrl?number=0'); // Ajoutez le paramètre "number" à l'URL
    var response = await http.get(url, headers: {
      'Authorization' : 'Bearer $jwtToken',
      'x-api-key' : '$apiKey'
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      print(response.body);
      List<dynamic> mealsData = data['meals']; // Accédez à la liste des repas dans l'objet

      List<Meals> meals = mealsData.map((mealData) => Meals.fromJson(mealData as Map<String, dynamic>)).toList();

      return meals;
    } else {
      String errorMessage = 'Failed to load meals. Server responded with status code: ${response.statusCode}';
      print(errorMessage);
      print('Response body: ${response.body}');
      throw FetchMealsException(message: errorMessage);
    }
  }

  Future<List<Meals>> fetchMealsWithPage(int page) async {
    String? jwtToken = await storage.read(key: 'jwt');

    if (jwtToken == null) {
      throw FetchMealsException(message: 'JWT Token not found');
    }

    var url = Uri.parse('$apiUrl?number=$page'); // Ajoutez le paramètre "number" à l'URL
    var response = await http.get(url, headers: {
      'Authorization' : 'Bearer $jwtToken',
      'x-api-key' : ' $apiKey'
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      print(response.body);
      List<dynamic> mealsData = data['meals']; // Accédez à la liste des repas dans l'objet

      List<Meals> meals = mealsData.map((mealData) => Meals.fromJson(mealData as Map<String, dynamic>)).toList();

      return meals;
    } else {
      String errorMessage = 'Failed to load meals. Server responded with status code: ${response.statusCode}';
      print(errorMessage);
      print('Response body: ${response.body}');
      throw FetchMealsException(message: errorMessage);
    }
  }



}
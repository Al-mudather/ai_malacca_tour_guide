import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceImages {
  static const String apiKey = "AIzaSyAMWob4UKda6dTRR4YXliN7O90Y9VFzDdU";
  static const String unsplashAccessKey =
      "mmyOJc1uDiPOFB71KhtKhNo_LPEZUlcUfrD-lvIpnBM";

  Future<String?> getWikimediaImage(String placeName) async {
    try {
      final url = Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&titles=$placeName&prop=pageimages&format=json&pithumbsize=500',
      );
      print('-----------------------------------------------');
      print(url);
      print('-----------------------------------------------');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['query']['pages'];

        if (pages.isNotEmpty) {
          final page = pages.values.first;
          return page['thumbnail']?['source']; // Returns the image URL
        } else {
          print('No Wikimedia images found for $placeName.');
          return null;
        }
      } else {
        print('Failed to fetch Wikimedia images: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching Wikimedia image: $e');
      return null;
    }
  }

  Future<String?> getUnsplashImage(String query) async {
    try {
      final url = Uri.parse(
        'https://api.unsplash.com/search/photos?query=$query&per_page=2&client_id=$unsplashAccessKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          return data['results'][0]['urls']['regular']; // URL of the image
        } else {
          print('No images found.');
          return null;
        }
      } else {
        print('Failed to fetch images: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  Future<String?> getPlaceImageUrl(String placeName) async {
    try {
      // Search for the place using Google Places API
      final placeSearchUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$placeName&inputtype=textquery&fields=place_id,photos&key=$apiKey',
      );

      final response = await http.get(placeSearchUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['photos'] != null) {
          final photoReference =
              data['candidates'][0]['photos'][0]['photo_reference'];

          // Generate the image URL using the Photo Reference
          final imageUrl =
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';

          return imageUrl;
        } else {
          print('No photos found for this place.');
          return null;
        }
      } else {
        print('Failed to fetch place details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}

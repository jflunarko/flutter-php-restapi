
import 'package:dio/dio.dart';
import 'package:flutter_tugas/repo/resp/listing_create_resp.dart';

class ListingRepository {
  Future<List<ListingModel>> getListings({String? searchName}) async {
    try {
      var response = await Dio().get(
        'http://10.0.0.95/api-php/listing_get.php',
        queryParameters: {
          if (searchName != null) 'name': searchName,
        },
      );
      List data = response.data['listings'];
      return data.map((e) => ListingModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch listings: $e');
    }
  }
Future<void> createListing(ListingModel listing) async {
  try {
    await Dio().post(
      'http://10.0.0.95/api-php/listing_add.php',
      data: {
        'agent_id': listing.agentId,
        'name': listing.name,
        'street': listing.street,
        'price': listing.price,
        'category': listing.category,
      },
    );
  } on DioException catch (e) {
    throw Exception(e.message);
  }
}

Future<void> updateListing(ListingModel listing) async {
    try {
      await Dio().post(
        'http://10.0.0.95/api-php/listing_edit.php',
        data: {
          'id': listing.id,
          'name': listing.name,
          'street': listing.street,
          'price': listing.price,
          'category': listing.category,
        },
      );
    } on DioException catch (e) {
      throw Exception('Failed to update listing: $e');
    }
  }

Future<void> deleteListing(int listingId) async {
  try {
    final Dio dio = Dio();
    String url = 'http://10.0.0.95/api-php/listing_delete.php';
    var response = await dio.post(url, data: {'id': listingId});

    if (response.statusCode == 200 && response.data['success'] == true) {
      // Listing deleted successfully
      print(response.data['message']);
    } else {
      throw Exception(response.data['message']);
    }
  } catch (e) {
    print('Failed to delete listing: $e');
  }
}

Future<List<ListingModel>> getListingsByAgent(int agentId) async {
  try {
    var response = await Dio().get(
      'http://10.0.0.95/api-php/listing_by_agent.php',
      queryParameters: {'agent_id': agentId},
    );
    List data = response.data['listings'];
    return data.map((e) => ListingModel.fromJson(e)).toList();
  } on DioException catch (e) {
    throw Exception('Failed to fetch listings for agent: $e');
  }
}

}

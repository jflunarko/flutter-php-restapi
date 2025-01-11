import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tugas/models/agent_models.dart'; // Assuming the model is named 'agent_model.dart'

class AgentRepository {
  final Dio _dio = Dio();

  Future<List<AgentModel>> getAgentModels({String searchName = ''}) async {
    try {
      String url = 'http://127.0.0.1/api-php/get_agent.php';
      if (searchName.isNotEmpty) {
        url += '?name=$searchName';  // Add the search parameter if provided
      }

      var response = await _dio.get(url);

      if (response.statusCode == 200) {
        debugPrint('Response agents: ${response.data['agents']}');

        List list = response.data['agents'];
        return list.map((element) => AgentModel.fromJson(element)).toList();
      } else {
        throw Exception('Failed to load agents: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = e.response != null
          ? 'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}'
          : 'Error: ${e.message}';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}


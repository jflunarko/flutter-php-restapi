import 'package:dio/dio.dart';
import 'package:flutter_tugas/models/agent_models.dart';

class AgentRepository {
  final Dio _dio = Dio();

  Future<List<AgentModel>> getAgentModels({String searchName = ''}) async {
    try {
      String url = 'http://10.0.0.95/api-php/agent_get.php';
      if (searchName.isNotEmpty) {
        url += '?name=$searchName';
      }

      var response = await _dio.get(url);

      if (response.statusCode == 200) {
        List list = response.data['agents'];
        return list.map((element) => AgentModel.fromJson(element)).toList();
      } else {
        throw Exception('Failed to load agents: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteAgent(int agentId) async {
    try {
      String url = 'http://10.0.0.95/api-php/agent_delete.php';
      var response = await _dio.post(url, data: {'id': agentId});

      if (response.statusCode != 200) {
        throw Exception('Failed to delete agent: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting agent: $e');
    }
  }

  Future<AgentModel?> getAgentById(int agentId) async {
  try {
    String url = 'http://10.0.0.95/api-php/agent_get_by_id.php?id=$agentId';

    var response = await _dio.get(url);

    if (response.statusCode == 200) {
      var agentData = response.data['agent'];
      if (agentData != null) {
        return AgentModel.fromJson(agentData);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load agent: ${response.statusCode}');
    }
  } on DioException catch (e) {
    throw Exception('Error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
}
Future<void> createAgent(AgentModel agent) async {
  try {
    String url = 'http://10.0.0.95/api-php/agent_add.php';

    var response = await _dio.post(url, data: {
        'name': agent.name,
        'email': agent.email,
        'password': agent.password,
        'status': agent.status,
      },);

    if (response.statusCode == 200 && response.data['success'] == true) {
      print('Agent created successfully: ${response.data['id']}');
    } else {
      throw Exception('Failed to create agent: ${response.data['message']}');
    }
  } on DioException catch (e) {
    throw Exception('Error creating agent: ${e.response?.statusCode} - ${e.response?.statusMessage}');
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
}

}


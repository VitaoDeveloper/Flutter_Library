import 'package:dio/dio.dart';

class ApiErrors {
  String handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Tempo de conexão esgotado. Verifique sua internet e tente novamente.';
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final message = _extractMessage(e.response?.data);
        return _mapStatusToMessage(status, message);
      case DioExceptionType.connectionError:
        return 'Não foi possível conectar ao servidor.';
      default:
        return 'Erro de rede. Tente novamente.';
    }
  }

  String _extractMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    }
    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData.trim();
    }
    return 'Sem detalhes adicionais.';
  }

  String _mapStatusToMessage(int? status, String apiMessage) {
    switch (status) {
      case 400:
        return 'Dados inválidos para esta operação. $apiMessage';
      case 404:
        return 'Registro não encontrado ou rota inválida. $apiMessage';
      case 409:
        if (_isGenreWithBooksConflict(apiMessage)) {
          return 'Não é possível excluir o gênero porque ele ainda possui livros cadastrados.';
        }
        return 'Conflito de dados. Esse registro já existe ou está vinculado a outro. $apiMessage';
      case 500:
        return 'Erro interno no servidor. Tente novamente em instantes.';
      default:
        return 'Falha na operação (HTTP $status). $apiMessage';
    }
  }

  bool _isGenreWithBooksConflict(String message) {
    final lower = message.toLowerCase();
    return lower.contains('foreign key') ||
        lower.contains('constraint') ||
        lower.contains('related') ||
        lower.contains('livro') ||
        lower.contains('book');
  }
}

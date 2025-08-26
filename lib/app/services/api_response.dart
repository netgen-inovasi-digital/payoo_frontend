class ApiResponse<T> {
  final String status; // success / error
  final String message;
  final T? data; // untuk response object tunggal (misal auth)
  final List<T>? result; // untuk response list (misal daftar lokasi)

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.result,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    // Jika ada key 'data' dan berupa Map -> parse sebagai object
    T? dataObj;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      dataObj = fromJsonT(json['data']);
    }

    // Jika ada key 'data' dan berupa List -> parse sebagai list
    List<T>? listResult;
    if (json['data'] != null && json['data'] is List) {
      listResult = List<T>.from((json['data'] as List)
          .map((x) => fromJsonT(x as Map<String, dynamic>)));
    }

    // Backward compatibility jika API lama pakai 'result'
    if (listResult == null &&
        json['result'] != null &&
        json['result'] is List) {
      listResult = List<T>.from((json['result'] as List)
          .map((x) => fromJsonT(x as Map<String, dynamic>)));
    }

    return ApiResponse(
      status: json['status'].toString(),
      message: json['message']?.toString() ?? '',
      data: dataObj,
      result: listResult,
    );
  }

  bool get isSuccess => status.toLowerCase() == 'success';
}

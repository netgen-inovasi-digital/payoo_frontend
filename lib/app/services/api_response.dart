class ApiResponse<T> {
  final int status;
  final String message;
  final List<T> result;

  ApiResponse(
      {required this.status, required this.message, required this.result});

  // Method to convert a JSON map into an ApiResponse object
  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      result: List<T>.from(json['result'].map((x) => fromJsonT(x))),
    );
  }
}

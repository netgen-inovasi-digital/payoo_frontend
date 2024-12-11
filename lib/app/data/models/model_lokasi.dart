class ModelLokasi {
  final String id;
  final String text;

  ModelLokasi({required this.id, required this.text});

  // Method to convert a JSON map into a ModelLokasi object
  factory ModelLokasi.fromJson(Map<String, dynamic> json) {
    return ModelLokasi(
      id: json['id'],
      text: json['text'],
    );
  }
}

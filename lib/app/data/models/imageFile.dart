
class ImageFile {
  final String originalName;
  final String storedName;
  final String mime;
  final int size;
  final String folder;
  final String path;
  final String url;

  ImageFile({
    required this.originalName,
    required this.storedName,
    required this.mime,
    required this.size,
    required this.folder,
    required this.path,
    required this.url,
  });

  factory ImageFile.fromJson(Map<String, dynamic> json) {
    return ImageFile(
      originalName: json['original_name'],
      storedName: json['stored_name'],
      mime: json['mime'],
      size: json['size'],
      folder: json['folder'],
      path: json['path'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original_name': originalName,
      'stored_name': storedName,
      'mime': mime,
      'size': size,
      'folder': folder,
      'path': path,
      'url': url,
    };
  }
}
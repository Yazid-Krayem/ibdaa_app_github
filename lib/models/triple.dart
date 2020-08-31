class GetTriple {
  final int id;
  final String tripleName;
  final String tripleImage;
  final String tripleUrl;
  final String universityName;

  GetTriple(
      {this.id,
      this.tripleName,
      this.tripleImage,
      this.tripleUrl,
      this.universityName});

  factory GetTriple.fromJson(Map<String, dynamic> json) {
    return GetTriple(
      id: json['id'],
      tripleName: json['triple_name'],
      tripleImage: json['triple_image'],
      tripleUrl: json['triple_url'],
      universityName: json['university_name'],
    );
  }
}

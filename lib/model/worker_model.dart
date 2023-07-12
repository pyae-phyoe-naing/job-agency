class WorkerModel {
  final String docId;
  final String? displayName;
  final String? photoURL;
  final String? email;
  final String? city;
  final String? cloudMessageToken;
  final String role;
  final double price;
  WorkerModel(
      {required this.docId,
      required this.displayName,
      required this.photoURL,
      required this.email,
      required this.city,
      required this.cloudMessageToken,
      required this.role,
      required this.price});

  factory WorkerModel.fromJson(String docId, dynamic data) => WorkerModel(
      docId: docId,
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      email: data['email'],
      cloudMessageToken: data['cloudMessageToken'],
      role: data['role'],
      price: double.parse(data['price'].toString()),
      city: data['city'] as String?
      );
}

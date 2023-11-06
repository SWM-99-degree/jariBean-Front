class AgreementModel {
  final String id;
  final String title;
  final String url;
  final bool isMandatory;
  bool isAgreed;

  AgreementModel({
    required this.id,
    required this.title,
    required this.url,
    required this.isMandatory,
    required this.isAgreed,
  });
}

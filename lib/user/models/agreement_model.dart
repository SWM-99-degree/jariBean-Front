class AgreementModel {
  final String id;
  final String title;
  final String description;
  final bool isMandatory;
  bool isAgreed;

  AgreementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isMandatory,
    required this.isAgreed,
  });
}

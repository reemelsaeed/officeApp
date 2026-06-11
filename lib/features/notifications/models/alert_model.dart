class AlertModel {
  String alertContent;
  String createdAt;

  AlertModel({required this.alertContent, required this.createdAt});

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      alertContent: map['alert_content'],
      createdAt: map['created_at'],
    );
  }
  Map<String, dynamic> toMap() {
    return {'alert_content': alertContent, 'created_at': createdAt};
  }
}

class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  String? type;
  bool? seen;
  // bool? type;
  DateTime? createdon;

  MessageModel(
      {this.messageid,
      this.sender,
      this.text,
      this.seen,
      this.type,
      this.createdon});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    type = map["type"];
    createdon = map["createdon"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "seen": seen,
      "type": type,
      "createdon": createdon
    };
  }
}

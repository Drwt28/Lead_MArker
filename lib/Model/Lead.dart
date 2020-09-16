class Lead {
  String name;
  String company;
  List labels;
  String note;
  String date;
  String id;
  var phoneNo;
  var email;
  String address;
  String event;
  String leadStatus;

  Lead(this.name, this.company, this.labels, this.note, this.date, this.id,
      this.phoneNo, this.email, this.address, this.event, this.leadStatus);

  static Lead fromJson(data) {
    return Lead(
        data['name'],
        data['company'],
        data['labels'] ?? [],
        data['note'],
        data['date_added'],
        data['leads_id'],
        data['phone_no'],
        data['email'],
        data['address'],
        data['event'],
        data['lead_status']);
  }
}

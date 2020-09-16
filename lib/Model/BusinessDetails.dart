class BusinessDetails {
  String name, description, address, timing, contactno, email;
  var logo;

  BusinessDetails(this.name, this.description, this.address, this.timing,
      this.contactno, this.email, this.logo);

  static BusinessDetails fromJson(response) {
    var d = response['user_business_list'];
    return BusinessDetails(
      d['bussiness_name'],
      d['bussiness_description'],
      d['bussiness_address'],
      d['bussiness_timing'],
      d['bussiness_contactno'],
      d['bussiness_email'],
      d['bussiness_logo'],
    );
  }
}

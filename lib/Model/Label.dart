class Label {
  String text, color;
  String id;
  bool _selected = false;

  Label(this.text, this.color, this.id,);


  bool get isSelected => _selected??false;

  set selected(bool value) {
    _selected = value;
  }

  static Label fromJson(data) {
    return Label(data['label_name'], data['color'], data['id']);
  }
}

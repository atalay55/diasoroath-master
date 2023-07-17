class Message{
  String? _message;
  bool ?_isCorrect;

  String get message => _message!;

  set message(String value) {
    _message = value;
  }

  bool   get isCorrect => _isCorrect!;

  set isCorrect(bool value) {
    _isCorrect = value;
  }
}
import '../../Entity/Message.dart';

 class Validation{

static checkUserName(String userName) {
  Message msg = Message();
  if (userName.isEmpty) {
    msg.message = "kullanıcı adı boş geçilemez";
    msg.isCorrect = false;
    return msg.message;
  }
  if (userName.length < 3) {
    msg.message = "kullanıcı adı 3 kelimeden fazla olmalıdır";
    msg.isCorrect = false;
    return msg.message;
  }
  if (userName.startsWith(RegExp(r"[0123456789]"))) {
    msg.message = "kullanıcı adı sayı ile başlayamaz";
    msg.isCorrect = false;
    return msg.message;
  }
  msg.isCorrect = true;
  return null;
}
static checkAge(String age) {
  print(age);
  Message msg = Message();
  if (age.isEmpty) {
    msg.message = "Yaş alanı  boş geçilemez";
    msg.isCorrect = false;
    return msg.message;
  }
  if (age.contains(RegExp(r"[a-zA-Z]"))) {
    msg.message = "yaşınızı doğru giriniz";
    msg.isCorrect = false;
    return msg.message;
  }
  if (int.parse(age)>100 || int.parse(age)<0) {
    msg.message = "yapay zeka 0-100 yaş aralığında sonuç vermektedir" ;
    msg.isCorrect = false;
    return msg.message;
  }

  msg.isCorrect = true;
  return null;
}
}
class Report{
  late String id;
  late String userId;
  late String ImagePath;
  late String reportDetail;
  late DateTime? timestamp;

  Report({required this.id,  this.timestamp,required this.userId,required this.ImagePath ,required this.reportDetail});


}
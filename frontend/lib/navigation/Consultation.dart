// ignore_for_file: file_names


class Consultation{
  String data;
  int id;
  int userId;
  int doctorId;
  String status;

  Consultation(this.id,this.userId,this.doctorId,this.data,this.status);

  int getDoctorId(){return doctorId;}
  String getData(){return data;}
  String getStatus(){return status;}
  int getId(){return id;}
  int getUserId(){return userId;}


}
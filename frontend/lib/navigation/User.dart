// ignore_for_file: file_names

class User{
  String role;
  String phone;
  String email;
  String firstName;
  String lastName;
  String password;
  int id;

  User(this.role, this.phone, this.email, this.firstName, this.lastName, this.password, this.id);

  void setRole(String role){this.role = role;}
  void setPhone(String phone){this.phone = phone;}
  void setEmail(String email){this.email = email;}
  void setFirstName(String firstName){this.firstName = firstName;}
  void setLastName(String lastName){this.lastName = lastName;}
  void setPassword(String password){this.password = password;}
  void setId(int id){this.id = id;}

  String getRole(){return role;}
  String getPhone(){return phone;}
  String getEmail(){return email;}
  String getFirstName(){return firstName;}
  String getLastName(){return lastName;}
  String getPassword(){return password;}
  int getId(){return id;}
}

late User myUser;
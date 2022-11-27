class Record {
  Record(this.userId,  this.img, this.name, this.price, this.date);
  String userId;
  String img;
  String name;
  int price;
  String date;

  String getUserId(){return userId;}
  String getImg(){return img;}
  String getProductName() {return name;}
  int getPrice(){return price;}
  String getDesc(){return date;}

  void setUserId(String val){userId=val;}
  void setImg(String val){img=val;}
  void setProductName(String val) {name=val;}
  void setPrice(int val){price=val;}
  void setDesc(String val){date=val;}
}
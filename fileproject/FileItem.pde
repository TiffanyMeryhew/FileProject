// Code from Visualizing Data, First Edition, Copyright 2008 Ben Fry.


class FileItem extends SimpleMapItem {
  FolderItem parent;    
  File file;
  String name;
  String path;
  PImage myImage;
  PImage myImage2;
  PImage myImage3;
  PImage myImage4;
  PImage myImage5;
  PImage myImage6;
  PImage myImage7;
  
  int level;
  
  color c;
  float hue;
  float brightness;
    
  float textPadding = 8;
    
  float boxLeft, boxTop;
  float boxRight, boxBottom;


  FileItem(FolderItem parent, File file, int level, int order) {
    this.parent = parent;
    this.file = file;
    this.order = order;
    this.level = level;
      
    name = file.getName();
    path = file.getAbsolutePath();
    size = file.length();
    
    myImage = loadImage(path);
    myImage2 = loadImage("gmicon.png");
    myImage3 = loadImage("pmp3icon.png");
    myImage4 = loadImage("pfileicon.png");
    myImage5 = loadImage("pquicktimeicon.png");
    myImage6 = loadImage("infoicon.png");
    myImage7 = loadImage("ppdficon.png");

    modTimes.add(file.lastModified());
  }

  
  void updateColors() {
    if (parent != null) {
      hue = map(order, 0, parent.getItemCount(), 0, 360);
    }
    brightness = modTimes.percentile(file.lastModified()) * 100;

    colorMode(HSB, 360, 100, 100);
    if (parent == zoomItem) {
      c = color(hue, 80, 80);
    } else if (parent != null) {
      c = color(parent.hue, 80, brightness);
    }
    colorMode(RGB, 255);
  }
  
  
  void calcBox() {
    boxLeft = zoomBounds.spanX(x, 0, width);
    boxRight = zoomBounds.spanX(x+w, 0, width);
    boxTop = zoomBounds.spanY(y, 0, height);
    boxBottom = zoomBounds.spanY(y+h, 0, height);
  }


  void draw() {
    calcBox();

    fill(c);
    rect(boxLeft, boxTop, boxRight, boxBottom);
    preview();
    if (textFits()) {
      drawTitle();
      //preview();
    } else if (mouseInside()) {
      rolloverItem = this;
      //preview();
    }
   }
   
  void preview(){
    
    if(name.indexOf(".png") != -1 || name.indexOf(".jpg") != -1){
      //myImage = loadImage(path);
      image(myImage, boxLeft, boxTop, boxRight-boxLeft, boxBottom-boxTop);
      if(mousePressed()){
        if(mouseInside()){
          open(path);
        }
      }
     
    }
    if(name.indexOf(".gmk") != -1){
      image(myImage2, boxLeft, boxTop, boxRight-boxLeft, boxBottom-boxTop);
    }
   if(name.indexOf(".mp3") != -1){
      image(myImage3, boxLeft, boxTop, boxRight-boxLeft, boxBottom-boxTop);
      if(mousePressed()){
        if(mouseInside()){
          open(path);
        }
      }
    }
    if(name.indexOf(".gb1") != -1){
      image(myImage4, boxLeft, boxTop, boxRight-boxLeft, boxBottom-boxTop);
    }
    if(name.indexOf(".avi") != -1){
      image(myImage5, boxLeft, boxTop, boxRight-boxLeft, boxBottom-boxTop);
      if(mousePressed()){
        if(mouseInside()){
          open(path);
        }
      }
    }
    if(name.indexOf(".ico") != -1 || name.indexOf(".txt") != -1){
      image(myImage6, boxLeft, boxTop, boxRight-boxLeft, boxBottom-boxTop);
    }
    if(name.indexOf(".pdf") != -1){
      image(myImage7, boxLeft, boxTop, boxRight-boxLeft, boxBottom-boxTop);
      if(mousePressed()){
        if(mouseInside()){
          open(path);
        }
      }
    }
  }
    
    
  void drawTitle() {
    fill(255, 200);
    
    float middleX = (boxLeft + boxRight) / 2;
    float middleY = (boxTop + boxBottom) / 2;
    if (middleX > 0 && middleX < width && middleY > 0 && middleY < height) {
      if (boxLeft + textWidth(name) + textPadding*2 > width) {
        textAlign(RIGHT);
        text(name, width - textPadding, boxBottom - textPadding);
      } else {
        textAlign(LEFT);
        text(name, boxLeft + textPadding, boxBottom - textPadding);
      }
    }
  }


  boolean textFits() {
    float wide = textWidth(name) + textPadding*2;
    float high = textAscent() + textDescent() + textPadding*2;
    return (boxRight - boxLeft > wide) && (boxBottom - boxTop > high); 
  }
    
 
  boolean mouseInside() {
    return (mouseX > boxLeft && mouseX < boxRight && 
            mouseY > boxTop && mouseY < boxBottom);    
  }


  boolean mousePressed() {
    if (mouseInside()) {
      if (mouseButton == LEFT) {
        parent.zoomIn();
        return true;

      } else if (mouseButton == RIGHT) {
        if (parent == zoomItem) {
          parent.zoomOut();
        } else {
          parent.hideContents();
        }
        return true;
      }
    }
    return false;
  }
}

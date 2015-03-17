import processing.opengl.*;
import processing.video.*;

Capture myCapture;
PImage img;
int w;
int h;
int npixels;
//
Pix pixs[];
//
int count;
int pause;
boolean inited;
color black;
int gshift;
int rshift;
color stamp[];

void setup() {
  w=320;
  h=240;
  npixels=w*h;
  //
  size(w, h);
  img=new PImage(w,h);
  String s="Philips ToUcam Pro Camera; Video-WDM";
  myCapture = new Capture(this, w, h, 15);
  //
  int c=0;
  pixs=new Pix[npixels];
  stamp=new color[npixels];
  for(int y=0; y<h; y++){
    for(int x=0; x<w; x++){
      pixs[(w*y)+x]=new Pix(x,y);
      pixs[(w*y)+x].id=c;
      c++;
    }
  }
  //
  background(255);
  inited=false;
  black=color(0,0,0);
  gshift = 255<<8;
  rshift = 255<<16;
  pause=50;
  println("setup");
}
void draw(){

  if(!inited){
    loadPixels();
    if(pixels[int(random(npixels))]!=black){
      initApp();
    }
  }else{
    //background(0);
    //
    count++;

    for(int i=0; i<npixels; i++){
      pixs[i].moveMe();
      pixs[i].drawMe();
    }
    updatePixels();
    //
    if(count>=pause){
      count=0;
      reasign();
    }
  }
}
//
void initApp(){
  println("init app");
  int x,y;
  img.loadPixels();
  for(int i=0; i<npixels; i++){
    pixs[i].getEnd(int(random(npixels)));
  }
  count=0;
  inited=true;
}
void captureEvent(Capture myCapture) {
  myCapture.read();
  System.arraycopy(myCapture.pixels,0,img.pixels,0,w*h);
  img.updatePixels();
}
//
void reasign(){
  int tolleration;
  //
  int x,y;
  int pos;
  img.loadPixels();
  for(int i=0; i<npixels; i++){
    tolleration=30;
    pos=int(random(npixels-1));
    while(!isSimilar(img.pixels[pos],pixs[i].c,tolleration)){
      tolleration++;
      pos=int(random(npixels-1));
    }
    pixs[i].getEnd(pos);
    pixs[i].startMoving();
  }
}
//
void printArray(float[] arr){
  for(int i=0; i<arr.length; i++){
    print(arr[i]+",");
  }
  println(" ");
}
boolean isSimilar(color c1,color c2, int tolleration)
{
  //int tolleration=190;
  //
  int b1=c1 & 255;
  int g1=(c1 & gshift) >> 8;
  int r1=(c1 & rshift) >> 16;
  //
  int b2=c2 & 255;
  int g2=(c2 & gshift) >> 8;
  int r2=(c2 & rshift) >> 16;
  //
  //println(b1+" "+b2);
  //
  int difference = abs(b1-b2)+abs(g1-g2)+abs(r1-r2);
  //println(difference);
  if(difference>tolleration){
    //println("false: "+difference);
    return false;
  }else{
    //println("true: "+difference);
    return true;
  }
}
//        //
//  Pix   //
//        //
class Pix
{
  float x;
  float y;
  //
  int xi;
  int yi;
  //
  int xf;
  int yf;
  //
  float speed;
  //
  int id;
  //
  color c;
  color cf;
  //
  boolean has2move;
  //
  Pix(int tx, int ty)
  {
    x=xi=tx;
    y=yi=ty;
    has2move=false;
    //
    speed=5;
  }
  /*void update()
  {
    if(id==0){
      println("update");
    }
    x=xi;
    y=yi;
    c=pixels[int((w*y)+x)];
  }*/
  void getEnd(int pos)
  {
    int y=int(pos/w);
    int x=pos%w;
    setEnd(x,y);
  }
  void setEnd(int tx, int ty)
  {
    xf=tx;
    yf=ty;
    cf=img.pixels[(w*yf)+xf];
    //
    if(id==0){
      println("setEnd:"+xf+" - "+yf+" cf:"+cf);
    }
  }
  void startMoving()
  {
    if(id==0){
      println("startMoving");
    }
    has2move=true;
    c=cf;
  }
  void moveMe()
  {
    if(!has2move){
      return;
    }
    x+=(xf-x)/speed;
    y+=(yf-y)/speed;
    //
    if(id==0){
      //print(x+"|"+y+" ");
    }
    //
    if(int(x*100)==xf*100 && int(y*100)==yf*100){
      //print(id+" ");
      x=xf;
      y=yf;
      if(id==0){
        println("arrived");
      }
      has2move=false;
    }
  }
  void drawMe()
  {
    int pos=int((w*int(y))+int(x));
    //print("   pos:"+pos+" c:"+c);
    pixels[pos]=c;
  }
  int round(float n)
  {
    float m=n%int(n);
    if(m>=.5){
      return int(n)+1;
    }else{
      return int(n);
    }
  }
}


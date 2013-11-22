//import codeanticode.gsvideo.*;
import processing.video.*;
Capture video;
//game
PVector pos,speed,prev;
int closestX, closestY;
boolean game = false;

//GSCapture cam;
color trackColor;

void setup(){
  size(640,490);
  video = new Capture (this, 640, 490, 15);
  smooth();
  
  trackColor = color(255,255,255);
  String[] cameras = Capture.list();
  
  if (cameras.length == 0){
    println ("There are no cameras available for capture.");
    exit();
  }
  else {
   println("Available Cameras:"); 
   for (int i=0; i < cameras.length; i++){
     println(cameras[i]);
   }
   //writen above : cam = new GSCapture (this, 640, 490, cameras[0]);
   video.start();
   }
  
  pos = new PVector (50,50);
  speed = new PVector (2,2);
  prev = new PVector();
}
  
void draw() {
  
  if (video.available() == true){
    video.read();
    set(0,0,video);
    
    //
    float worldRecord = 500;
    closestX = 0;
    closestY = 0;
    
    //Loop to walk through every pixel
    for (int x = 0; x<640; x++) {
     for (int y = 0; y<490; y++){
       int loc = x + y*640;
       
//current color
color currentColor = video.pixels[loc];
 float r1 = red(currentColor);
 float g1 = green(currentColor);
 float b1 = blue(currentColor);
 float r2 = red(trackColor);
 float g2 = green(trackColor); 
 float b2 = blue(trackColor);
 
 //color comparison
 float d = dist(r1,g1,b1,r2,g2,b2); 
 
 if (d<worldRecord){
   worldRecord = d;
   closestX = x;
   closestY = y;
 }
  }
   
 }
 //Only consider the color found if the distance is less than 10
 if (worldRecord < 1){
   fill (trackColor);
   strokeWeight(4.0);
   stroke(0);
   ellipse(closestX, closestY, 16, 16 );
 }
  
}

if(game){
  fill(255);
  stroke(255);
  //ellipse bouncing off edges of the screen
  ellipse(pos.x, pos.y, 20, 20);
  prev.set(pos.x, pos.y,0);
  pos.add(speed);
  if(pos.x<0 || pos.x>width){
    speed.x *= -1;
  }
  if(pos.y<0 || pos.y>height){
    speed.y *=-1;
  }
  
  //ellipse bouncing off rectangle
  if (
    ( pos.x > closestX-20 && pos.x < closestX && pos.y > closestY-20 && pos.y < closestY+20) ||
    ( pos.x > closestX && pos.x < closestX+30 && pos.y > closestY-20 && pos.y < closestY+20)
  //see 1:53  
  ){
    speed.x *= -1;
    }
    if ( 
      (pos.x > closestX-20 && pos.x < closestX+20 && pos.y > closestY-30 && pos.y < closestY) ||
      (pos.x > closestX-20 && pos.x < closestX+20 && pos.y > closestY && pos.y < closestY+30)
    ){
     speed.y *= -1;  
    }
}
    rectMode(CENTER);
    fill(255,255,255,50);
    rect(closestX, closestY, 50,50);
    
}

void mousePressed() {
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
  game = true; 
}
  
      

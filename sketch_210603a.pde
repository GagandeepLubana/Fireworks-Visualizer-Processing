
//prepping the Firework and Particle lists
ArrayList<Firework> ballList; 
ArrayList<Particle> ParticleList; 

//types of effects saved in a list
String[] Types = {"circle", "olympics", "random", "linear", "yinyang"};//different types of effects 

//variables that can be changed for each type of effect
boolean flicker;
float mx;
float my;
float w;
float yPos;
float r;
float g;
float b;


void setup(){
size(1280,720);

background(0);

ballList = new ArrayList<Firework>(); //this creates the firework list
ParticleList = new ArrayList<Particle>();//creates the Particle list

}


void draw(){//start of draw

//creates a black rectangle and decreases its transparency to make a trail of the firework
fill(0, 40);
rect(0,0,width,height);


if (ballList.size() == 0 && ParticleList.size() < 50){//checks if there are no fireworks or a little particles left
  ParticleList.clear();//removes any particles left
  
  for (int h = 0; h < random(1, 3); h++){//a loop to randomize when multiple effects happen
    
    int index = int(random(Types.length));//finds a random effect from the list
    println(Types[index]);
    
    
    //Checks for which effect it is and changes the firework's properties based on that
    if (Types[index] == "random"){
        flicker = true;
        mx = 0;
        my = 0;
        
        for (int i = 0; i < random(2, 5); i++){//adds a random amount of fireworks
          w = random(5, 14);//changes to random width for each firework
          ballList.add(new Firework(random(100,width-100),height, w, yPos, r, g, b ) );
        }
        
    }
    else if (Types[index] == "olympics"){
        flicker = false;
        int x = 200;
        w = 9;//need to assign w because it's needed for mx and my
        mx = w/1.5;
        my = w/1.5;
        yPos = 14;//To make the olympics pattern the y-position is used
        
        //nested for loop is used since the y-position needs to be changed multiple times and reset
        for (int j = 0; j < 2; j++){
          for (int i = 0; i < 2; i++){
            ballList.add(new Firework(x, height, w, yPos, r, g, b));
            x += 200;
            yPos -= 4;
          }
          yPos = 14;
        }
        
        ballList.add(new Firework(x, height, w, yPos, r, g, b));//adds the fifth circle of the pattern
        
    }
    else if (Types[index] == "circle"){
      flicker = false;
      w = 13;//assigns w because it's needed for mx and my
      mx = w/1.5;
      my = w/1.5;
      
      for (int i = 0; i < random(3, 7); i++){//creates a random amount of circles
        w = random(5, 14);
        yPos = random(10, 15);
        w = random(10, 14);
        ballList.add(new Firework(random(100,width-100),height, w, yPos, r, g, b ) );
      }
      
    }
    else if (Types[index] == "linear") {
      flicker = false;
      w = 12;
      mx = w/1.5;
      my = w/1.5;
      yPos = random(9, 16);
      
      for (int i = 0; i < random(3, 7); i++){//creates random amound of circles in a linear pattern
      w = random(5, 14);
      ballList.add(new Firework(random(100,width-100),height, w, yPos, r, g, b ) );
      }
      
    }
    else if (Types[index] == "yinyang"){
      flicker = true;
      w = 10;
      r = 255;
      g = 1;
      b = 1;
      float x = random(100, width-100);//needs a variable since there are going to be two rockets
      mx = 0;
      my = 0;
      yPos = random (8, 15);
      
      
      for (int i = 0; i < 2; i++){//repeated two times to create yin-yang effect
        w = random(5, 12);
        ballList.add(new Firework(x,height, w, yPos, r, g ,b ) );
        r = 255;
        g = 255;
        b = 255;
        x += 10;
      }
      //variables are reset so they don't interfere with other effects
      r = 0;
      g = 0;
      b = 0;
    }
}
}

exploder(flicker, mx, my);

}//end of draw



void exploder(boolean flicker, float mx, float my){//removes the firework when needed and creates new particles for explosion
  
  for(int i = 0; i < ballList.size(); i++){
    Firework b = ballList.get(i); //set the ball from the list to the variable b
    
    //moves the firework and applies gravity
    b.display();
    b.move();
    b.Physics();
    
    if(b.removeList() == true){//checks if the firework is ready to be removed
  
      for (int j = 0; j < 100; j++){//creates a hundred particles for the explosion
        ParticleList.add(new Particle(b.x, b.y, b.w, b.a, mx, my, b.r, b.g, b.b));
      }
      
      ballList.remove(i);//the rocket is removed after since its properties are needed for the particles
      println(ballList.size(), ParticleList.size());
   
    }
  
  
  }
    
    for (int i = 0; i < ParticleList.size(); i++){//updates, moves, and applies gravity to each particle in explosion
      Particle g = ParticleList.get(i);
      g.display();
      g.explode();
      g.Physics();
      
      //the particles flicker if it's set to true
      if (flicker == true){
        g.flicker();
      }
      
      if (g.removeList() == true){
        ParticleList.remove(i);
      }
    }
    
  
}

    
    
    
class Particle {//class for the particles in the explosion
  
  float x;
  float y;
  float a;//alpha
  float w;//width (size) of particle
  float mx;//x movement
  float my;//y movement
  float rotation;
  float r;
  float g;
  float b;
  
Particle(float xCoord, float yCoord, float pWidth, float alpha, float speedX, float speedY, float red, float green, float blue) {
  
  //most of the properties are from the original launching firework
  //some like alpha are from the effect that was chosen
  x = xCoord;
  y = yCoord;
  w = pWidth;
  
  if (alpha == 0){//creates random opacity of each particle
  a = random(0,255); 
  }
  else{
  a = alpha;
  }

  if (speedX == 0 && speedY == 0){//makes a cloud of explosion if the velocities are unchanged by the effect
    mx = random(0,w)/1.5;
    my = random(0,w)/1.5;
  }
  else{//makes a perfect circle explosion otherwise
  mx = speedX;
  my = speedY;
  }
  
  rotation = random(0, 2*PI);//finds a random rotation for the particle to go to
  r = red;
  g = green;
  b = blue;
}


void Physics(){
   
   //decreases the x and y velocities to give it a firework effect
   my *= 0.95;
   mx *= 0.95;
   
   //gravity
   if (my < 2 && my > -2){//when particles slow down, gravity is applied
     y += 0.5;
   }
   
}

void explode() {//makes particles explode in random directions in a circle
  
  x += mx * cos(rotation);
  y -= my * sin(rotation);
  
  //decreases opacity of particle as it moves away from origin
  a -= 1;
}

void flicker(){
  a = random(255);
}


Boolean removeList(){

  //if the ball is totally transparent remove from the list
    if(a <= 10){
      return true;
    }
    else{
      return false;
    }
  }
  



void display() {
// Display the circle
fill(r, g, b, a);
ellipse(x,y,w,w);
}
}







class Firework {//class for the launching firework

float x;
float y;
float a; //alpha (transparency)
float w; //width of the firework
float my;
float r;
float g;
float b;
float c;

Firework(float tempX, float tempY, float tempW, float speedY, float red, float green, float blue) {

  //properties of the firework are set based on the effect and the parameters given
  x = tempX;
  y = tempY;
  w = tempW;
  a = 255;

  if (speedY == 0){//if no speed is given then chooses a random speed
    my = random(7,15);
  }
  else{//otherwise sets it to the speed given
  my = speedY;
  }
  
  if (red == 0 && blue == 0 && green == 0){//if no colour profile is given then selects a random one
    r = random(50, 255);
    g = random(120, 255);
    b = random(100, 255);
    
    if (r < 150 && g <150 && b < 150){//a check to make the colours more vibrant if dull
      r = 255;
    }
  }
  else{//otherwise sets it to the colour profile given
    r = red;
    g = green;
    b = blue;
  }


}


void Physics(){
  
  //applies gravity to the firework
   my -= 0.2;
  
}

void move(){//changes the y-position and decreases the opacity based on the y-velocity
  y -= my;
  a -= my/3;
    
}


Boolean removeList(){//firework is removed from list when its y-velocity is zero

    if(my <= 0){
      return true;
    }
    else{
      return false;
    }
  }
  



void display() {
// Display the circle
fill(r,g,b,a);
ellipse(x,y,w,w);
}
}

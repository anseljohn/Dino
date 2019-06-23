import java.util.*;
import processing.sound.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;

class Dino {
  PImage image;
  PVector position;
  float direction;
  PVector velocity;
  float jumpSpeed;
  float walkSpeed;
  Rectangle hitbox;
}

class Cactus {
  String fileLocation;
  float x;
  float y;
  boolean shown;
  Rectangle hitbox;
  
  Cactus(String loc, float x, float y, Rectangle hitbox) {
    fileLocation = loc;
    this.x = x;
    this.y = y;
    this.hitbox = hitbox;
    shown = false;
  }
  
  PImage getPImage() {
    return loadImage(fileLocation);  
  }
}

class Rectangle {
  float x1;
  float y1;
  float x2;
  float y2;
     
  Rectangle(float x1, float y1, float x2, float y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }
}

// GLOBAL VARIABLES
Dino dino;
Neuron distanceNeuron = new Neuron();
float up;
float cactusStartingX = 800;
boolean keepPlaying = true;
ArrayList<Cactus> shownCacti = new ArrayList();

float temp = 1000;

float gravity = .5;
float ground = 450;

int frame = 0;

int score = 0;
int highScore = 0;

SoundFile pastHighScore;
SoundFile past100;
SoundFile lost;
boolean pastHigh = false;
boolean firstRun = true;
boolean hasLost = false;

int generation = 0;

void setup()
{
  size(1000, 700);
  frameRate(60);
  keepPlaying = true;
  dino = new Dino();
  dino.image = loadImage("C:/Users/jjohn/Documents/PixelArt/Dinosaur.png");
  dino.position = new PVector(150, ground);
  dino.direction = 1;
  dino.velocity = new PVector(0, 0);
  dino.jumpSpeed = 11;
  dino.walkSpeed = 4;
  dino.hitbox = new Rectangle(dino.position.x - 80, dino.position.y - 40, 105, 75);
  shownCacti = new ArrayList();
  pastHighScore = new SoundFile(this, "../sounds/win.mp3");
  past100 = new SoundFile(this, "../sounds/100.mp3");
  lost = new SoundFile(this, "../sounds/lose.mp3");
  hasLost = false;
}

void draw()
{
  if (keepPlaying) {
    background(255);
      textSize(20);
  fill(0);
  text("Generation: " + generation, 800, 100);
    if (up == -1.0) {
      System.out.println("Jump!");  
    } else {
      System.out.println("Down!");  
    }
    if (shownCacti.size() > 0) {
      float distBetween = shownCacti.get(0).x - dino.position.x;
      if (distBetween <= 100 && distBetween >= 15) {
        distanceNeuron.train(distBetween, 1);  
      } else {
        distanceNeuron.train(distBetween, -1);  
      }
    }
    if (millis() % 2 == 0) {
      score++;
    }
    
    if (score > highScore) {
      if (!pastHigh && !firstRun) {
        pastHighScore.play();
        pastHigh = true;
      }
      highScore = score;
    }
    
    if (score % 100 == 0) {
      past100.play();  
    }
    
    textSize(20);
    fill(0);
    text("High Score: " + highScore + "  Score: " + score, 100, 100);
    updateNeurons();
    update();
    noFill();
    //rect(dino.hitbox.x1, dino.hitbox.y1, dino.hitbox.x2, dino.hitbox.y2);
    stroke(1);
    line(0, 485, 1000, 485);
    
    if (Math.random() <= .05 && frame >= 45 /*shownCacti.size() < 1*/) {
      Cactus cactus = new Cactus("C:/Users/jjohn/Documents/PixelArt/cactus0.png", temp, 473, new Rectangle(temp + 25, 423, 23, 62));
      cactus.shown = true;
      shownCacti.add(cactus);
      frame = 0;
    }
    for (int i = 0; i < shownCacti.size(); i++) {
      Cactus c = shownCacti.get(i);
      c.x -= 5;
      image(c.getPImage(), c.x, c.y);
      if (c.x <= -10) {
        shownCacti.remove(i);  
      }
    }
    
    for (Cactus c : shownCacti) {
      //rect(c.hitbox.x1, c.hitbox.y1, c.hitbox.x2, c.hitbox.y2);  
    }
    
    if (hitboxesIntersect()) {
      if (score > highScore) {
        highScore = score;
      }
      keepPlaying = false;  
    }
  } else {
    if (!hasLost) {
      lost.play();
      hasLost = true;
    }
    generation++;
    textSize(64); 
    fill(0, 102, 153);
    text("Game Over", width - 675, height/2);
    score = 0;
    firstRun = false;
    pastHigh = false;
    delay(1000);
    //distanceNeuron.train(shownCacti.get(0).x - dino.position.x, 1);
    reset();
  }
  frame++;
}

void update() {
  updateNeurons();
  if (dino.position.y < ground) {
    dino.velocity.y += gravity;
  } else {
    dino.velocity.y = 0; 
  }
  
  if (dino.position.y >= ground && up != 0) {
    dino.velocity.y = -dino.jumpSpeed;
  }
  
  PVector nextPosition = new PVector(dino.position.x, dino.position.y);
  nextPosition.add(dino.velocity);
  
  float offset = 0;
  if (nextPosition.y > offset && nextPosition.y < (height - offset)) {
    dino.position.y = nextPosition.y;
  } 
  
  updateHitboxes();
  
  pushMatrix();
  translate(dino.position.x, dino.position.y);
  scale(dino.direction, 1);
  imageMode(CENTER);
  image(dino.image, 0, 0);
  popMatrix();
  updateNeurons();
}

void updateNeurons() {
  if (shownCacti.size() >= 1) {
    up = distanceNeuron.guess(shownCacti.get(0).x - dino.position.x) * -1;
    if (up == 1) {
      up = 0;  
    }
    System.out.println("Guess: " + up + "\nInput: " + (shownCacti.get(0).x - dino.position.x));
  }
}

void updateHitboxes() {
  dino.hitbox = new Rectangle(dino.position.x - 35, dino.position.y - 40, 67, 75);
  for (Cactus c : shownCacti) {
    c.hitbox = new Rectangle(c.x + 25, 423, 23, 62);
  }
}

boolean hitboxesIntersect() {
  for (Cactus cactus : shownCacti) {
    if ((cactus.hitbox.x1 <= dino.hitbox.x1 + dino.hitbox.x2
        && cactus.hitbox.x1 >= dino.hitbox.x1
        && cactus.hitbox.y1 >= dino.hitbox.y1
        && cactus.hitbox.y1 <= dino.hitbox.y1 + dino.hitbox.y2)) {
      return true;
    }
  }
  return false;
}

void reset() {
  setup();  
}

void keyPressed() {
  if (key == ' ') {
    if (!keepPlaying) {
      delay(1000);
      reset();
    }
    up = -1;
  }
}

void keyReleased() {
  if (key == ' ') {
    up = 0;
  }
}

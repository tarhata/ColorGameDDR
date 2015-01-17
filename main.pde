/**
*
* Author: Tarhata Guiamelon
* Stroop Test DDR style
* MHCID Prototyping Studio Week 7
*
**/

// KEYBOARD CONTROLS

// ENTER = start
// 'q' = quit

// 'e' = easy mode
// 'm' = medium mode
// 'h' = hard mode

// 'r' = red
// 'g' = green
// 'b' = blue
// 'y' = yellow

import processing.serial.*;  
Serial myPort;
import ddf.minim.*;

Minim minim;
AudioPlayer player;
  
PFont f;
String colorWord = " ";
String [] colorList = {"BLUE", "RED", "YELLOW", "GREEN"};

int prevWord;

String soundFile = " ";
int tracker = 0;
int score = 0;
int currentColor = 0;

int startTime = 0;

int MAX = 10;  // Number of rounds to play
int GAMESPEED = 10000; // How many milliseconds between each round

boolean buttonPressed = false;
boolean gameOver = false;

color[] wordColors = new color[4];

int [] highScores ={};

void setup() {
//  Next two lines are for when this is connected to an arduino for LED feedback
//  myPort = new Serial(this, "COM3", 57600);
//  println(Serial.list());
  
  size(1280, 800 );
  
  // Create the font
  printArray(PFont.list());
  f = createFont("Trebuchet MS Bold", 25);
  textFont(f);
  
  // Create the wordColor array
  wordColors[0] = color(255, 0, 0); // Colored RED
  wordColors[1] = color(0, 255, 0); // Colored GREEN
  wordColors[2] = color(0, 0, 255); //Colored BLUE
  wordColors[3] = color(255, 255, 0); // Colored YELLOW
  
  // Create audio player
  minim = new Minim(this);
  
  //Stop looping of draw function
  noLoop();
  
}


void draw() {
  println("score = " + score);
  println("buttonPressed = " + buttonPressed);  
  println("tracker = " + tracker);
  background(0);
  textAlign(CENTER);  
  
  if (tracker == 0) {
    introScreen(width * 0.5);
      println("tracker = " + tracker);
      
  } else if (tracker == 1) { 
       loop();    
       setStart();
       println("tracker = " + tracker);
       
  } else if  (tracker > 1 && tracker < (MAX + 2)) {
    noLoop();
    drawWords(width * 0.5);
    
  } else if (tracker == (MAX + 2)) {
    gameOver = true;
    loop();
    scoreScreen(width * 0.5);
    
  } else if (tracker == (MAX + 3)) {
    delay(1500);    
    timeScreen(width * 0.5);    
    
  } else if (tracker == (MAX + 4)) {  
    delay(1500);
    endScreen(width * 0.5);
    
  } else {
    delay(1000);
    playAgain(width * 0.5);
    noLoop();
  }
}

void drawWords(float x) {
  textSize(200);
  background(255);
  textAlign(CENTER);
  buttonPressed = false;
  randWord();
  randColor();      
  text(colorWord, x, height * 0.5);
  tracker++;
  int currentTime = millis();
  int delay = GAMESPEED;
  int time = millis();
//    while(millis() - time <= delay){
//      if (buttonPressed == true) {
//      delay = 0;
//      redraw();
//      }
//   }
}
    
void randColor() {
  int index = int(random(wordColors.length));  // Same as int(random(4))
  if (index  == currentColor) {
    randColor();
  } else {
  fill(wordColors[index]);
  currentColor = index ;
  }
  println("index = " + index + "    current color = " + currentColor);
  }


void randWord() {
  int index = int(random(colorList.length));  // Same as int(random(4))
  if (index == prevWord) {
    randWord();
  } else {
    colorWord = (colorList[index]);  // Prints one of the four words
    prevWord = index;
  }
}

//void randSound() {
//  int index = int(random(colorList.length));  // Same as int(random(4))
//  if (index == prevSound) {
//    randSound();
//  } else {
//    soundFile = (colorList[index]) + ".wav";  // Prints one of the four words
////  soundFile = "TEST.mp3";
//    prevSound = index;
//  }
//    player = minim.loadFile(soundFile);
//    player.play();
//}

void setStart(){
  startTime = millis();
  println("start time = " + startTime);
  tracker++;
}

void introScreen(float x){
    fill (255, 255, 255);
    text("Step on the COLOR of the word. Press START to play", x, height * 0.5);
    tracker++;
    println(millis());
}

void scoreScreen(float x)  {
    textSize(25);
    background(255);
    fill (0, 0, 0);
    text("You got " + score + " out of " + MAX + " correct!", x, height * 0.5);
    tracker++;
}

void timeScreen(float x)  {
    int endTime = millis() - startTime;
    textSize(25);
    background(255);
    fill (0, 0, 0);
    text("Your time was " + (endTime/1000) + " seconds!", x, height * 0.5);
    tracker++;
}

void endScreen(float x){
    textSize(25);
    background(255);
    fill (0, 0, 0);
    text("Thanks for playing!", x, height * 0.5);
    tracker++;
}

void playAgain(float x){
    background(255);
    fill(96, 96, 96);
    text("Step on SELECT to play again", x, height * 0.5);
}

void ansCorrect(){
    score++;
    player = minim.loadFile("right.wav");
    player.play();
    buttonPressed = true;
    redraw();
}


void keyPressed() {
  if (key == ENTER && (tracker < 3 || tracker > MAX + 1)) { // move to to next screen during non-color screens
    background(0);
    redraw();
    
  } else if (key == 'q') {  //restart game
    background(0);
    tracker = 0;
    textSize(25);
    gameOver = false; 
    score = 0;  
    redraw();
    
  } else if (key == 'r'  && tracker <2  ) {  //RED
//    myPort.write(1);
    player = minim.loadFile("RED.wav");
    player.play();
  } else if (key == 'g' && tracker <2 ) {  //GREEN
//    myPort.write(2);
    player = minim.loadFile("GREEN.wav");
    player.play();
  } else if (key == 'b'  && tracker <2) {    //BLUE
//    myPort.write(3);    
    player = minim.loadFile("BLUE.wav");
    player.play();  
  } else if (key == 'y'  && tracker <2) {   //YELLOW
//    myPort.write(4);  
    player = minim.loadFile("YELLOW.wav");
    player.play();    
    
  } else if (key == 'r' && currentColor == 0) {
//    myPort.write(1);
    ansCorrect();
  } else if (key == 'g' && currentColor == 1) {
//    myPort.write(2);
    ansCorrect();
  } else if (key == 'b' && currentColor == 2) {
//    myPort.write(3);
    ansCorrect();  
  } else if (key == 'y' && currentColor == 3) {
//    myPort.write(4);
    ansCorrect();
  } else if (tracker > 1 && gameOver == false) {
    player = minim.loadFile("wrong.wav");
    player.play();
    buttonPressed = true;
//    myPort.write(10); 
    redraw();   
  } 
}


void delay(int delay) {
  int time = millis();
  while(millis() - time <= delay);
}

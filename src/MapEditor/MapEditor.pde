/*******************************************************
 
 Map Editor "Defense Mania"
 
 Bachelorarbeit von Kris Siepert - Sommersemester 2012
 Studiengang Medienproduktion & Medientechnik an der Hochschule für angewandte Wissenschaften Amberg-Weiden
 
 Kommentare des Programm-Codes sind auf Englisch verfasst.
 
 *******************************************************/

import controlP5.*;
import java.awt.*;
import java.io.*;

/*******************************************************
 
 Global variables
 
 *******************************************************/

/*
General vars
 */
String frameTitle = "DefenseMania Map Editor v0.8b";
Insets insets;
int screenId = 0;
PGraphics saveGraphics;
boolean waypointsShow;
int[][] globalWaypoints;
float centerY = 0;
float scrollCount = 0;
float scrollStart = 0;

/*
Game vars
 */
int gameMoney;
int gameLifes;
int enemyTileSize;
int towerTileSize;
int enemyGlobalId = 1;
ArrayList Enemies;
ArrayList Towers;
ArrayList Waves;
ENEMY editEnemy;
WAVE editWave;
TOWER editTower;
boolean addEnemy = false;
boolean addWave = false;
boolean addTower = false;

/*
Interface colors
 */

//Highlight
int[] iColor = {
  0, 153, 255
}; 
//Background
int[] iColor2 = {
  255, 255, 255
}; 
//Contrast
int[] iColor3 = {
  0, 0, 0
};
int gridAlpha = 80;

/*
General settings
 */

int tileSize = 48;
int[] mapSize = {
  20, 15
};
int[] worldOffset = {
  0, 75
};
int[][][][] tileMap = new int[3][mapSize[0]][mapSize[1]][2];
int EMPTY = -1;
int editorLevel = 1;
PImage[] thirdLevelArray;
PImage[][] tileArray;

/*
Cursor Settings
 */

int[] cursorPos = new int[2];
boolean cursorActive = false;
//Show cursor in editor window
boolean showCursor = true;

/*
Tileset Stuff
 */

String tilesetFileActive = "";
PImage tilesetImage;
int[] tileActive = {
  0, 0
};
int[] tilesetWindowSize = { 
  10, 10
};
PImage thirdLevelImage;
tileSetApplet theTileSetApplet;
tileSetFrame theTileSetFrame;

/*
Buttons
 */
ControlP5 cp5;
ArrayList enemyControls;
ArrayList towerControls;
ArrayList overviewControls;
ArrayList waveControls;
ArrayList towerUpdate1Controls;
ArrayList towerUpdate2Controls;

/*******************************************************
 
 Setup
 
 *******************************************************/

void setup() {

  //Stuff
  size(mapSize[0]*tileSize+worldOffset[0], mapSize[1]*tileSize+worldOffset[1], JAVA2D);  
  insets = frame.getInsets(); 
  theTileSetFrame = new tileSetFrame();
  thirdLevelImage = loadImage("icons.png");
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);  
  noLoop();
  changeFrameTitle();

  //Make tileMap empty
  for (int h = 0; h < 3; h++) {
    for (int i = 0; i < mapSize[0]; i++) {
      for (int j = 0; j < mapSize[1]; j++) {
        tileMap[h][i][j][0] = EMPTY;
        tileMap[h][i][j][1] = EMPTY;
      }
    }
  }

  //Create image-array for the third-level
  thirdLevelArray = new PImage[6];
  for (int i = 0; i < 6; i++) {
    thirdLevelArray[i] = thirdLevelImage.get(i*thirdLevelImage.height, 0, thirdLevelImage.height, thirdLevelImage.height);
  }

  //Some arraylists
  Enemies = new ArrayList();
  Towers = new ArrayList();
  Waves = new ArrayList();
  overviewControls = new ArrayList();
  enemyControls = new ArrayList();
  towerControls = new ArrayList();
  waveControls = new ArrayList();
  towerUpdate1Controls = new ArrayList();
  towerUpdate2Controls = new ArrayList();

  //Add all the beautiful buttons
  addButtons();
}


/*******************************************************
 
 Draw the Editor
 
 *******************************************************/

void draw() {

  pushMatrix();
  translate(0, centerY);

  //Switch between the different screens
  switch(screenId) {

    /*
Editor
     */
  case 0:
    //Draw background
    background(iColor2[0], iColor2[1], iColor2[2]);

    //Draw tiles
    for (int h = 0; h < 2; h++) {
      for (int i = 0; i < mapSize[0]; i++) {
        for (int j = 0; j < mapSize[1]; j++) {
          if (tileMap[h][i][j][0] != EMPTY && tileMap[h][i][j][1] != EMPTY) {
            if (tileArray != null && tileArray[0][0] != null) {
              image(tileArray[tileMap[h][i][j][0]][tileMap[h][i][j][1]], i*tileSize+worldOffset[0], j*tileSize+worldOffset[1]);
            }
          }
        }
      }
    }  

    //Draw grid
    if (editorLevel != 2) {  
      for (int i = 0; i < mapSize[0]; i++) {
        for (int j = 0; j < mapSize[1]; j++) {
          noFill();
          stroke(iColor3[0], iColor3[1], iColor3[2], gridAlpha);
          rect(i*tileSize+worldOffset[0], j*tileSize+worldOffset[1], tileSize, tileSize);
        }
      }
    }

    //Make tiles brighter for the 3rd editor level
    if (editorLevel == 3) {
      noStroke();
      fill(iColor2[0], iColor2[1], iColor2[2], 100);
      rect(worldOffset[0], worldOffset[1], mapSize[0]*tileSize, mapSize[1]*tileSize);
    }

    //Draw 3rd level
    for (int i = 0; i < mapSize[0]; i++) {
      for (int j = 0; j < mapSize[1]; j++) {
        if (tileMap[2][i][j][0] != EMPTY && tileMap[2][i][j][1] != EMPTY) {
          tint(255, 100);
          image(thirdLevelArray[tileMap[2][i][j][0]], i*tileSize+worldOffset[0], j*tileSize+worldOffset[1], tileSize, tileSize);
          noTint();
        }
      }
    }

    //Draw Waypoints
    if (globalWaypoints != null && waypointsShow == true) {
      for (int i = 0; i < globalWaypoints.length; i++) {
        fill(iColor[0], iColor[1], iColor[2]);
        noStroke();
        ellipse(globalWaypoints[i][0]+worldOffset[0], globalWaypoints[i][1]+worldOffset[1], 5, 5);
        if (i != 0) {
          stroke(iColor[0], iColor[1], iColor[2]);
          line(globalWaypoints[i-1][0]+worldOffset[0], globalWaypoints[i-1][1]+worldOffset[1], globalWaypoints[i][0]+worldOffset[0], globalWaypoints[i][1]+worldOffset[1]);
        }
      }
    }

    //Draw cursor
    if (cursorActive == true && showCursor == true) {
      fill(iColor[0], iColor[1], iColor[2], 40);
      stroke(iColor[0], iColor[1], iColor[2], 100);
      rect(cursorPos[0]*tileSize+worldOffset[0], cursorPos[1]*tileSize+worldOffset[1], tileSize, tileSize);
    }
    break;

    /*
    Enemies & Towers : Overview
     */
  case 1:
    background(iColor2[0], iColor2[1], iColor2[2]);

    //Show enemies
    for (int i = 0; i < Enemies.size(); i++) {
      ENEMY temp = (ENEMY) Enemies.get(i);

      //Draw some text
      textFont(createFont("Arial", 12));
      fill(iColor3[0], iColor3[1], iColor3[2]);
      textAlign(LEFT);
      text(temp.id + "", (width/6)-60, worldOffset[1] + 110 + i*60);        
      text("Maxhealth: " + temp.maxhealth, (width/6)+20, worldOffset[1] + 130 + i*60); 

      //Reset the position of the buttons
      temp.editButton.setPosition((width/6)+20, worldOffset[1] + 80 + i*60 + centerY);
      temp.deleteButton.setPosition((width/6)+20, worldOffset[1] + 100 + i*60 + centerY);

      //Draw the icon or a rect
      if (temp.iconImage != null) {
        image(temp.iconImage, (width/6)-40, worldOffset[1] + 80 + i*60, 50, 50);
      } 
      else {
        fill(iColor[0], iColor[1], iColor[2]);
        noStroke();
        rect((width/6)-40, worldOffset[1] + 80 + i*60, 50, 50);
      }
    }

    //Show Waves
    for (int i = 0; i < Waves.size(); i++) {      
      WAVE temp = (WAVE) Waves.get(i);

      //Draw the text
      textFont(createFont("Arial", 12));
      fill(iColor3[0], iColor3[1], iColor3[2]);
      textAlign(LEFT);
      text((i+1) + "", (3*width/6)-60, worldOffset[1] + 100 + i*60);
      textFont(createFont("Arial", 10));
      for (int j = 0; j < temp.waveEnemies.size(); j++) {
        ENEMIES temp2 = (ENEMIES) temp.waveEnemies.get(j);              
        text("Enemy #"+temp2.theEnemy.id+" - "+temp2.number+"x", (3*width/6)+35, worldOffset[1] + 88 + i*60 + j*15);
      }

      //Reset the position of the buttons
      temp.editButton.setPosition((3*width/6)-40, worldOffset[1] + 80 + i*60 + centerY);
      temp.deleteButton.setPosition((3*width/6)-40, worldOffset[1] + 100 + i*60 + centerY);
    }

    //Show Towers
    for (int i = 0; i < Towers.size(); i++) {
      TOWER temp = (TOWER) Towers.get(i);

      //Draw some text
      textFont(createFont("Arial", 12));
      fill(iColor3[0], iColor3[1], iColor3[2]);
      textAlign(LEFT);
      text((i+1) + "", 5*(width/6)-60, worldOffset[1] + 110 + i*60);         

      //Reset the position of the buttons
      temp.editButton.setPosition(5*(width/6)+20, worldOffset[1] + 80 + i*60 + centerY);
      temp.deleteButton.setPosition(5*(width/6)+20, worldOffset[1] + 100 + i*60 + centerY);

      //Draw the icon or a rect
      if (temp.iconImage != null) {
        image(temp.iconImage, 5*(width/6)-40, worldOffset[1] + 80 + i*60, 50, 50);
      } 
      else {        
        fill(iColor[0], iColor[1], iColor[2]);
        noStroke();
        rect(5*(width/6)-40, worldOffset[1] + 80 + i*60, 50, 50);
      }
    }
    noFill();
    break;

    /*
   Add & edit enemy
     */
  case 2:
    background(iColor2[0], iColor2[1], iColor2[2]);
    noFill();
    stroke(iColor3[0], iColor3[1], iColor3[2]);

    //Show the images or rects
    if (editEnemy.charsetImage != null) {
      image(editEnemy.charsetImage, width-300, worldOffset[1]+50, 200, 200*((float) editEnemy.charsetImage.height) / (float) editEnemy.charsetImage.width);
    } 
    else {
      rect(width-300, worldOffset[1]+50, 200, 400);
    }
    if (editEnemy.iconImage != null) {
      image(editEnemy.iconImage, width-360, worldOffset[1]+50, 50, 50);
    } 
    else {
      rect(width-360, worldOffset[1]+50, 50, 50);
    }
    break;

    /*
    Add & edit Tower
     */
  case 3:
    background(iColor2[0], iColor2[1], iColor2[2]);

    stroke(iColor3[0], iColor3[1], iColor3[2]);

    //Show the images or rects
    if (editTower.charsetImage != null) {
      image(editTower.charsetImage, width-300, worldOffset[1]+50, 200, 200*((float) editTower.charsetImage.height) / (float) editTower.charsetImage.width);
    } 
    else {
      rect(width-300, worldOffset[1]+50, 200, 400);
    }
    if (editTower.iconImage != null) {
      image(editTower.iconImage, width-360, worldOffset[1]+50, 50, 50);
    } 
    else {
      rect(width-360, worldOffset[1]+50, 50, 50);
    }

    break;

    /*
    Add & edit wave
     */
  case 4:
    background(iColor2[0], iColor2[1], iColor2[2]);

    //Show enemies
    for (int i = 0; i < Enemies.size(); i++) {
      ENEMY temp = (ENEMY) Enemies.get(i);

      textFont(createFont("Arial", 12));
      fill(iColor3[0], iColor3[1], iColor3[2]);
      textAlign(LEFT);
      text(temp.id + "", width-360, worldOffset[1] + 110 + i*60);        
      text("Maxhealth: " + temp.maxhealth, width-280, worldOffset[1] + 130 + i*60);
      text("Damage: " + temp.damage, width-280, worldOffset[1] + 115 + i*60); 

      temp.waveSlider.setPosition(width-280, worldOffset[1] + 80 + i*60 + centerY);
      temp.waveCheckbox.setPosition(width-400, worldOffset[1] + 95 + i*60 + centerY);

      if (temp.iconImage != null) {
        image(temp.iconImage, width-340, worldOffset[1] + 80 + i*60, 50, 50);
      } 
      else {
        fill(iColor[0], iColor[1], iColor[2]);
        noStroke();
        rect(width-340, worldOffset[1] + 80 + i*60, 50, 50);
      }
    }
    break;
  }
  popMatrix();
  cp5.draw();
}


/*******************************************************
 
 Mouse moving
 
 *******************************************************/

void mouseDragged() {

  if (mouseButton == RIGHT && screenId != 0) {
    scrollEditor((mouseX-pmouseX)*0.7, (mouseY-pmouseY)*0.7);
  }
}

void mouseMoved() {

  //Cursor position update
  if (mouseX > worldOffset[0] && mouseY > worldOffset[1]) {
    cursorActive = true;
    if (screenId != 0) {
      loop();
    } 
    else {
      noLoop();
    }

    int cursorPosTemp_x = (mouseX - worldOffset[0] - ((mouseX-worldOffset[0]) % tileSize)) / tileSize;
    int cursorPosTemp_y = (mouseY - worldOffset[1] - ((mouseY-worldOffset[1]) % tileSize)) / tileSize;

    //Check if cursor position changed
    if (cursorPos[0] != cursorPosTemp_x || cursorPos[1] != cursorPosTemp_y) {      
      cursorPos[0] = cursorPosTemp_x;
      cursorPos[1] = cursorPosTemp_y;
      if (showCursor == true) {
        redraw();
      }
    }
  } 
  else {
    cursorActive = false;
    loop();
  }
}

/*******************************************************
 
 Mouse clicking
 
 *******************************************************/

void mouseClicked() {

  //Set a tile in the editor window  
  if (mouseX > worldOffset[0] && mouseY > worldOffset[1] && tilesetFileActive != "" && screenId == 0) {
    setTile();
  }
}


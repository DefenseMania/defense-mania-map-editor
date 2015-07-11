/*******************************************************
 
 Create the tile-image-array
 
 *******************************************************/

void createTileArray() {
  if (tilesetImage != null) {
    tileArray = new PImage[tilesetWindowSize[0]][tilesetWindowSize[1]];
    for (int i = 0; i < tilesetWindowSize[0]; i++) {
      for (int j = 0; j < tilesetWindowSize[1]; j++) {
        tileArray[i][j] = tilesetImage.get(i*tileSize, j*tileSize, tileSize, tileSize);
      }
    }
  }
}

/*******************************************************
 
 Update Controller Values
 
 *******************************************************/

void updateControllers() { 
  Controller c;
  c = cp5.getController("gameMoney");
  c.setValue(gameMoney);
  c = cp5.getController("gameLifes");
  c.setValue(gameLifes);

  c = cp5.getController("mapTileSize");
  c.setValue(tileSize);
}

/*******************************************************
 
 Change Tileset
 
 *******************************************************/

void changeTileset(File selection) {
  if (selection != null) {
    tilesetFileActive = selection.getAbsolutePath();
    tilesetImage = loadImage(tilesetFileActive);
    theTileSetApplet.setSize(tilesetImage.width, tilesetImage.height);
    theTileSetFrame.setSize(tilesetImage.width + insets.left + insets.right, tilesetImage.height + insets.top + insets.bottom);
    tilesetWindowSize[0] = int(((tilesetImage.width - (tilesetImage.width%tileSize)) / tileSize) + 1);
    tilesetWindowSize[1] = int(((tilesetImage.height - (tilesetImage.height%tileSize)) / tileSize) + 1);
    createTileArray();
    theTileSetApplet.redraw();
  }
}

/*

 */

/*******************************************************
 
 Change Editorlevel
 
 *******************************************************/

void changeEditorLevel(int id) {
  if (id == 3) {
    theTileSetApplet.setSize(tileSize*6, tileSize);
    theTileSetFrame.setSize(tileSize*6 + insets.left + insets.right, tileSize + insets.top + insets.bottom);
    tilesetWindowSize[0] = 6;
    tilesetWindowSize[1] = 1;
    editorLevel = 3;
  } 
  else {
    if (editorLevel == 3 && tilesetFileActive != "") {
      changeTileset(new File(tilesetFileActive));
    }    
    editorLevel = id;
  }
  changeFrameTitle();
  theTileSetApplet.redraw();
}

/*******************************************************
 
 Set a tile
 
 *******************************************************/

void setTile() {
  tileMap[editorLevel-1][cursorPos[0]][cursorPos[1]][0] = tileActive[0];
  tileMap[editorLevel-1][cursorPos[0]][cursorPos[1]][1] = tileActive[1];
  redraw();
}

/*******************************************************
 
 Redraw the whole Window
 
 *******************************************************/

void completeRedraw() {
  frame.setResizable(true);
  frame.setSize((tileSize*mapSize[0])+worldOffset[0] + insets.left + insets.right, (tileSize*mapSize[1])+worldOffset[1] + insets.top + insets.bottom);
  this.setSize((tileSize*mapSize[0])+worldOffset[0], (tileSize*mapSize[1])+worldOffset[1]);
  frame.setResizable(false);  
  redraw();
  if (editorLevel == 3) {
    theTileSetApplet.setSize(tileSize*6, tileSize);
    theTileSetFrame.setSize(tileSize*6 + insets.left + insets.right, tileSize + insets.top + insets.bottom);
  }
  theTileSetApplet.redraw();
  createTileArray();
  changeFrameTitle();
}

/*******************************************************
 
 Make the tilemap empty when mapsize is changed
 
 *******************************************************/

void mapSizeChanged() { 

  int[][][][] tileMapTemp = tileMap;

  tileMap = new int[3][mapSize[0]][mapSize[1]][2];
  for (int h = 0; h < 3; h++) {
    for (int i = 0; i < mapSize[0]; i++) {
      for (int j = 0; j < mapSize[1]; j++) {
        tileMap[h][i][j][0] = EMPTY;
        tileMap[h][i][j][1] = EMPTY;
      }
    }
  }

  int lengthi = 0;
  int lengthj = 0;

  if (tileMap[0].length > tileMapTemp[0].length) {
    lengthi = tileMapTemp[0].length;
  } 
  else {
    lengthi = tileMap[0].length;
  }

  if (tileMap[0][0].length > tileMapTemp[0][0].length) {
    lengthj = tileMapTemp[0][0].length;
  } 
  else {
    lengthj = tileMap[0][0].length;
  }

  for (int h = 0; h < 3; h++) {
    for (int i = 0; i < lengthi; i++) {
      for (int j = 0; j < lengthj; j++) {
        tileMap[h][i][j][0] = tileMapTemp[h][i][j][0];
        tileMap[h][i][j][1] = tileMapTemp[h][i][j][1];
      }
    }
  }  

  completeRedraw();
}

/*******************************************************
 
 Change frame title
 
 *******************************************************/

void changeFrameTitle() {
  frame.setTitle(frameTitle + " - Level " + editorLevel + " - " + mapSize[0] + "x" + mapSize[1] + " @" + tileSize + "px");
}

/*******************************************************
 
 Serialization method
 
 *******************************************************/

//Serialize one level of the map structure into a string for saving
String serializeMap(int ilevel) {

  StringBuffer output = new StringBuffer("");

  for (int i = 0; i < mapSize[0]; i++) {

    for (int j = 0; j < mapSize[1]; j++) {

      output.append(tileMap[ilevel][i][j][0] + "," + tileMap[ilevel][i][j][1]);
      if (j != mapSize[1]-1) { 
        output.append("#");
      }
    }

    if (i != mapSize[0]-1) { 
      output.append("_");
    }
  }

  return output.toString();
}


//Unserialize a string into an array
int[][][] unserializeMap(String istring, int mapSize_x, int mapSize_y) {

  String[] array_x = istring.split("_");
  int[][][] returnMe = new int[mapSize_x][mapSize_y][2];

  for (int i = 0; i < array_x.length; i++) {

    String[] array_y = array_x[i].split("#");

    for (int j = 0; j < array_y.length; j++) {

      String[] tiles = array_y[j].split(",");
      returnMe[i][j][0] = Integer.parseInt(tiles[0]);
      returnMe[i][j][1] = Integer.parseInt(tiles[1]);
    }
  }

  return returnMe;
}


/*******************************************************
 
 Copy files
 
 *******************************************************/

void copyFile(String inString, String outString) throws Exception {

  //Files
  File in = new File(inString);
  File out = new File(outString);

  //Streams
  FileInputStream fis  = new FileInputStream(in);
  FileOutputStream fos = new FileOutputStream(out);
  byte[] buf = new byte[1024];
  int i = 0;

  //Write Inputstream in Outputstream
  while ( (i=fis.read (buf))!=-1) {
    fos.write(buf, 0, i);
  }

  fis.close();
  fos.close();
}


/*******************************************************
 
 Deleting a directory
 
 *******************************************************/

boolean deleteDir(File dir) {
  if (dir.isDirectory()) {
    String[] children = dir.list();
    for (int i=0; i<children.length; i++) {
      boolean success = deleteDir(new File(dir, children[i]));
      if (!success) {
        return false;
      }
    }
  }

  return dir.delete();
}



/*******************************************************
 
 Show or hide controls
 
 *******************************************************/

void showControls(ArrayList controlList, boolean showMe) {
  for (int i = 0; i < controlList.size(); i++) {
    if ((Object) controlList.get(i) instanceof Controller) {
      Controller temp = (Controller) controlList.get(i); 
      temp.setVisible(showMe);
      temp.setLock(!showMe);
    } 
    else if ((Object) controlList.get(i) instanceof DropdownList) {
      DropdownList temp = (DropdownList) controlList.get(i); 
      temp.setVisible(showMe);
    }
  }
}



/*******************************************************
 
 Style the Buttons
 
 *******************************************************/

public void styleButton(String buttonName) {
  Controller c = cp5.getController(buttonName);
  c.setColorBackground(color(iColor[0], iColor[1], iColor[2], gridAlpha));
  c.setColorCaptionLabel(color(iColor2[0], iColor2[1], iColor2[2]));
  c.getCaptionLabel().toUpperCase(false);
  c.getCaptionLabel().alignY(1);
  c.getCaptionLabel().setPadding(5, 15);
  c.getCaptionLabel().setFont(createFont("Verdana", 10));
}

public void styleSlider(String buttonName) {
  Controller c = cp5.getController(buttonName);
  c.setColorCaptionLabel(color(iColor3[0], iColor3[1], iColor3[2]));
  c.setHeight(15);
}

public void nameSlider(String buttonName, String buttonText) {
  Controller c = cp5.getController(buttonName);
  c.getCaptionLabel().setText(buttonText);
}

public void styleTextfield(String buttonName) {
  Controller c = cp5.getController(buttonName);
  c.setColorCaptionLabel(color(iColor3[0], iColor3[1], iColor3[2]));
  c.setColorBackground(color(iColor[0], iColor[1], iColor[2], gridAlpha));
  c.getCaptionLabel().toUpperCase(false);
  c.getCaptionLabel().setFont(createFont("Verdana", 10));
  c.getCaptionLabel().style().marginTop = -5;
}

public void styleToggle(String buttonName) {
  Controller c = cp5.getController(buttonName);
  c.setColorBackground(color(iColor[0], iColor[1], iColor[2], gridAlpha));
  c.setColorCaptionLabel(color(iColor3[0], iColor3[1], iColor3[2]));
  c.getCaptionLabel().toUpperCase(false);  
  c.getCaptionLabel().setFont(createFont("Verdana", 10));
  c.getCaptionLabel().style().marginTop = -19;
  c.getCaptionLabel().style().marginLeft = 20;
}


/*******************************************************
 
 Copy an image file into the temp-dir
 
 *******************************************************/


String copyImageTemp(String input, String output) { 
  try {
    copyFile(input, System.getProperty("java.io.tmpdir") + output);
  } 
  catch (Exception e) {
    println( "Error occured at:" );
    e.printStackTrace();
  }     
  return System.getProperty("java.io.tmpdir") + output;
}


/*******************************************************
 
 Scroll in the Editorwindow
 
 *******************************************************/

void scrollEditor(float x, float y) {
  centerY += y;
  if (centerY > 0) { 
    centerY = 0;
  }

  scrollCount += y;
  if (scrollCount > 0) {
    scrollCount = 0;
    y = -scrollStart;
  } 

    for (int i = 0; i < overviewControls.size(); i++) {      
      Controller c = (Controller) overviewControls.get(i);
      PVector p = c.getPosition();
      PVector new_p = new PVector(p.x, p.y+ y);
      c.setPosition(new_p);
    }
    for (int i = 0; i < towerControls.size(); i++) {
      Controller c = (Controller) towerControls.get(i);
      PVector p = c.getPosition();
      PVector new_p = new PVector(p.x, p.y+ y);
      c.setPosition(new_p);
    }
    for (int i = 0; i < enemyControls.size(); i++) {
      Controller c = (Controller) enemyControls.get(i);
      PVector p = c.getPosition();
      PVector new_p = new PVector(p.x, p.y+ y);
      c.setPosition(new_p);
    }
    for (int i = 0; i < waveControls.size(); i++) {
      Controller c = (Controller) waveControls.get(i);
      PVector p = c.getPosition();
      PVector new_p = new PVector(p.x, p.y+ y);
      c.setPosition(new_p);
    }
    scrollStart += y;  
}

void resetScroll() {
  for (int i = 0; i < overviewControls.size(); i++) {
    Controller c = (Controller) overviewControls.get(i);
    PVector p = c.getPosition();
    PVector new_p = new PVector(p.x, p.y-scrollCount);
    c.setPosition(new_p);
  }
  for (int i = 0; i < towerControls.size(); i++) {
    Controller c = (Controller) towerControls.get(i);
    PVector p = c.getPosition();
    PVector new_p = new PVector(p.x, p.y-scrollCount);
    c.setPosition(new_p);
  }
  for (int i = 0; i < enemyControls.size(); i++) {
    Controller c = (Controller) enemyControls.get(i);
    PVector p = c.getPosition();
    PVector new_p = new PVector(p.x, p.y-scrollCount);
    c.setPosition(new_p);
  }
  for (int i = 0; i < waveControls.size(); i++) {
    Controller c = (Controller) waveControls.get(i);
    PVector p = c.getPosition();
    PVector new_p = new PVector(p.x, p.y-scrollCount);
    c.setPosition(new_p);
  }
  centerY = 0;
  scrollCount = 0;
}

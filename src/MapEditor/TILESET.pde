/*******************************************************
 
 tileset window
 
 *******************************************************/

/*

 Create a new frame and start a new Applet inside
 
 */

public class tileSetFrame extends Frame {
  public tileSetFrame() {
    setBounds(0, 0, tileSize*tilesetWindowSize[0], tileSize*tilesetWindowSize[1]);
    this.setResizable(false);
    theTileSetApplet = new tileSetApplet();
    add(theTileSetApplet);
    theTileSetApplet.init();    
    show();
  }
}


/*

 A new applet
 
 */

public class tileSetApplet extends PApplet {

  public void setup() {
    size(tileSize*tilesetWindowSize[0], tileSize*tilesetWindowSize[1]);
    noLoop();
  }

  public void draw() {

    //Draw background
    background(iColor2[0], iColor2[1], iColor2[2]);

    //Draw tileset
    if (tilesetFileActive != "" && tilesetImage != null) {
      image(tilesetImage, 0, 0);
    }

    //"Tileset" for 3rd editor level
    if (editorLevel == 3) {
      background(iColor2[0], iColor2[1], iColor2[2]);
      image(thirdLevelImage, 0, 0, 6*tileSize, tileSize);
    }

    //Draw grid
    for (int i = 0; i < tilesetWindowSize[0]; i++) {
      for (int j = 0; j < tilesetWindowSize[1]; j++) {
        noFill();
        stroke(iColor3[0], iColor3[1], iColor3[2], 80);
        rect(i*tileSize, j*tileSize, tileSize, tileSize);
      }
    }

    //Draw cursor
    fill(iColor[0], iColor[1], iColor[2], 40);
    stroke(iColor[0], iColor[1], iColor[2]);
    rect(tileActive[0]*tileSize, tileActive[1]*tileSize, tileSize, tileSize);
  }

  void mouseClicked() {

    //Select tile
    tileActive[0] = (mouseX - (mouseX % tileSize)) / tileSize;
    tileActive[1] = (mouseY - (mouseY % tileSize)) / tileSize;

    //REDRAW
    redraw();
  }
}


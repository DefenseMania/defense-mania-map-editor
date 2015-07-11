/*******************************************************
 
 Save a map file
 
 *******************************************************/

void saveMapFile(File selection) {  

  noLoop();

  if (selection != null) {  
    //Check if the directory exists, delete it and create a new one
    boolean okLetsGo = false;
    boolean mapDirectory = new File(selection.getAbsolutePath()).exists();
    if (mapDirectory == true) {
      boolean deleteFile = deleteDir(new File(selection.getAbsolutePath()));
      if (deleteFile == true) {
        mapDirectory = new File(selection.getAbsolutePath()).mkdir();
        okLetsGo = true;
      }
    } 
    else {
      //Map file doesnt exists - create directory
      mapDirectory = new File(selection.getAbsolutePath()).mkdir();
      okLetsGo = true;
    }
    if (okLetsGo == true) {

      //create an image of the whole map
      saveGraphics = createGraphics(mapSize[0]*tileSize, mapSize[1]*tileSize);
      saveGraphics.beginDraw();
      for (int h = 0; h < 2; h++) {
        for (int i = 0; i < mapSize[0]; i++) {
          for (int j = 0; j < mapSize[1]; j++) {
            if (tileMap[h][i][j][0] != EMPTY && tileMap[h][i][j][1] != EMPTY) {
              if (tileArray != null) {
                saveGraphics.image(tileArray[tileMap[h][i][j][0]][tileMap[h][i][j][1]], i*tileSize, j*tileSize);
              }
            }
          }
        }
      }
      saveGraphics.endDraw();



      boolean dataDirectory = new File(selection.getAbsolutePath() + "/data").mkdir();
      if (tilesetFileActive != "") {
        //Copy tileset
        String[] extension = tilesetFileActive.split("\\.");     
        try {
          copyFile(tilesetFileActive, selection.getAbsolutePath() + "/data/tileset." + extension[extension.length-1]);
        } 
        catch (Exception e) {
          println( "Error occured at:" );
          e.printStackTrace();
        }  
        //Save Map as XML
        String[] linesToWrite = new String[11];
        linesToWrite[0] = "<?xml version='1.0'?>";
        linesToWrite[1] = "  <maptree>";
        linesToWrite[2] = "    <levels>";

        for (int i=0;i<3;i++) {
          linesToWrite[i+3] = "      <level id='"+(i)+"'>" + serializeMap(i) + "</level>";
        }

        linesToWrite[6] = "    </levels>";
        linesToWrite[7] = "    <mapsize w='" + mapSize[0] + "' h='" + mapSize[1] + "'></mapsize>";
        linesToWrite[8] = "    <tilesize s='" + tileSize + "'></tilesize>";
        linesToWrite[9] = "    <game lifes='" + gameLifes + "' startmoney='" + gameMoney + "'></game>";
        linesToWrite[10] = "  </maptree>";      

        saveStrings(selection.getAbsolutePath() + "/maptree.xml", linesToWrite);

        //Generate & save waypoints
        String[] wayPointArray = createWaypoints();
        linesToWrite = new String[wayPointArray.length+5];
        linesToWrite[0] = "<?xml version='1.0'?>";
        linesToWrite[1] = "  <pathfinding>";
        linesToWrite[2] = "    <waypoints>";

        for (int i=0;i<wayPointArray.length;i++) {
          linesToWrite[i+3] = "      <waypoint id='"+(i)+"'>" + wayPointArray[i] + "</waypoint>";
        }

        linesToWrite[wayPointArray.length+3] = "    </waypoints>";
        linesToWrite[wayPointArray.length+4] = "  </pathfinding>";

        saveStrings(selection.getAbsolutePath() + "/waypoints.xml", linesToWrite);

        //Save enemies & waves
        ArrayList wavesToWrite = new ArrayList();
        wavesToWrite.add( "<?xml version='1.0'?>" );
        wavesToWrite.add( "  <enemies>" );
        wavesToWrite.add( "    <waves>");

        for (int i = 0; i < Waves.size(); i++) {
          WAVE temp = (WAVE) Waves.get(i);
          wavesToWrite.add( "      <wave enemydistance='"+ temp.enemyDistance +"'>" );
          for (int j = 0; j < temp.waveEnemies.size(); j++) {
            ENEMIES temp2 = (ENEMIES) temp.waveEnemies.get(j);
            String[] charSetFile = temp2.theEnemy.charset.split("/");
            String[] iconFile = temp2.theEnemy.icon.split("/");

            try {
              copyFile(temp2.theEnemy.charset, selection.getAbsolutePath() + "/data/" + charSetFile[charSetFile.length-1]);
            } 
            catch (Exception e) {
              println( "Error occured at:" );
              e.printStackTrace();
            }            
            try {
              copyFile(temp2.theEnemy.icon, selection.getAbsolutePath() + "/data/" + iconFile[iconFile.length-1]);
            } 
            catch (Exception e) {
              println( "Error occured at:" );
              e.printStackTrace();
            }            
            wavesToWrite.add( "        <enemy id='"+ temp2.theEnemy.id +"' charset='"+ charSetFile[charSetFile.length-1] +"' icon='"+ iconFile[iconFile.length-1] +"' tilesize='"+ enemyTileSize +"' maxhealth='"+ temp2.theEnemy.maxhealth +"' money='"+ temp2.theEnemy.money +"' movespeed='"+ temp2.theEnemy.movespeed +"' animationspeed='"+ temp2.theEnemy.animationspeed +"' damage='"+ temp2.theEnemy.damage +"' count='"+ temp2.number +"'></enemy>" );
          }
          wavesToWrite.add( "      </wave>" );
        }

        wavesToWrite.add( "    </waves>");
        wavesToWrite.add( "  </enemies>" );        

        String[] wavesToWriteArray = new String[wavesToWrite.size()];
        wavesToWrite.toArray(wavesToWriteArray);

        saveStrings(selection.getAbsolutePath() + "/waves.xml", wavesToWriteArray);
        waypointsShow(true);

        //Save towers
        ArrayList towerToWrite = new ArrayList();
        towerToWrite.add( "<?xml version='1.0'?>" );
        towerToWrite.add( "  <towersettings>" );
        towerToWrite.add( "    <towers>");

        for (int i = 0; i < Towers.size(); i++) {
          TOWER temp = (TOWER) Towers.get(i);
          String[] charSetFile = temp.charset.split("/");
          String[] iconFile = temp.towericon.split("/");

          try {
            copyFile(temp.charset, selection.getAbsolutePath() + "/data/" + charSetFile[charSetFile.length-1]);
          } 
          catch (Exception e) {
            println( "Error occured at:" );
            e.printStackTrace();
          }

          try {
            copyFile(temp.towericon, selection.getAbsolutePath() + "/data/" + iconFile[iconFile.length-1]);
          } 
          catch (Exception e) {
            println( "Error occured at:" );
            e.printStackTrace();
          }

          String updateString = "";
          int explosionatenemy = 0;
          int hasshootinganimation = 0;
          int splash = 0;

          if (temp.explosionatenemy == true) { 
            explosionatenemy = 1;
          }
          if (temp.hasshootinganimation == true) { 
            hasshootinganimation = 1;
          }
          if (temp.splash == true) { 
            splash = 1;
          }
          if (temp.updates != 0) {
            for (int j = 0; j < temp.updates; j++) {
              updateString += "u"+(j+1)+"-costs='"+temp.ucosts[j]+"' u"+(j+1)+"-damage='"+temp.udamage[j]+"' u"+(j+1)+"-firerate='"+temp.ufirerate[j]+"' u"+(j+1)+"-fireradius='"+temp.ufireradius[j]+"' ";
            }
          }

          towerToWrite.add( "      <tower name='"+temp.name+"' damageincrease='"+temp.damageincrease+"' hasshootinganimation='"+hasshootinganimation+"' charset='"+charSetFile[charSetFile.length-1]+"' towericon='"+iconFile[iconFile.length-1]+"' towericonsize='"+temp.iconImage.width+"' tilesize='"+towerTileSize+"' damage='"+temp.damage+"' firerate='"+temp.firerate+"' fireradius='"+temp.fireradius+"' splash='"+splash+"' splashradius='"+temp.splashradius+"' splashfactor='"+temp.splashfactor+"' costs='"+temp.costs+"' freeze='"+temp.freeze+"' maxhealth='"+temp.maxhealth+"' updates='"+temp.updates+"' "+updateString+">"+temp.description+"</tower>");
        }

        towerToWrite.add( "    </towers>");
        towerToWrite.add( "  </towersettings>" );

        String[] towerToWriteArray = new String[towerToWrite.size()];
        towerToWrite.toArray(towerToWriteArray);

        saveStrings(selection.getAbsolutePath() + "/towers.xml", towerToWriteArray);


        //save the whole map image and thumbnail
        saveGraphics.save(selection.getAbsolutePath() + "/data/map.png");
        PImage thumbnail = saveGraphics.get(0, 0, int(mapSize[0]*0.25*tileSize), int(mapSize[0]*0.25*tileSize));
        thumbnail.resize(50, 50);
        thumbnail.save(selection.getAbsolutePath() + "/maplogo.png");
        thumbnail = null;
        saveGraphics = null;
      }
    }
  }

  loop();
}


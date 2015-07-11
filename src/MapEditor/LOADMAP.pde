/*******************************************************
 
 Load a map file
 
 *******************************************************/

void loadMapFile(File selected) {
  if (selected != null) {
    noLoop();

    //Get XML-Data and set vars
    XML xmlData;
    xmlData = loadXML(selected.getAbsolutePath() + "/maptree.xml");
    XML xmlMapsize = xmlData.getChild("mapsize");
    XML xmlTileSize = xmlData.getChild("tilesize");
    XML[] xmlLevels = xmlData.getChildren("levels/level");
    XML xmlGameVars = xmlData.getChild("game");
    mapSize[0] = xmlMapsize.getInt("w");
    mapSize[1] = xmlMapsize.getInt("h");
    tileSize = xmlTileSize.getInt("s");
    gameMoney = xmlGameVars.getInt("startmoney");
    gameLifes = xmlGameVars.getInt("lifes");
    mapSizeChanged();

    //Copy the tileset into the temp-dir
    try {
      copyFile(selected.getAbsolutePath() + "/data/tileset.png", System.getProperty("java.io.tmpdir") + "mapEditor_tileset.png");
    } 
    catch (Exception e) {
      println( "Error occured at:" );
      e.printStackTrace();
    }

    //change tileset
    changeTileset(new File(System.getProperty("java.io.tmpdir") + "mapEditor_tileset.png"));

    //set all the saved tiles
    for (int i=0;i<3;i++) {
      tileMap[i] = unserializeMap(xmlLevels[i].getContent(), xmlMapsize.getInt("w"), xmlMapsize.getInt("h"));
    }

    //create a new tile array    
    createTileArray();   

    //get enemy, wave data
    xmlData = loadXML(selected.getAbsolutePath() + "/waves.xml");
    XML[] xmlWaves = xmlData.getChildren("waves/wave");
    Waves = new ArrayList();
    Enemies = new ArrayList();


    //loop through all the waves and set enemy & wave data
    for (int i = 0; i < xmlWaves.length; i++) {
      XML[] xmlEnemies = xmlWaves[i].getChildren("enemy");
      ArrayList tempEnemies = new ArrayList();

      for (int j = 0; j < xmlEnemies.length; j++) {
        boolean found = false;
        for (int h = 0; h < Enemies.size(); h++) {
          ENEMY temp = (ENEMY) Enemies.get(h);
          if (temp.id == xmlEnemies[j].getInt("id")) {
            found = true;
            tempEnemies.add(new ENEMIES(temp, xmlEnemies[j].getInt("count")));
            break;
          }
        }

        if (found == false) { 
          ENEMY temp = new ENEMY( copyImageTemp(selected.getAbsolutePath() + "/data/" + xmlEnemies[j].getString("charset"), xmlEnemies[j].getString("charset")), copyImageTemp(selected.getAbsolutePath() + "/data/" + xmlEnemies[j].getString("icon"), xmlEnemies[j].getString("icon")), xmlEnemies[j].getInt("maxhealth"), xmlEnemies[j].getInt("money"), xmlEnemies[j].getInt("movespeed"), xmlEnemies[j].getInt("animationspeed"), xmlEnemies[j].getInt("damage"));
          tempEnemies.add(new ENEMIES(temp, xmlEnemies[j].getInt("count")));
          Enemies.add(temp);
        }
      }
      Waves.add(new WAVE(tempEnemies, xmlWaves[i].getInt("enemydistance")));
    }

    //get tower data
    xmlData = loadXML(selected.getAbsolutePath() + "/towers.xml");
    XML[] xmlTowers = xmlData.getChildren("towers/tower");
    Towers = new ArrayList();

    //loop through all the towers and save data
    for (int i = 0; i < xmlTowers.length; i++) {
      boolean explosionatenemy = false;
      boolean splash = false;
      boolean hasshootinganimation = false;
      if (xmlTowers[i].getInt("explosionatenemy") == 1) { 
        explosionatenemy = true;
      }
      if (xmlTowers[i].getInt("splash") == 1) { 
        splash = true;
      }
      if (xmlTowers[i].getInt("hasshootinganimation") == 1) { 
        hasshootinganimation = true;
      }

      if (xmlTowers[i].getInt("updates") == 0) {   

        Towers.add( new TOWER( hasshootinganimation, xmlTowers[i].getString("name"), xmlTowers[i].getFloat("damageincrease"), explosionatenemy, copyImageTemp(selected.getAbsolutePath() + "/data/" + xmlTowers[i].getString("charset"), xmlTowers[i].getString("charset")), 
        copyImageTemp(selected.getAbsolutePath() + "/data/" + xmlTowers[i].getString("towericon"), xmlTowers[i].getString("towericon")), xmlTowers[i].getInt("towericonsize"), xmlTowers[i].getInt("damage"), xmlTowers[i].getInt("firerate"), xmlTowers[i].getInt("fireradius"), 
        splash, xmlTowers[i].getInt("splashradius"), xmlTowers[i].getFloat("splashfactor"), xmlTowers[i].getInt("costs"), xmlTowers[i].getFloat("freeze"), xmlTowers[i].getInt("maxhealth"), xmlTowers[i].getInt("updates"), xmlTowers[i].getContent() ));
      } 
      else {
        int[] ucosts = new int[xmlTowers[i].getInt("updates")];
        int[] udamage = new int[xmlTowers[i].getInt("updates")];
        int[] ufirerate = new int[xmlTowers[i].getInt("updates")];
        int[] ufireradius = new int[xmlTowers[i].getInt("updates")];

        for (int j = 0; j < xmlTowers[i].getInt("updates"); j++) {
          ucosts[j] = xmlTowers[i].getInt("u"+(j+1)+"-costs");
          udamage[j] = xmlTowers[i].getInt("u"+(j+1)+"-damage");
          ufirerate[j] = xmlTowers[i].getInt("u"+(j+1)+"-firerate");
          ufireradius[j] = xmlTowers[i].getInt("u"+(j+1)+"-fireradius");
        }

        Towers.add( new TOWER( hasshootinganimation, xmlTowers[i].getString("name"), xmlTowers[i].getFloat("damageincrease"), explosionatenemy, copyImageTemp(selected.getAbsolutePath() + "/data/" + xmlTowers[i].getString("charset"), xmlTowers[i].getString("charset")), 
        copyImageTemp(selected.getAbsolutePath() + "/data/" + xmlTowers[i].getString("towericon"), xmlTowers[i].getString("towericon")), xmlTowers[i].getInt("towericonsize"), xmlTowers[i].getInt("damage"), xmlTowers[i].getInt("firerate"), xmlTowers[i].getInt("fireradius"), 
        splash, xmlTowers[i].getInt("splashradius"), xmlTowers[i].getFloat("splashfactor"), xmlTowers[i].getInt("costs"), xmlTowers[i].getFloat("freeze"), xmlTowers[i].getInt("maxhealth"), xmlTowers[i].getInt("updates"), xmlTowers[i].getContent(), 
        ucosts, udamage, ufirerate, ufireradius ));
      }
    }

    updateControllers();
  }
}


/*******************************************************
 
 Button functions
 
 *******************************************************/

public void loadMap(int value) {
  selectFolder("Select a map-folder to load.", "loadMapFile");
}

public void saveMap(int value) {
  selectOutput("Select a path to save the map", "saveMapFile");
}

public void loadTileset(int value) {
  selectInput("Select an Tileset-image file to load.", "changeTileset");
}

public void editorLevel1(int value) {
  changeEditorLevel(1);
}

public void editorLevel2(int value) {
  changeEditorLevel(2);
}

public void editorLevel3(int value) {
  changeEditorLevel(3);
}

public void mapTileSize(float ts) {
  tileSize = (int) ts;
  completeRedraw();
}

public void mapSizeX(float ts) {
  mapSize[0] = (int) ts;
  mapSizeChanged();
}

public void mapSizeY(float ts) {
  mapSize[1] = (int) ts;
  mapSizeChanged();
}

public void mapSettings(int value) {
  screenId = 1;
  showControls(overviewControls, true);
  showControls(enemyControls, false);
  showControls(towerControls, false);
  showControls(waveControls, false);
  redraw();
}

public void waypointsShow(boolean value) {
  globalWaypoints = createWaypointsInt();
  waypointsShow = value;
}


/*

 Overview Buttons
 
 */

public void mapEditor(int value) {
  screenId = 0;
  resetScroll();
  showControls(overviewControls, false);
  showControls(enemyControls, false);
  showControls(towerControls, false);
  showControls(waveControls, false);
  redraw();
}

public void addEnemy(int value) {
  screenId = 2;
  showControls(enemyControls, true);
  showControls(towerControls, false);
  showControls(waveControls, false);
  showControls(overviewControls, false);
  addEnemy = true;
  editEnemy = new ENEMY();
  updateEnemyControls(true);
  redraw();
}

public void addWave(int value) {
  screenId = 4;
  showControls(enemyControls, false);
  showControls(towerControls, false);
  showControls(waveControls, true);
  showControls(overviewControls, false);
  addWave = true;
  editWave = new WAVE();
  updateWaveControls(true);
  redraw();
}

public void addTower(int value) {
  screenId = 3;
  showControls(enemyControls, false);
  showControls(towerControls, true);
  showControls(waveControls, false);
  showControls(overviewControls, false);
  addTower = true;
  editTower = new TOWER();
  updateTowerControls(true);
  redraw();
}

//Control Event for EDIT & DELETE Buttons of Enemies, Waves & Towers
public void controlEvent(ControlEvent theEvent) {
  if (screenId == 1) {
    for (int i = 0; i < Enemies.size(); i++) {
      ENEMY temp = (ENEMY) Enemies.get(i);
      //Edit Enemy
      if (theEvent.getController().getName().equals("editEnemy"+temp.hashCode())) {
        editEnemy = temp;
        screenId = 2;
        showControls(enemyControls, true);
        showControls(towerControls, false);
        showControls(waveControls, false);
        showControls(overviewControls, false);
        addEnemy = false;
        updateEnemyControls(false);
        redraw();  
        break;
      }
      //Delete Enemy
      else if (theEvent.getController().getName().equals("deleteEnemy"+temp.hashCode())) {
        temp.editButton.remove();
        temp.deleteButton.remove();
        temp.waveSlider.remove();
        temp.waveCheckbox.remove();
        for (int h=0; h<Waves.size(); h++) {
          WAVE temp2 = (WAVE) Waves.get(h);
          temp2.removeEnemy(temp);
        }
        Enemies.remove(i);
        temp = null;
        break;
      }
    }
    for (int i = 0; i < Waves.size(); i++) {
      WAVE temp = (WAVE) Waves.get(i);
      //Edit Wave
      if (theEvent.getController().getName().equals("editWave"+temp.hashCode())) {
        editWave = temp;
        screenId = 4;
        showControls(enemyControls, false);
        showControls(towerControls, false);
        showControls(waveControls, true);
        showControls(overviewControls, false);
        addWave = false;
        updateWaveControls(false);
        redraw();  
        break;
      } 
      //Delete Wave
      else if (theEvent.getController().getName().equals("deleteWave"+temp.hashCode())) {
        temp.editButton.remove();
        temp.deleteButton.remove();
        Waves.remove(i);
        temp = null;
        break;
      }
    }
    for (int i = 0; i < Towers.size(); i++) {
      TOWER temp = (TOWER) Towers.get(i);
      //Edit Tower
      if (theEvent.getController().getName().equals("editTower"+temp.hashCode())) {
        editTower = temp;
        screenId = 3;
        showControls(enemyControls, false);
        showControls(towerControls, true);
        showControls(waveControls, false);
        showControls(overviewControls, false);
        addTower = false;
        updateTowerControls(false);
        redraw();  
        break;
      } 
      //Delete Tower
      else if (theEvent.getController().getName().equals("deleteTower"+temp.hashCode())) {
        temp.editButton.remove();
        temp.deleteButton.remove();
        Towers.remove(i);
        temp = null;
        break;
      }
    }
  } 
  if (screenId == 4) {
    //Slider & checkboxes in the add & edit wave-menu
    if (editWave != null) {
      for (int i = 0; i < Enemies.size(); i++) {
        ENEMY temp = (ENEMY) Enemies.get(i);        
        if (theEvent.getController().getName().equals("waveEnemyCount"+temp.hashCode())) {
          editWave.changeNumber(temp, (int) theEvent.getController().getValue());
        } 
        else if (theEvent.getController().getName().equals("waveEnemyCheck"+temp.hashCode())) { 
          if (theEvent.getController().getValue() == 1f) {  
            Controller c = cp5.getController("waveEnemyCount"+temp.hashCode());          
            editWave.addEnemy(temp, (int) c.getValue());
          } 
          else {
            editWave.removeEnemy(temp);
          }
        }
      }
    }
  }
}



/*

 ENEMY Buttons
 
 */

public void saveEnemy(int value) {
  if (editEnemy != null) {
    if (addEnemy == true) {

      Controller tempController = cp5.addSlider("waveEnemyCount"+editEnemy.hashCode()).setVisible(false).setLock(true).setDecimalPrecision(0).setPosition(-100, -100).setRange(1, 100).setNumberOfTickMarks(100).setValue(1).linebreak();
      styleButton("waveEnemyCount"+editEnemy.hashCode()); 
      styleSlider("waveEnemyCount"+editEnemy.hashCode()); 
      nameSlider("waveEnemyCount"+editEnemy.hashCode(), "Number");   
      waveControls.add( tempController ); 
      editEnemy.waveSlider = tempController;

      tempController = cp5.addToggle("waveEnemyCheck"+editEnemy.hashCode()).setPosition(-100, -100).setVisible(false).setLock(true).setSize(20, 20).setId(editEnemy.hashCode());
      tempController.getCaptionLabel().setVisible(false);
      waveControls.add( tempController ); 
      editEnemy.waveCheckbox = tempController;

      tempController = cp5.addBang("editEnemy"+editEnemy.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Edit").setId(editEnemy.hashCode()).setVisible(false).setLock(true);
      styleButton("editEnemy"+editEnemy.hashCode());  
      overviewControls.add( tempController ); 
      editEnemy.editButton = tempController;

      tempController = cp5.addBang("deleteEnemy"+editEnemy.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Delete").setId(editEnemy.hashCode()).setVisible(false).setLock(true);
      styleButton("deleteEnemy"+editEnemy.hashCode());
      overviewControls.add( tempController );  
      editEnemy.deleteButton = tempController;

      Enemies.add(editEnemy);
      editEnemy = null;
    }
    editEnemy = null;
    mapSettings(1);
  }
}

public void enemyMaxhealth(int value) {
  if (editEnemy != null) {
    editEnemy.maxhealth = value;
  }
}

public void enemyMoney(int value) {
  if (editEnemy != null) {
    editEnemy.money = value;
  }
}

public void enemyMovespeed(int value) {
  if (editEnemy != null) {
    editEnemy.movespeed = value;
  }
}

public void enemyAnimationspeed(int value) {
  if (editEnemy != null) {
    editEnemy.animationspeed = value;
  }
}

public void enemyDamage(int value) {
  if (editEnemy != null) {
    editEnemy.damage = value;
  }
}

public void enemyCharset(int value) {
  selectInput("Select an Charset-image file to load.", "setEnemyCharset");
}

public void enemyIcon(int value) {
  selectInput("Select an Icon-image file to load.", "setEnemyIcon");
}

void setEnemyCharset(File selected) {
  if (selected != null) {
    try {
      copyFile(selected.getAbsolutePath(), System.getProperty("java.io.tmpdir") + editEnemy.hashCode() + "_charset.png");
    } 
    catch (Exception e) {
      println( "Error occured at:" );
      e.printStackTrace();
    } 
    editEnemy.charset = System.getProperty("java.io.tmpdir") + editEnemy.hashCode() + "_charset.png";
    editEnemy.charsetImage = loadImage(editEnemy.charset);
  }
}

void setEnemyIcon(File selected) {
  if (selected != null) {
    try {
      copyFile(selected.getAbsolutePath(), System.getProperty("java.io.tmpdir") + editEnemy.hashCode() + "_icon.png");
    } 
    catch (Exception e) {
      println( "Error occured at:" );
      e.printStackTrace();
    } 
    editEnemy.icon = System.getProperty("java.io.tmpdir") + editEnemy.hashCode() + "_icon.png";
    editEnemy.iconImage = loadImage(editEnemy.icon);
  }
}

void updateEnemyControls(boolean defaultValues) {
  if (editEnemy != null) {
    if (defaultValues == false) {
      Controller c = cp5.getController("enemyMaxhealth");
      c.setValue(editEnemy.maxhealth);
      c = cp5.getController("enemyMoney");
      c.setValue(editEnemy.money);
      c = cp5.getController("enemyMovespeed");
      c.setValue(editEnemy.movespeed);
      c = cp5.getController("enemyAnimationspeed");
      c.setValue(editEnemy.animationspeed);
      c = cp5.getController("enemyDamage");
      c.setValue(editEnemy.damage);
    } 
    else {
      Controller c = cp5.getController("enemyMaxhealth");
      c.setValue(5);
      c = cp5.getController("enemyMoney");
      c.setValue(5);
      c = cp5.getController("enemyMovespeed");
      c.setValue(20);
      c = cp5.getController("enemyAnimationspeed");
      c.setValue(8);
      c = cp5.getController("enemyDamage");
      c.setValue(0);
    }
  }
}

/*

 Wave Buttons
 
 */

public void saveWave(int value) {
  if (editWave != null) {
    if (addWave == true) {     

      Controller tempController = cp5.addBang("editWave"+editWave.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Edit").setId(editWave.hashCode()).setVisible(false).setLock(true);
      styleButton("editWave"+editWave.hashCode());  
      overviewControls.add( tempController ); 
      editWave.editButton = tempController;

      tempController = cp5.addBang("deleteWave"+editWave.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Delete").setId(editWave.hashCode()).setVisible(false).setLock(true);
      styleButton("deleteWave"+editWave.hashCode());
      overviewControls.add( tempController );  
      editWave.deleteButton = tempController;

      Waves.add(editWave);
      editWave = null;
    }
    editWave = null;
    mapSettings(1);
  }
}

public void waveDistance(int value) {
  if (editWave != null) {
    editWave.enemyDistance = value;
  }
}

void updateWaveControls(boolean defaultValues) {
  if (editWave != null) {
    if (defaultValues == false) {
      Controller c = cp5.getController("waveDistance");
      c.setValue(editWave.enemyDistance);
      for (int i = 0; i < Enemies.size(); i++) {
        ENEMY temp = (ENEMY) Enemies.get(i);

        boolean found = false;

        for (int h = 0; h < editWave.waveEnemies.size(); h++) {          
          ENEMIES temp2 = (ENEMIES) editWave.waveEnemies.get(h);
          if (temp.equals(temp2.theEnemy)) {
            found = true;
            temp.waveSlider.setValue(temp2.number);
          }
        }

        if (found == false) {
          temp.waveSlider.setValue(1);
          Toggle temp3 = (Toggle) temp.waveCheckbox;
          temp3.setValue(false);
        } 
        else {
          Toggle temp3 = (Toggle) temp.waveCheckbox;
          temp3.setState(true);
        }
      }
    } 
    else {
      Controller c = cp5.getController("waveDistance");
      c.setValue(1000);
      for (int i = 0; i < Enemies.size(); i++) {
        ENEMY temp = (ENEMY) Enemies.get(i);
        temp.waveSlider.setValue(1);
        Toggle temp3 = (Toggle) temp.waveCheckbox;
        temp3.setValue(false);
      }
    }
  }
}

/*

 Tower Buttons
 
 */

void updateTowerControls(boolean defaultValues) {
  if (editTower != null) {
    if (defaultValues == false) {
      Textfield d = (Textfield) cp5.getController("towerName");
      d.setText(editTower.name);
      d = (Textfield) cp5.getController("towerDescription");
      d.setText(editTower.description);
      Toggle e = (Toggle) cp5.getController("towerExplosionatenemy");
      e.setValue(editTower.explosionatenemy);
      e = (Toggle) cp5.getController("towerHasshootinganimation");
      e.setValue(editTower.hasshootinganimation);
      Controller c = cp5.getController("towerDamage");
      c.setValue(editTower.damage); 
      c = cp5.getController("towerFirerate");
      c.setValue(editTower.firerate);
      c = cp5.getController("towerFireradius");
      c.setValue(editTower.fireradius);      
      e = (Toggle) cp5.getController("towerSplash");
      e.setValue(editTower.splash);
      c = cp5.getController("towerSplashradius");
      c.setValue(editTower.splashradius);
      c = cp5.getController("towerSplashfactor");
      c.setValue(editTower.splashfactor);
      c = cp5.getController("towerCosts");
      c.setValue(editTower.costs);
      c = cp5.getController("towerFreeze");
      c.setValue(editTower.freeze);
      c = cp5.getController("towerMaxhealth");
      c.setValue(editTower.maxhealth);
      c = cp5.getController("towerUpdates");
      c.setValue(editTower.updates);
      c = cp5.getController("towerDamageincrease");
      c.setValue(editTower.damageincrease);
      c = cp5.getController("towerCostsu1");
      c.setValue(editTower.ucosts[0]);
      c = cp5.getController("towerCostsu2");
      c.setValue(editTower.ucosts[1]);
      c = cp5.getController("towerDamageu1");
      c.setValue(editTower.udamage[0]);
      c = cp5.getController("towerDamageu2");
      c.setValue(editTower.udamage[1]);
      c = cp5.getController("towerFirerateu1");
      c.setValue(editTower.ufirerate[0]);
      c = cp5.getController("towerFirerateu2");
      c.setValue(editTower.ufirerate[1]);
      c = cp5.getController("towerFireradiusu1");
      c.setValue(editTower.ufireradius[0]);
      c = cp5.getController("towerFireradiusu2");
      c.setValue(editTower.ufireradius[1]);
    } 
    else {
      Textfield d = (Textfield) cp5.getController("towerName");
      d.clear();
      d = (Textfield) cp5.getController("towerDescription");
      d.clear();
      Toggle e = (Toggle) cp5.getController("towerExplosionatenemy");
      e.setValue(false);
      e = (Toggle) cp5.getController("towerHasshootinganimation");
      e.setValue(false);
      Controller c = cp5.getController("towerDamage");
      c.setValue(5); 
      c = cp5.getController("towerFirerate");
      c.setValue(500);
      c = cp5.getController("towerFireradius");
      c.setValue(200);      
      e = (Toggle) cp5.getController("towerSplash");
      e.setValue(false);
      c = cp5.getController("towerSplashradius");
      c.setValue(50);
      c = cp5.getController("towerSplashfactor");
      c.setValue(0.4);
      c = cp5.getController("towerCosts");
      c.setValue(85);
      c = cp5.getController("towerFreeze");
      c.setValue(0);
      c = cp5.getController("towerMaxhealth");
      c.setValue(200);
      c = cp5.getController("towerUpdates");
      c.setValue(0);
      c = cp5.getController("towerDamageincrease");
      c.setValue(0);
      c = cp5.getController("towerCostsu1");
      c.setValue(100);
      c = cp5.getController("towerCostsu2");
      c.setValue(100);
      c = cp5.getController("towerDamageu1");
      c.setValue(5);
      c = cp5.getController("towerDamageu2");
      c.setValue(5);
      c = cp5.getController("towerFirerateu1");
      c.setValue(500);
      c = cp5.getController("towerFirerateu2");
      c.setValue(500);
      c = cp5.getController("towerFireradiusu1");
      c.setValue(200);
      c = cp5.getController("towerFireradiusu2");
      c.setValue(200);
    }
  }
}

public void saveTower(int value) {
  if (editTower != null) {
    if (addTower == true) {     

      Textfield c = (Textfield) cp5.getController("towerName");      
      editTower.name = c.getText();
      c = (Textfield) cp5.getController("towerDescription"); 
      editTower.description = c.getText();

      Controller tempController = cp5.addBang("editTower"+editTower.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Edit").setId(editTower.hashCode()).setVisible(false).setLock(true);
      styleButton("editTower"+editTower.hashCode());  
      overviewControls.add( tempController ); 
      editTower.editButton = tempController;

      tempController = cp5.addBang("deleteTower"+editTower.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Delete").setId(editTower.hashCode()).setVisible(false).setLock(true);
      styleButton("deleteTower"+editTower.hashCode());
      overviewControls.add( tempController );  
      editTower.deleteButton = tempController;

      Towers.add(editTower);
      editTower = null;
    }
    editTower = null;
    mapSettings(1);
  }
}

public void towerCharset(int value) {
  selectInput("Select an Charset-image file to load.", "setTowerCharset");
}

public void towerIcon(int value) {
  selectInput("Select an Icon-image file to load.", "setTowerIcon");
}

void setTowerCharset(File selected) {
  if (selected != null) {
    try {
      copyFile(selected.getAbsolutePath(), System.getProperty("java.io.tmpdir") + editTower.hashCode() + "_charset.png");
    } 
    catch (Exception e) {
      println( "Error occured at:" );
      e.printStackTrace();
    } 
    editTower.charset = System.getProperty("java.io.tmpdir") + editTower.hashCode() + "_charset.png";
    editTower.charsetImage = loadImage(editTower.charset);
  }
}

void setTowerIcon(File selected) {
  if (selected != null) {
    try {
      copyFile(selected.getAbsolutePath(), System.getProperty("java.io.tmpdir") + editTower.hashCode() + "_icon.png");
    } 
    catch (Exception e) {
      println( "Error occured at:" );
      e.printStackTrace();
    } 
    editTower.towericon = System.getProperty("java.io.tmpdir") + editTower.hashCode() + "_icon.png";
    editTower.iconImage = loadImage(editTower.towericon);
  }
}

void towerExplosionatenemy(boolean value) {
  if (editTower != null) {
    editTower.explosionatenemy = value;
  }
}

void towerHasshootinganimation(boolean value) {
  if (editTower != null) {
    editTower.hasshootinganimation = value;
  }
}

void towerDamage(int value) {
  if (editTower != null) {
    editTower.damage = value;
  }
}

void towerFirerate(int value) {
  if (editTower != null) {
    editTower.firerate = value;
  }
}

void towerFireradius(int value) {
  if (editTower != null) {
    editTower.fireradius = value;
  }
}

void towerSplash(boolean value) {
  if (editTower != null) {
    editTower.splash = value;
  }
}

void towerSplashradius(int value) {
  if (editTower != null) {
    editTower.splashradius = value;
  }
}

void towerSplashfactor(float value) {
  if (editTower != null) {
    editTower.splashfactor = value;
  }
}

void towerCosts(int value) {
  if (editTower != null) {
    editTower.costs = value;
  }
}

void towerFreeze(float value) {
  if (editTower != null) {
    editTower.freeze = value;
  }
}

void towerDamageincrease(float value) {
  if (editTower != null) {
    editTower.damageincrease = value;
  }
}

void towerMaxhealth(int value) {
  if (editTower != null) {
    editTower.maxhealth = value;
  }
}

void towerUpdates(int value) {
  if (editTower != null) {
    editTower.updates = value;
    if (value == 0) {
      showControls(towerUpdate1Controls, false);
      showControls(towerUpdate2Controls, false);
    } 
    else if (value == 1) {
      showControls(towerUpdate1Controls, true);
      showControls(towerUpdate2Controls, false);
    } 
    else if (value == 2) {
      showControls(towerUpdate1Controls, true);
      showControls(towerUpdate2Controls, true);
    }
  }
}

void towerCostsu1(int value) {
  if (editTower != null) {
    editTower.ucosts[0] = value;
  }
}

void towerCostsu2(int value) {
  if (editTower != null) {
    editTower.ucosts[1] = value;
  }
}

void towerDamageu1(int value) {
  if (editTower != null) {
    editTower.udamage[0] = value;
  }
}

void towerDamageu2(int value) {
  if (editTower != null) {
    editTower.udamage[1] = value;
  }
}

void towerFirerateu1(int value) {
  if (editTower != null) {
    editTower.ufirerate[0] = value;
  }
}

void towerFirerateu2(int value) {
  if (editTower != null) {
    editTower.ufirerate[1] = value;
  }
}

void towerFireradiusu1(int value) {
  if (editTower != null) {
    editTower.ufireradius[0] = value;
  }
}

void towerFireradiusu2(int value) {
  if (editTower != null) {
    editTower.ufireradius[1] = value;
  }
}

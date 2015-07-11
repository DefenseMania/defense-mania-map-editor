/*******************************************************
 
 class for saving wave data
 
 *******************************************************/

class WAVE {

  ArrayList waveEnemies;
  int enemyDistance;

  Controller editButton;
  Controller deleteButton;

  WAVE() {
    waveEnemies = new ArrayList();
  }

  WAVE(ArrayList iwaveEnemies, int ienemyDistance) {
    waveEnemies = iwaveEnemies;
    enemyDistance = ienemyDistance;
    waveEnemies = iwaveEnemies;

    Controller tempController = cp5.addBang("editWave"+this.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Edit").setId(this.hashCode()).setVisible(false).setLock(true);
    styleButton("editWave"+this.hashCode());  
    overviewControls.add( tempController ); 
    editButton = tempController;

    tempController = cp5.addBang("deleteWave"+this.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Delete").setId(this.hashCode()).setVisible(false).setLock(true);
    styleButton("deleteWave"+this.hashCode());
    overviewControls.add( tempController );  
    deleteButton = tempController;
  }


  void removeEnemy(ENEMY ienemy) {
    for (int i=0; i < waveEnemies.size(); i++) {
      ENEMIES temp = (ENEMIES) waveEnemies.get(i);
      if (temp.theEnemy.equals(ienemy)) {
        waveEnemies.remove(i);
        break;
      }
    }
  } 

  void addEnemy(ENEMY ienemy, int number) {
    removeEnemy(ienemy);
    waveEnemies.add(new ENEMIES(ienemy, number));
  }

  void changeNumber(ENEMY ienemy, int number) {
    for (int i=0; i < waveEnemies.size(); i++) {
      ENEMIES temp = (ENEMIES) waveEnemies.get(i);
      if (temp.theEnemy.equals(ienemy)) {
        temp.number = number;
        break;
      }
    }
  }
}


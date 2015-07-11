/*******************************************************
 
 Class for saving enemy data
 
 *******************************************************/

class ENEMY {

  int id;
  String charset;
  PImage charsetImage;
  String icon;
  PImage iconImage;
  int maxhealth;
  int money;
  int movespeed;
  int animationspeed;
  int damage;

  Controller editButton;
  Controller deleteButton;
  Controller waveSlider;
  Controller waveCheckbox;

  ENEMY() {
    id = enemyGlobalId;
    enemyGlobalId++;
  }

  ENEMY(String icharset, String iicon, int imaxhealth, int imoney, int imovespeed, int ianimationspeed, int idamage) {
    id = enemyGlobalId;
    enemyGlobalId++;
    charset = icharset;
    icon = iicon;
    maxhealth = imaxhealth;
    money = imoney;
    movespeed = imovespeed;
    animationspeed = ianimationspeed;
    damage = idamage;
    charsetImage = loadImage(charset);
    iconImage = loadImage(icon);

    Controller tempController = cp5.addSlider("waveEnemyCount"+this.hashCode()).setVisible(false).setLock(true).setDecimalPrecision(0).setPosition(-100, -100).setRange(1, 100).setNumberOfTickMarks(100).setValue(1).linebreak();
    styleButton("waveEnemyCount"+this.hashCode()); 
    styleSlider("waveEnemyCount"+this.hashCode()); 
    nameSlider("waveEnemyCount"+this.hashCode(), "Number");   
    waveControls.add( tempController ); 
    waveSlider = tempController;

    tempController = cp5.addToggle("waveEnemyCheck"+this.hashCode()).setPosition(-100, -100).setVisible(false).setLock(true).setSize(20, 20).setId(this.hashCode());
    tempController.getCaptionLabel().setVisible(false);
    waveControls.add( tempController ); 
    waveCheckbox = tempController;

    tempController = cp5.addBang("editEnemy"+this.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Edit").setId(this.hashCode()).setVisible(false).setLock(true);
    styleButton("editEnemy"+this.hashCode());  
    overviewControls.add( tempController ); 
    editButton = tempController;

    tempController = cp5.addBang("deleteEnemy"+this.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Delete").setId(this.hashCode()).setVisible(false).setLock(true);
    styleButton("deleteEnemy"+this.hashCode());
    overviewControls.add( tempController );  
    deleteButton = tempController;
  }
}


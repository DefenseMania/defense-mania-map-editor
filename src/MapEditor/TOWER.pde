/*******************************************************
 
 class for saving tower data
 
 *******************************************************/

class TOWER {

  String name = "";
  String description = "";
  float damageincrease;
  boolean explosionatenemy; 
  boolean hasshootinganimation;
  String charset;
  String towericon;
  int towericonsize;
  int damage;
  int firerate;
  int fireradius;
  boolean splash;
  int splashradius;
  float splashfactor;
  int costs;
  float freeze;
  int maxhealth;
  int updates;
  int[] ucosts;
  int[] udamage;
  int[] ufirerate;
  int[] ufireradius;  

  PImage charsetImage;
  PImage iconImage;

  Controller editButton;
  Controller deleteButton;

  TOWER() {
    ucosts = new int[2];
    udamage = new int[2];
    ufirerate = new int[2];
    ufireradius = new int[2];
  }

  TOWER(boolean ihasshootinganimation, String iname, float idamageincrease, boolean iexplosionatenemy, String icharset, String itowericon, int itowericonsize, int idamage, int ifirerate, 
  int ifireradius, boolean isplash, int isplashradius, float isplashfactor, int icosts, float ifreeze, int imaxhealth, int iupdates, String idescription) {
    hasshootinganimation = ihasshootinganimation;
    name = iname;
    damageincrease = idamageincrease;
    explosionatenemy = iexplosionatenemy;
    charset = icharset;
    towericon = itowericon;
    towericonsize = itowericonsize;
    damage = idamage;
    firerate = ifirerate;
    fireradius = ifireradius;
    splash = isplash;
    splashradius = isplashradius;
    splashfactor = isplashfactor;
    costs = icosts;
    freeze = ifreeze;
    maxhealth = imaxhealth;
    updates = iupdates;
    description = idescription;
    charsetImage = loadImage(charset);
    iconImage = loadImage(towericon);
    Controller tempController = cp5.addBang("editTower"+this.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Edit").setId(this.hashCode()).setVisible(false).setLock(true);
    styleButton("editTower"+this.hashCode());  
    overviewControls.add( tempController ); 
    editButton = tempController;
    tempController = cp5.addBang("deleteTower"+this.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Delete").setId(this.hashCode()).setVisible(false).setLock(true);
    styleButton("deleteTower"+this.hashCode());
    overviewControls.add( tempController );  
    deleteButton = tempController;
  }

  TOWER(boolean ihasshootinganimation, String iname, float idamageincrease, boolean iexplosionatenemy, String icharset, String itowericon, int itowericonsize, int idamage, int ifirerate, 
  int ifireradius, boolean isplash, int isplashradius, float isplashfactor, int icosts, float ifreeze, int imaxhealth, int iupdates, String idescription, 
  int[] iucosts, int[] iudamage, int[] iufirerate, int[] iufireradius) {
    hasshootinganimation = ihasshootinganimation;
    name = iname;
    damageincrease = idamageincrease;
    explosionatenemy = iexplosionatenemy;
    charset = icharset;
    towericon = itowericon;
    towericonsize = itowericonsize;
    damage = idamage;
    firerate = ifirerate;
    fireradius = ifireradius;
    splash = isplash;
    splashradius = isplashradius;
    splashfactor = isplashfactor;
    costs = icosts;
    freeze = ifreeze;
    maxhealth = imaxhealth;
    updates = iupdates;
    description = idescription;
    charsetImage = loadImage(charset);
    iconImage = loadImage(towericon);
    ucosts = iucosts;
    udamage = iudamage;
    ufirerate = iufirerate;
    ufireradius = iufireradius;
    Controller tempController = cp5.addBang("editTower"+this.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Edit").setId(this.hashCode()).setVisible(false).setLock(true);
    styleButton("editTower"+this.hashCode());  
    overviewControls.add( tempController ); 
    editButton = tempController;
    tempController = cp5.addBang("deleteTower"+this.hashCode()).setPosition(-100, -100).setSize(50, 15).setLabel("Delete").setId(this.hashCode()).setVisible(false).setLock(true);
    styleButton("deleteTower"+this.hashCode());
    overviewControls.add( tempController );  
    deleteButton = tempController;
  }
}


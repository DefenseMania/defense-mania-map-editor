/*******************************************************
 
 Create waypoints for saving the map
 
 *******************************************************/

int[][] createWaypointsInt() {
  int[][] returnArray = null;
  String[] tempWp = createWaypoints();  

  if (tempWp != null && tempWp[0] != null) {
    returnArray = new int[tempWp.length][2];    
    for (int i = 0; i < tempWp.length; i++) {
      String[] temp = tempWp[i].split(",");
      returnArray[i][0] = parseInt(temp[0]);
      returnArray[i][1] = parseInt(temp[1]);
    }
  }

  return returnArray;
}


String[] createWaypoints() {

  //Coords for start, end and waypoint in the tileset image
  int[] startPointCoords = {
    4, 0
  };
  int[] endPointCoords = {
    5, 0
  };
  int[] wayPointCoords = {
    1, 0
  };

  //Vars
  String[] outputArray = new String[1];
  boolean notReachedEnd = true;
  boolean foundWps = false;
  int[] startPoint = new int[2];
  int[] endPoint = new int[2];
  ArrayList<int[]> theWay = new ArrayList<int[]>(); // { x(tiles), y(tiles) }
  ArrayList<int[]> wayPoints = new ArrayList<int[]>(); // { x(px), y(px), 0=start 1=end 2=wp }

  //Search for the start & endpoint
  for (int i=0;i<mapSize[0];i++) {
    for (int j=0;j<mapSize[1];j++) {
      if (tileMap[2][i][j][0] == startPointCoords[0] && tileMap[2][i][j][1] == startPointCoords[1]) {
        startPoint[0] = i;
        startPoint[1] = j;
        foundWps = true;
        theWay.add(new int[] { 
          i, j
        }
        );
      }
      if (tileMap[2][i][j][0] == endPointCoords[0] && tileMap[2][i][j][1] == endPointCoords[1]) {
        foundWps = true;
        endPoint[0] = i;
        endPoint[1] = j;
      }
    }
  }

  //Count all segements
  int yxc = 0;

  /*

   Find the Way and build an array with Points
   
   */
  if (foundWps == true) {
    while (notReachedEnd) {

      //Get the last Point
      int[] lastPoint = (int[]) theWay.get(theWay.size()-1);

      //Define the search-points
      int[][] searchPoints = { 
        new int[] { 
          lastPoint[0]-1, lastPoint[1]
        }
        , new int[] { 
          lastPoint[0]+1, lastPoint[1]
        }
        , new int[] { 
          lastPoint[0], lastPoint[1]-1
        }
        , new int[] { 
          lastPoint[0], lastPoint[1]+1
        }
      };    

      //Search for way-segments around that point
      for (int i=0;i<4;i++) {


        //Set boundaries
        if (searchPoints[i][0] < 0) { 
          searchPoints[i][0] = 0;
        }
        if (searchPoints[i][0] >= mapSize[0]) { 
          searchPoints[i][0] = mapSize[0]-1;
        }
        if (searchPoints[i][1] < 0) { 
          searchPoints[i][1] = 0;
        }
        if (searchPoints[i][1] >= mapSize[1]) { 
          searchPoints[i][1] = mapSize[1]-1;
        }

        //Search for way-segments
        if ( (tileMap[2][ searchPoints[i][0] ][ searchPoints[i][1] ][0] == wayPointCoords[0] && tileMap[2][ searchPoints[i][0] ][ searchPoints[i][1] ][1] == wayPointCoords[1]) 
          && (searchPoints[i][0] != lastPoint[0] || searchPoints[i][1] != lastPoint[1]) ) {

          boolean foundPoint = false;

          //Check if the found segment is already in the list
          for (int k=0;k<theWay.size();k++) {
            int[] temp = (int[]) theWay.get(k);
            if (temp[0] == searchPoints[i][0] && temp[1] == searchPoints[i][1]) { 
              foundPoint = true;
            }
          }

          //add segment otherwise
          if (foundPoint == false) {
            theWay.add(new int[] { 
              searchPoints[i][0], searchPoints[i][1]
            }
            );           
            break;
          } 

          //or maybe it's the endpoint?
        } 
        else if ( (tileMap[2][searchPoints[i][0]][searchPoints[i][1]][0] ==endPointCoords[0] && tileMap[2][searchPoints[i][0]][searchPoints[i][1]][1] == endPointCoords[1])
          && (searchPoints[i][0] != lastPoint[0] || searchPoints[i][1] != lastPoint[1]) ) {
          theWay.add(new int[] { 
            searchPoints[i][0], searchPoints[i][1]
          }
          );          
          notReachedEnd = false;
        }
      }

      yxc++;

      //Stop the loop, if there's no endpoint defined or bad defined
      if (yxc > mapSize[0]*mapSize[1]) {
        notReachedEnd = false;
      }
    }
  } 
  else {
    println("No startpoint or endpoint found!");
  }

  /*

   Take the point-array and make waypoints
   
   */

  if (theWay.size() > 0) {

    //Add startpoint
    wayPoints.add(new int[] { 
      tilesetToPixelCoords(startPoint)[0], tilesetToPixelCoords(startPoint)[1], 0
    }
    );
    int[] lastVector = { 
      0, 0
    };


    //Loop through the way and find edges
    for (int i=0;i<theWay.size()-1;i++) {

      int[] point1 = (int[]) theWay.get(i);
      int[] point2 = (int[]) theWay.get(i+1);

      int[] currentVector = { 
        -(point1[0]-point2[0]), -(point1[1]-point2[1])
        };

        //Check if the vector changed
        if (lastVector[0] != 0 || lastVector[1] != 0) {
          if (currentVector[0] == lastVector[0] && currentVector[1] == lastVector[1]) {
          } 
          else {          
            //Add Waypoint
            wayPoints.add(new int[] { 
              tilesetToPixelCoords(point1)[0], tilesetToPixelCoords(point1)[1], 2
            }
            );
            lastVector = currentVector;
          }
        } 
        else {
          lastVector = currentVector;
        }
    }

    //Add endpoint
    wayPoints.add(new int[] { 
      tilesetToPixelCoords(endPoint)[0], tilesetToPixelCoords(endPoint)[1], 1
    }
    );

    //Turn the ArrayList into an Array for saving
    outputArray = new String[wayPoints.size()];

    for (int i=0;i<wayPoints.size();i++) {
      int[] temp = (int[]) wayPoints.get(i);
      outputArray[i] = temp[0] + "," + temp[1] + "," + temp[2];
    }
  } 
  else {
    println("No way found!");
  }

  return outputArray;
}


//Returns pixelcoords from tilesetcoords
int[] tilesetToPixelCoords(int[] tilesetCoords) { 
  return new int[] { 
    (tilesetCoords[0]*tileSize)+(tileSize/2), (tilesetCoords[1]*tileSize)+(tileSize/2)
    };
  }


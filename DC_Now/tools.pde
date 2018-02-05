// return true if the player is active
boolean checkPlayer(String playerName)
{
  JSONObject p;
  for (int i = 0; i < activePlayer.size(); i++)
  {
    p = activePlayer.getJSONObject(i);
    //println("Checking "+ playerName +" with "+ p.getString("username"));
    if (p.getString("username").equals(playerName))
    {
      //println("FOUND A MATCH!");
      return true;
    }
  }
  //println("Found no match");
  return false;
}

// return true if the player is active
void removePlayer(String playerName)
{
  JSONObject p;
  for (int i = 0; i < activePlayer.size(); i++)
  {
    p = activePlayer.getJSONObject(i);
    if (p.getString("username").equals(playerName))
    {
      activePlayer.remove(i);
    }
  }
}

float rTime;

void updateTime()
{
  float h = 20 * displayDensity;
  int nTime = (millis() / 1000) % updateTime;

  fill(gameColor);
  rect(0, height-h, width, h);
  fill(green);
  textSize(tSize*0.75);
  //textFont(lib11);
  textAlign(CENTER, CENTER);
  text("Next update in "+ (updateTime - nTime) +" seconds.", width/2, height - h/2);
  
  if(resume == true)
    rTime = 255;
  
  if(rTime > 0)
    rTime -= 5;
  
  textSize(tSize*0.75);
  fill(200, rTime);
  textAlign(CENTER, CENTER);
  //stroke(30);
  //line(0, h*3, width, h*3);
  text("data updated", width/2, height - h * 2);
}

void displayTitle()
{
  textSize(tSize*0.75);
  textAlign(LEFT);
  fill(white);
  text( activePlayer.size() +" DreamPi Online", 22 * displayDensity, 30 * displayDensity);

  textSize(tSize*0.5);
  textAlign(RIGHT);
  fill(#B7B7B7);
  text("data by dreamcast.online/now/", 400 * displayDensity, 20 * displayDensity);
  text("app by magnes-dc.tumblr.com", 400 * displayDensity, 30 * displayDensity);
}

void onFlick( float x, float y, float px, float py, float v)
{
  if (py < y - 30)
    resume = true;
}

public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}
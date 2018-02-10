import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class DC_Now_PC extends PApplet {




//Minim minim;

//General
int tSize = 15;
int tSpace = 0;
int updateTime = 60;
int border = 10;

//Fonts
PFont lib11;
PFont lib15;

//Colors
//https://coolors.co/272932-adbac6-60656f-d5a021-226ce0
int dark = 0xff272932;
int green = 0xff226CE0;
int light = 0xffADBAC6;
int gameColor = 0xffD5A021;
int white = 0xffEBEBEB;

int lastPlayerCount = 0;
StringList gameList;
JSONArray activePlayer;
JSONArray player;
boolean resume = false;

int displayDensity = 1;

public void setup()
{
  
  //fullScreen();
  surface.setTitle("DC_Now");
  
  noStroke();
  lib15 = loadFont("font15.vlw");
  //textFont(lib15);
  tSize = PApplet.parseInt(tSize * displayDensity);

  //ANDROID////////////////////////////
  //gesture = new KetaiGesture(this);



  //sound stuff
  /*
  minim = new Minim(this);
   connect = minim.loadFile("S2_35.wav");
   connect.setVolume(0.25);
   disconnect = minim.loadFile("S2_23.wav");
   disconnect.setVolume(0.25);
   */
  //get first data
  activePlayer = new JSONArray();
  getOnlinePlayers();
}

public void draw()
{
  background(dark);
  updateTime();

  if (resume == true)
    getOnlinePlayers();

  if (millis() % (updateTime * 1000) < 50)
  {
    resume = true;
  }

  displayUpdate();
  displayPlayers2();
  displayTitle(); 
  delay(10);
}


public void getOnlinePlayers()
{
  int cPlayer = 0;
  JSONObject p;
  JSONObject data;
  int totalUser;

  //disconnect.rewind();
  //connect.rewind();
  println("Refreshing players");
  data = loadJSONObject("http://dreamcast.online/now/api/users.json");
  //data = loadJSONObject("data_test.json");
  totalUser = data.getInt("total_count");
  player = data.getJSONArray("users");
  for (int i = 0; i < totalUser; i++)
  {
    p = player.getJSONObject(i);
    if (p.getBoolean("online") == true && !checkPlayer(p.getString("username")))
    {
      println("Adding : "+ p.getString("username"));
      activePlayer.append(p);
    }
    if (p.getBoolean("online") == false && checkPlayer(p.getString("username")))
    {
      print("Removing : "+ p.getString("username"));
      //disconnect.play();
      removePlayer(p.getString("username"));
    }
  }
  lastPlayerCount = activePlayer.size();

  gameList = new StringList();
  for (int i = 0; i < lastPlayerCount; i++) {
    p = player.getJSONObject(i);
    if (!gameList.hasValue(p.getString("current_game")))
      gameList.append(p.getString("current_game"));
  }


  resume = false;
  delay(10);
}

public void displayPlayers2()
{
  int line = 3;
  if (activePlayer.size() > 0)
  {
    for  (String game : gameList) {
      ///////////GAME///////////////
      textAlign(LEFT);
      textSize(tSize);
      fill(green);
      text(game, border * displayDensity, line * tSize);
      line++;
      for (int i = 0; i < activePlayer.size(); i++)
      {
        JSONObject p = activePlayer.getJSONObject(i);
        if (p.getString("current_game").equals(game)) {
          ////////////LINE///////////
          PVector start = new PVector(border * displayDensity, line * tSize);
          fill(30);
          textSize(tSize*0.75f);
          rect(start.x, start.y - 3, textWidth(p.getString("username")) + border * 2, tSize/2);
          ////////////PLAYER//////////
          fill(gameColor);
          text(p.getString("username"), (border*2) * displayDensity, line * tSize);
          line++;
        }
      }
      line++;
    }
  }
  noStroke();
}

public void displayPlayers()
{
  int line = 3;
  stroke(30);
  strokeWeight(5);
  strokeCap(SQUARE);
  if (activePlayer.size() > 0)
  {
    for (int i = 0; i < activePlayer.size(); i++)
    {
      ////////////LINE///////////
      PVector start = new PVector(border * displayDensity, line * tSize);
      line(start.x, start.y, width - border, start.y);
      ////////////PLAYER/////////
      JSONObject p = activePlayer.getJSONObject(i);
      textAlign(LEFT);
      textSize(tSize);
      fill(green);
      //ellipse(13 * displayDensity, 37 * displayDensity + (line * (tSize + tSpace)), 5 * displayDensity, 5 * displayDensity);
      text(p.getString("username"), border * displayDensity, line * tSize);
      //line++;
      textSize(tSize*0.75f);
      textAlign(RIGHT);
      fill(gameColor);
      text(p.getString("current_game"), (width-border) * displayDensity, line * tSize);
      line++;
    }
  }
  noStroke();
}

// return true if the player is active
public boolean checkPlayer(String playerName)
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
public void removePlayer(String playerName)
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

public void updateTime()
{
  float h = 20 * displayDensity;
  int nTime = (millis() / 1000) % updateTime;

  fill(white);
  rect(0, height-h, width, h);
  fill(green);
  textSize(tSize*0.75f);
  //textFont(lib11);
  textAlign(CENTER, CENTER);
  text("Next update in "+ (updateTime - nTime) +" seconds.", width/2, height - h/2);
}

public void displayUpdate() {
 if(resume == true)
    rTime = 255;
  
  if(rTime > 0)
    rTime -= 3;
  
  textSize(tSize*0.75f);
  fill(200, rTime);
  textAlign(RIGHT);
  //stroke(30);
  //line(0, h*3, width, h*3);
  text("data updated", width - border * displayDensity, (border * 2) * displayDensity); 
  
}

public void displayTitle()
{
  textSize(tSize*0.75f);
  textAlign(LEFT);
  fill(white);
  text( activePlayer.size() +" DreamPi Online", border * displayDensity, (border * 2) * displayDensity);

  textSize(tSize*0.75f);
  textAlign(CENTER);
  fill(0xffB7B7B7);
  //text("data by dreamcast.online/now/", width/2, height - 30 * displayDensity);
  //text("app by magnes-dc.tumblr.com", width/2, height - 40 * displayDensity);
}

/*
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
*/
  public void settings() {  size(300, 400);  noSmooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "DC_Now_PC" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

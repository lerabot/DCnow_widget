import ddf.minim.*;
import java.util.*;

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
color dark = #272932;
color green = #226CE0;
color light = #ADBAC6;
color gameColor = #D5A021;
color white = #EBEBEB;

int lastPlayerCount = 0;
JSONArray activePlayer;
JSONArray player;
boolean resume = false;

int displayDensity = 1;

void setup()
{
  size(300, 400);
  //fullScreen();
  surface.setTitle("DC_Now");
  noSmooth();
  noStroke();
  lib15 = loadFont("font15.vlw");
  //textFont(lib15);
  tSize = int(tSize * displayDensity);

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

void draw()
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


void getOnlinePlayers()
{
  int cPlayer = 0;
  JSONObject p;
  JSONObject data;
  int totalUser;

  //disconnect.rewind();
  //connect.rewind();
  println("Refreshing players");
  data = loadJSONObject("http://dreamcast.online/now/api/users.json");
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

  StringList gameList = new StringList();
  for (int i = 0; i < lastPlayerCount; i++) {
    p = player.getJSONObject(i);
    if (!gameList.hasValue(p.getString("current_game")))
      gameList.append(p.getString("current_game"));
  }
   

  resume = false;
  delay(10);
}

void displayPlayers2()
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
      ////////////PLAYER//////////
      JSONObject p = activePlayer.getJSONObject(i);
      textAlign(LEFT);
      textSize(tSize);
      fill(green);
      //ellipse(13 * displayDensity, 37 * displayDensity + (line * (tSize + tSpace)), 5 * displayDensity, 5 * displayDensity);
      text(p.getString("current_game"), border * displayDensity, line * tSize);
      //line++;
      textSize(tSize*0.75);
      textAlign(RIGHT);
      fill(gameColor);
      text(p.getString("username"), (width-border) * displayDensity, line * tSize);
      line++;
    }
  }
  noStroke();
}

void displayPlayers()
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
      textSize(tSize*0.75);
      textAlign(RIGHT);
      fill(gameColor);
      text(p.getString("current_game"), (width-border) * displayDensity, line * tSize);
      line++;
    }
  }
  noStroke();
}
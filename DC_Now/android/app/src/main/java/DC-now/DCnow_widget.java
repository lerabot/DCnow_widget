package DC-now;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class DCnow_widget extends PApplet {


Minim minim;
AudioPlayer connect;
AudioPlayer disconnect;

//General
int tSize = 11;
int tSpace = 3;
int updateTime = 60;

//Fonts
PFont lib11;
PFont lib15;

//Colors
int dark = 0xff151228;
int green = 0xff81F495;
int gameColor = 0xff3F43BA;
int white = 0xffEBEBEB;

int lastPlayerCount = 0;
JSONArray activePlayer;
JSONArray player;

public void setup()
{
  
  surface.setTitle("Dreamcast Now Widget");
  //noSmooth();
  noStroke();
  lib15 = loadFont("font15.vlw");
  lib11 = loadFont("font11.vlw");

  //sound stuff
  minim = new Minim(this);
  connect = minim.loadFile("S2_35.wav");
  connect.setVolume(0.25f);
  disconnect = minim.loadFile("S2_23.wav");
  disconnect.setVolume(0.25f);

  //get first data
  activePlayer = new JSONArray();
  getOnlinePlayers();
  display();
}

public void draw()
{
  if (millis() % (updateTime * 1000) < 50)
  {
    display();
    delay(150);
  }
  updateTime();
}

public void display()
{
  background(0xff151228);
  getOnlinePlayers();
  displayPlayers();
  displayTitle();
}


public void getOnlinePlayers()
{
  int cPlayer = 0;
  JSONObject p;
  JSONObject data;
  int totalUser;

  disconnect.rewind();
  connect.rewind();
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
      disconnect.play();
      removePlayer(p.getString("username"));
    }
  }
  if (activePlayer.size() > lastPlayerCount)
    connect.play();
  if (activePlayer.size() < lastPlayerCount)
    disconnect.play();

  lastPlayerCount = activePlayer.size();
}

public void displayPlayers()
{
  int line = 0;
  if (activePlayer.size() > 0)
  {
    for (int i = 0; i < activePlayer.size(); i++)
    {
      JSONObject p = activePlayer.getJSONObject(i);
      textAlign(LEFT);
      textFont(lib11);
      textSize(tSize);
      fill(green);
      ellipse(13, 37 + (line * (tSize + tSpace)), 5, 5);
      text(p.getString("username"), 22, 40 + (line * (tSize + tSpace)));
      line++;
      fill(gameColor);
      text(p.getString("current_game"), 30, 40 + (line * (tSize + tSpace)));
      //println(p.getString("username"));
      line++;
    }
  }
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

public void updateTime()
{
  int h = 20;
  int nTime = (millis() / 1000) % updateTime;

  fill(gameColor);
  rect(0, height-h, width, h);
  fill(green);
  textSize(11);
  textFont(lib11);
  textAlign(CENTER);
  text("Next update in "+ (updateTime - nTime) +" seconds.", width/2, height-7);
}

public void displayTitle()
{
  textSize(15);
  textAlign(LEFT);
  fill(white);
  textFont(lib15);
  text( activePlayer.size() +" Dreamcast Online", 10, 25);
}
  public void settings() {  size(200, 300); }
}

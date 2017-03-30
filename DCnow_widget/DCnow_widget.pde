import processing.sound.*;
SoundFile connect;
SoundFile disconnect;

//General
int tSize = 11;
int tSpace = 3;
int updateTime = 15;

//Fonts
PFont lib11;
PFont lib15;

//Colors
color dark = #151228;
color green = #81F495;
color gameColor = #3F43BA;
color white = #EBEBEB;

int lastPlayerCount = 0;
JSONArray activePlayer;
JSONArray player;

void setup()
{
  size(200, 300);
  surface.setTitle("Dreamcast Now Widget");
  //noSmooth();
  lib15 = loadFont("font15.vlw");
  lib11 = loadFont("font11.vlw");

  connect = new SoundFile(this, "S2_35.wav");
  connect.amp(0.25);
  disconnect = new SoundFile(this, "S2_23.wav");
  disconnect.amp(0.25);
  activePlayer = new JSONArray();
  getOnlinePlayers();
  noStroke();
  display();
  //ellipseMode(CENTER);
  //textAlign(LEFT,TOP);
  //noLoop();
}

void draw()
{
  if (millis() % (updateTime * 1000) < 50)
  {
    display();
    delay(150);
  }
  updateTime();
}

void display()
{
  background(#151228);
  getOnlinePlayers();
  displayPlayers();
  displayTitle();
}


void getOnlinePlayers()
{
  int cPlayer = 0;
  JSONObject p;
  JSONObject data;
  int totalUser;

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

void displayPlayers()
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
//import processing.sound.*;

JSONObject data;
JSONArray player;
int totalUser;
int playerOnline;
int tSize = 11;
int tSpace = 3;
int updateTime = 30;

//SoundFile ding;

PFont lib11;
PFont lib15;

color dark = #151228;
color green = #81F495;
color gameColor = #3F43BA;
color white = #EBEBEB;


void setup()
{
  size(200, 300);
  //noSmooth();
  lib15 = loadFont("font15.vlw");
  lib11 = loadFont("font11.vlw");

  //ding = new SoundFile(this, "radio.wav");

  data = loadJSONObject("http://dreamcast.online/now/api/users.json");
  totalUser = data.getInt("total_count");
  player = data.getJSONArray("users");
  noStroke();
  display();
  //ellipseMode(CENTER);
  //textAlign(LEFT,TOP);
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
  textSize(15);
  textAlign(LEFT);
  fill(white);
  textFont(lib15);
  text("Dreamcast Online", 10, 25);
  getOnlinePlayers();
}


void getOnlinePlayers()
{
  int c = 0;
  int cPlayer = 0;
  JSONObject p;

  data = loadJSONObject("http://dreamcast.online/now/api/users.json");
  totalUser = data.getInt("total_count");
  player = data.getJSONArray("users");
  
  for (int i = 0; i < totalUser; i++)
  {
    p = player.getJSONObject(i);
    //println(p.getString("username"));
    if (p.getBoolean("online") == true)
    {
      textFont(lib11);
      textSize(tSize);
      fill(green);
      ellipse(10, 37 + (c*(tSize + tSpace)), 5, 5);
      text(p.getString("username"), 15, 40 + (c * (tSize + tSpace)));
      c++;
      fill(gameColor);
      text(p.getString("current_game"), 30, 40 + (c * (tSize + tSpace)));
      println(p.getString("username"));
      c++;
      cPlayer++;
    }
  }
  //if (cPlayer > playerOnline)
  //ding.play();
}

void updateTime()
{
  int h = 20;
  int nTime = (millis() / 1000) % updateTime;

  fill(gameColor);
  rect(0, height-h, width, h);
  fill(green);
  textSize(11);
  textFont(lib11);
  textAlign(CENTER);
  //int nTime = abs(((millis() % updateTime) - updateTime))
  text("Next update in "+ (updateTime - nTime) +" seconds.", width/2, height-7);
}
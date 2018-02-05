import android.view.MotionEvent;
import ketai.ui.*;
import android.app.Activity;

KetaiGesture gesture;

//General
int tSize = 11;
int tSpace = 20;
int updateTime = 60;

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
boolean resume = false;

void setup()
{
  //size(200, 300);
  fullScreen();
  //surface.setTitle("Dreamcast Now Widget");
  //noSmooth();
  noStroke();

  textFont(createFont("FreeSans.ttf", 11 * displayDensity));
  tSize = int(22 * displayDensity);
  //textSize(50);

  //ANDROID////////////////////////////
  gesture = new KetaiGesture(this);



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
  display();
}

void onResume() {
  super.onResume();
  println("Resuming app");
  resume = true;
}

void draw()
{
  background(#151228);
  updateTime();
  
  if (resume == true)
    getOnlinePlayers();

  if (millis() % (updateTime * 1000) < 50)
  {
    resume = true;
  }

  displayPlayers();
  displayTitle(); 
  delay(10);
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
  /*
  if (activePlayer.size() > lastPlayerCount)
   connect.play();
   if (activePlayer.size() < lastPlayerCount)
   disconnect.play();
   */
  lastPlayerCount = activePlayer.size();
  resume = false;
  delay(10);
}

void displayPlayers()
{
  int line = 1;
  stroke(120, 50);
  strokeWeight(15);
  strokeCap(SQUARE);
  if (activePlayer.size() > 0)
  {
    for (int i = 0; i < activePlayer.size(); i++)
    {
      ////////////LINE///////////

      PVector start = new PVector(22 * displayDensity, 40 * displayDensity + (line * (tSize + tSpace)));
      line(start.x, start.y, width - 20, start.y);

      JSONObject p = activePlayer.getJSONObject(i);
      textAlign(LEFT);
      //textFont(lib11);
      textSize(tSize);
      fill(green);
      //ellipse(13 * displayDensity, 37 * displayDensity + (line * (tSize + tSpace)), 5 * displayDensity, 5 * displayDensity);
      text(p.getString("username"), 22 * displayDensity, 40 * displayDensity + (line * (tSize + tSpace)));
      //line++;
      textSize(tSize*0.75);
      textAlign(RIGHT);
      fill(gameColor);
      text(p.getString("current_game"), 400 * displayDensity, 40 * displayDensity + (line * (tSize + tSpace)));


      //println(p.getString("username"));
      line++;
    }
  }
  noStroke();
}
import android.view.MotionEvent;
import ketai.ui.*;
import android.app.Activity;

KetaiGesture gesture;

//General
int tSize = 25;
int tSpace = 0;
int updateTime = 60;
float border;

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
int psoPlayer = 0;
StringList gameList;
JSONArray activePlayer;
JSONArray player;
boolean resume = false;

void setup()
{
  fullScreen();
  //noStroke();
  textFont(createFont("Assistant-Light.ttf", tSize * displayDensity));
  tSize = int(tSize * displayDensity);

  //ANDROID////////////////////////////
  gesture = new KetaiGesture(this);
  border = 15 * displayDensity;

  //get first data
  activePlayer = new JSONArray();
  getOnlinePlayers();
}

void onResume() {
  super.onResume();
  println("Resuming app");
  resume = true;
}

void draw()
{
  background(dark);
  updateTime();
  displayUpdate();

  if (resume == true)
    getOnlinePlayers();

  if (millis() % (updateTime * 1000) < 50)
  {
    resume = true;
  }

  displayGamePlayer();
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
  
  psoPlayer = getPSOPlayer();
  if (psoPlayer > 0 && !gameList.hasValue("Phantasy Star Online"))
    gameList.append("Phantasy Star Online");
    
  resume = false;
}

void displayGamePlayer()
{
  int line = 3;
  if (activePlayer.size() > 0)
  {
    for  (String game : gameList) {
      ///////////GAME///////////////
      textAlign(LEFT);
      textSize(tSize);
      fill(green);
      text(game, border, line * tSize);
      if (game.equals("Phantasy Star Online")) {
        line++;
        //textAlign(RIGHT);
        //fill(gameColor);
        textSize(tSize*0.75);
        text( psoPlayer + " hunters on Sylverant", border * 2, line * tSize);
      }
      line++;
      for (int i = 0; i < activePlayer.size(); i++)
      {
        JSONObject p = activePlayer.getJSONObject(i);
        if (p.getString("current_game").equals(game)) {
          ////////////LINE///////////
          PVector start = new PVector(border, line * tSize);
          fill(30);
          textSize(tSize*0.75);
          rect(start.x, start.y - 10, textWidth(p.getString("username")) + border * 2, tSize/3);
          ////////////PLAYER//////////
          fill(gameColor);
          text(p.getString("username"), border * 2, line * tSize);
          line++;
        }
      }
      line++;
    }
  }
  noStroke();
}
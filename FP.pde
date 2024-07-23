import ddf.minim.*;

Minim minim;
AudioPlayer player;

PImage playerImg; // Gambar untuk pemain
int playerX, playerY; // Posisi pemain
int playerSize = 40; // Ukuran pemain
int playerSpeed = 5; // Kecepatan gerak pemain
int numBalls = 5; // Jumlah bola
int[] ballX, ballY; // Posisi bola
int ballSize = 20; // Ukuran bola
int[] ballSpeedX, ballSpeedY; // Kecepatan gerak bola
boolean gameOver = false; // Flag untuk cek jika game over
boolean gameStarted = false; // Flag untuk cek jika game telah dimulai
int score = 0; // Skor pemain

void setup() {
  size(400, 400);
  minim = new Minim(this);
  player = minim.loadFile("backsound.wav");
  player.loop();

  // Muat gambar pemain
  playerImg = loadImage("player.png"); // 
  
  // Inisialisasi posisi pemain
  playerX = width / 2;
  playerY = height - 50;
  
  // Inisialisasi array bola
  ballX = new int[numBalls];
  ballY = new int[numBalls];
  ballSpeedX = new int[numBalls];
  ballSpeedY = new int[numBalls];
  
  // Buat bola
  for (int i = 0; i < numBalls; i++) {
    resetBall(i);
  }
}

void draw() {
  drawGradientBackground();
  
  if (!gameStarted) {
    // Tampilkan layar mulai
    textAlign(CENTER, CENTER);
    textSize(32);
    fill(0);
    text("Dodge the Ball", width / 2, height / 2 - 20);
    textSize(20);
    text("Press Enter to Start", width / 2, height / 2 + 20);
  } else if (!gameOver) {
    // Gerakkan pemain
    if (keyPressed) {
      if (keyCode == LEFT) {
        playerX = max(playerX - playerSpeed, 0);
      } else if (keyCode == RIGHT) {
        playerX = min(playerX + playerSpeed, width - playerSize);
      }
    }
    
    // Gambar pemain
    image(playerImg, playerX, playerY, playerSize, playerSize);
    
    // Gerakkan dan gambar bola
    for (int i = 0; i < numBalls; i++) {
      ballX[i] += ballSpeedX[i];
      ballY[i] += ballSpeedY[i];
      fill(255, 0, 0);
      ellipse(ballX[i], ballY[i], ballSize, ballSize);
      
      // Cek tumbukan dengan pemain
      if (dist(playerX + playerSize/2, playerY + playerSize/2, ballX[i], ballY[i]) < playerSize/2 + ballSize/2) {
        gameOver = true;
      }
      
      // Reset posisi bola jika keluar layar
      if (ballY[i] > height) {
        resetBall(i);
        score++;
      }
    }
    
    // Tampilkan skor
    textAlign(LEFT);
    fill(0);
    textSize(20);
    text("Score: " + score, 10, 20);
  } else {
    // Layar game over
    textAlign(CENTER, CENTER);
    textSize(32);
    fill(255, 0, 0);
    text("Game Over! Score: " + score, width / 2, height / 2);
    textSize(20);
    fill(0);
    text("Press Space to Restart", width / 2, height / 2 + 40);
  }
}

// Fungsi untuk mereset posisi dan kecepatan bola
void resetBall(int i) {
  ballX[i] = (int)random(width);
  ballY[i] = 0;
  ballSpeedX[i] = (int)random(-3, 3);
  ballSpeedY[i] = (int)random(2, 5);
}

// Fungsi untuk menangani penekanan tombol
void keyPressed() {
  if (key == ' ' && gameOver) {
    gameOver = false;
    score = 0;
    playerX = width / 2;
    // Reset semua bola
    for (int i = 0; i < numBalls; i++) {
      resetBall(i);
    }
  } else if (keyCode == ENTER && !gameStarted) {
    gameStarted = true;
  }
}

// Background gradient
void drawGradientBackground() {
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(color(0, 102, 153), color(0, 204, 255), inter);
    stroke(c);
    line(0, i, width, i);
  }
}

void stop() {
  // Hentikan pemutaran musik saat sketsa berhenti
  player.close();
  minim.stop();
  super.stop();
}

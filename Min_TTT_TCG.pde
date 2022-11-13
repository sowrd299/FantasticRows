/**
*/

// Core game components
CardView[][] board;
Player[] players;
int turnIndex;
boolean gameInProgres;
Player winner;

// Game board config
int boardXPadding = 30;
int boardYOffset = 100;

int cellPadding = 20;
int cellHightlightPadding = 10;

int playerUiHeight = 48;

int glowWidth = 6;

int buttonWidth = 100;

MouseManager mouseManager;
DragManager dragManager;
AiManager aiManager;

CardDrawMode handCardDrawMode;
CardDrawMode handCardCantPlayDrawMode;
CardDrawMode boardCardDrawMode;

ImmunityAnimation immunityAnimation;
DiscardAnimation discardAnimation;

// Globally used font data
PFont font;
PFont bodyFont;

// Globally used image data
PImage bgSprite;
PImage menuBgSprite;
PImage parchmentSprite;
PImage coinSprite;
PImage largeCoinSprite;
PImage discardSprite;
PImage discardParchmentSprite;
PImage immunitySprite;
PImage localTurnSprite;
PImage aiTurnSprite;
PImage instantAbilitySprite;
PImage constantAbilitySprite;
PImage buttonSprite;
PImage buttonHoverSprite;

// AI turn variables
AiPlayAnimation aiPlayAnim;
Vector2 aiPlacedPos;

// Menu buttons
Button playButton;

/**
*/
void setup()
{
	size(400, 800);
	DrawLoading();

	// Load some fonts
	font = createFont("Fonts/IMMORTAL.ttf", 64);
	bodyFont = createFont("Fonts/euphorigenic.regular.ttf", 16);

	// Load some images
	bgSprite = loadImage("Sprites/Map_04.jpg");
	bgSprite.resize(height, height); // source image is square
	menuBgSprite = loadImage("Sprites/book-1.png");
	menuBgSprite.resize(height, menuBgSprite.width * height / menuBgSprite.height);
	parchmentSprite = loadImage("Sprites/Parchment.jpg");
	coinSprite = loadImage("Sprites/Coin.png");
	largeCoinSprite = loadImage("Sprites/Coin.png");
	largeCoinSprite.resize( coinSprite.width * (playerUiHeight / coinSprite.height), playerUiHeight);
	discardSprite = loadImage("Sprites/torch/torchlight002.png");
	discardSprite.resize( discardSprite.width * (playerUiHeight / discardSprite.height), playerUiHeight);
	discardParchmentSprite = loadImage("Sprites/Parchment.jpg");
	discardParchmentSprite.resize( int(discardSprite.height * 0.714), discardSprite.height );
	immunitySprite = loadImage("Sprites/Shield 2/32.png");
	immunitySprite.resize(30, immunitySprite.height * (30 / immunitySprite.width));
	localTurnSprite = loadImage("Sprites/denzis-time-weather-biome-gui/7. celestial/7.2 sun/sun noon.png");
	aiTurnSprite = loadImage("Sprites/denzis-time-weather-biome-gui/7. celestial/7.1 moon/waxing crescent moon/waxing crescent moon midnight.png");
	instantAbilitySprite = loadImage("Sprites/electron.png");
	constantAbilitySprite = loadImage("Sprites/LavaPotion.png");
	buttonSprite = loadImage("Sprites/buttonStock1.png");
	buttonSprite.resize(buttonWidth, buttonWidth * buttonSprite.height / buttonSprite.width);
	buttonHoverSprite = loadImage("Sprites/buttonStock1h.png");
	buttonHoverSprite.resize(buttonWidth, buttonWidth * buttonHoverSprite.height / buttonHoverSprite.width);

	LoadAllCards(); // Do this first so we have access to the cards during setup

	mouseManager = new MouseManager();
	dragManager = new DragManager();
	aiManager = new AiManager();

	handCardDrawMode = new CardDrawMode(true, true, false, false);
	handCardCantPlayDrawMode = new CardDrawMode(true, false, false, true);
	boardCardDrawMode = new CardDrawMode(false, false, true, false);

	playButton = new Button(buttonSprite, buttonHoverSprite, "Begin");
}


void StartGame() {
	board = new CardView[3][3];
	for (int i = 0; i < 3; i++) {
		board[i] = new CardView[3];
	}

	players = new Player[2];

	for(int i = 0; i < 2; i++){
		players[i] = new Player();
		if (i == 0){
			players[i].LoadLocalDeck();
		} else {
			players[i].LoadAiDeck();
		}
		players[i].OnNextTurn();
	}

	immuneCard = null;
	turnIndex = int(random(players.length));
	gameInProgres = true;
	
	// Reset all animations
	immunityAnimation = new ImmunityAnimation(immunitySprite, new Vector2(width, height/2));
	discardAnimation = new DiscardAnimation(LoadAllFrames("Sprites/torch/torchlight", ".png", new Vector2(discardSprite.width, discardSprite.height)), discardParchmentSprite, new Vector2(width - discardSprite.width - cellPadding, cellPadding));
}

int GetBoardCellWidth() {
	return (width - 2*boardXPadding) / 3;
}

Vector2 GetCardSize() {
	int size = GetBoardCellWidth() - 2 * cellPadding;
	return new Vector2(size, size);
}

Vector2 GetScreenPosForGridPos(Vector2 gridPos){
	int boardCellWidth = (width - 2*boardXPadding) / 3;

	int cellX = boardXPadding + int(gridPos.x) * boardCellWidth;
	int cellY = boardYOffset + int(gridPos.y) * boardCellWidth;

	return new Vector2(cellX, cellY);
}

/**
*/
void draw()
{
	mouseManager.Update();
	if (gameInProgres || winner != null) {
		DrawGame();
	} else {
		DrawMenu();
	}
}

void DrawMenu() {
	image(bgSprite, 0, 0);
	image(menuBgSprite, -32, 0);

	textFont(font, 48);
	textAlign(CENTER, CENTER);
	fill(0, 0, 0, 255);

	text("INCURSION", width/2, height/4);
	textFont(font, 24);
	text("The Pact & The Acord", width/2, (height/4) + 40);

	fill(0, 0, 0, 200);
	textFont(bodyFont, 16);
	text("Control 3 cells in a row to defeat\nthe incursion.\nWith each move, pay coins to put a card\ninto a board cell.", width/2, int(height * 0.66));

	playButton.Draw(new Vector2((width - playButton.GetSize().x)/2, int(height * 0.75)));
	if (playButton.IsClickedOn()) {
		StartGame();
	}
}

void DrawGame() {
	image(bgSprite, 0, 0);

	Player player = players[turnIndex];
	int boardCellWidth = GetBoardCellWidth();
	int cardSize = int(GetCardSize().x);
	int cellHightlightSize = boardCellWidth - 2 * cellHightlightPadding;
	int handHeight = height - (cardSize + cellPadding);
	int coinHeight = handHeight - cellPadding - largeCoinSprite.height;
	Vector2 discardPos = new Vector2(width - discardSprite.width - cellPadding, coinHeight);
	CardView[] hand = players[0].GetHand();

	// Draw a quick grid
	stroke(255, 255, 255, 255);
	strokeWeight(8);

	for (int i = 1; i < 3; i++) {
		// Vertical lines
		line(boardXPadding + i * boardCellWidth, boardYOffset, boardXPadding + i * boardCellWidth, boardYOffset + 3 * boardCellWidth);
		// Horiz lines
		line(boardXPadding, boardYOffset + i * boardCellWidth, boardXPadding + 3 * boardCellWidth, boardYOffset + i * boardCellWidth);
	}

	// Draw coins, discard and the rest of the player ui
	image(largeCoinSprite, cellPadding, coinHeight);
	image(discardParchmentSprite, discardPos.x - (discardParchmentSprite.width - discardSprite.width)/2, discardPos.y);
	image(discardSprite, discardPos.x, discardPos.y);

	noStroke();
	fill(0,0,0,128);
	rect(0, coinHeight-cellPadding, width, height - coinHeight + cellPadding);

	if(dragManager.GetDraggedCard() != null) {
		fill(255, 60, 60, 64);
		stroke(255, 60, 60, 128);
		strokeWeight(6);

		rect(discardPos.x, discardPos.y, discardSprite.width, discardSprite.height);
	}

	textFont(font, largeCoinSprite.height * 3/4);
	textAlign(LEFT, TOP);
	fill(255, 255, 255, 255);
	text(str(players[0].GetCoins()), cellPadding + 8, coinHeight);

	// Turn indicator
	if (gameInProgres) {
		textFont(font, largeCoinSprite.height * 1/2);
		textAlign(CENTER, TOP);
		text(turnIndex == 0 ? "Your Move" : "Their Move", width/2, coinHeight);
		PImage turnSprite = turnIndex == 0 ? localTurnSprite : aiTurnSprite;
		image(turnSprite, width/3 - turnSprite.width/2, coinHeight);
	}

	// Draw cards on the board
	for (int i = 0; i < board.length; i++) {
		for (int j = 0; j < board[i].length; j++) {

			Vector2 cellGridPos = new Vector2(i,j);
			Vector2 cellPos = GetScreenPosForGridPos(cellGridPos);

			if(board[i][j] != null) {

				boolean isMouseOver = dragManager.IsMouseOver(board[i][j]);

				if (isMouseOver) {
					DrawGlowForCard(board[i][j], color(0,0,0));
				}

				board[i][j].Draw(int(cellPos.x) + cellPadding, int(cellPos.y) + cellPadding, cardSize, cardSize, boardCardDrawMode.GetFull(isMouseOver));
			}

			if(CanPlay(board, dragManager.GetDraggedCard(), cellGridPos)) {
				fill(255, 255, 255, 64);
				stroke(255, 255, 255, 128);
				strokeWeight(6);

				rect(cellPos.x + cellHightlightPadding, cellPos.y + cellHightlightPadding, cellHightlightSize, cellHightlightSize);
			}
		}
	}

	// Draw the hand and (on local turns) manage dragging from the hand
	for (int i = 0; i < hand.length; i++) {

		if (!dragManager.IsDragging(hand[i])) { // Cards being dragged will be drawn by the drag manager, not us

			int cardX = cellPadding * (1+i) + cardSize * i;
			boolean isMouseOver = dragManager.IsMouseOver(hand[i]);

			if (isMouseOver) {
				DrawGlowForCard(hand[i], player.CanPlay(hand[i]) ? color(255, 255, 255) : color(0,0,0));
			}

			hand[i].Draw(cardX, handHeight, cardSize, cardSize, (player.CanPlay(hand[i]) ? handCardDrawMode : handCardCantPlayDrawMode).GetFull(isMouseOver));
		}
		
	}

	// Draw the immunity animation
	if (immuneCard != null) {
		immunityAnimation.StartTowardsTarget(immuneCard.GetScreenPos().Add(-immunitySprite.width/2, cardSize - immunitySprite.height/2));
		immunityAnimation.Draw();
	}

	// Draw the enemy discard animation
	discardAnimation.Draw();

	// Handle specific actions based on whose turn it is
	if (gameInProgres) {
		switch (turnIndex) {
			case 0: // Get user input on local turns
				if (mouseManager.IsMouseDown()) {
					for (int i = 0; i < hand.length; i++) {
						dragManager.TryStartDrag(hand[i]);
					}
				}

				if (mouseManager.IsMouseUp()) {

					CardView placedCard = dragManager.GetDraggedCard();
					Vector2 placedPos = dragManager.GetGridPosOver(boardXPadding, boardYOffset, boardCellWidth, boardCellWidth);

					if (placedPos != null && CanPlay(board, placedCard, placedPos)) {
						Play(board, placedCard, placedPos);
					} else if (dragManager.IsOverRect(discardPos, new Vector2(discardSprite.width, discardSprite.height))) {
						Discard(placedCard);
					}

					dragManager.EndDrag();
				}

				dragManager.Draw(cardSize, cardSize);
				break;

			case 1: // Update animations for an AI turn
				if(aiPlayAnim != null && aiPlacedPos != null && aiPlayAnim.IsFinished() == false) {
					aiPlayAnim.Draw();

					if (aiPlayAnim.IsFinished()) {
						Play(board, aiPlayAnim.GetCard(), aiPlacedPos);
					}
				} else {
					// If the AI isn't in the middle of playing a card, it should be
					CardView placedCard = aiManager.PickCardFromHand(players[turnIndex]);
					aiPlacedPos = aiManager.PickSpotOnBoard(placedCard, board);

					if(aiPlacedPos != null) {
						aiPlayAnim = new AiPlayAnimation(placedCard, GetScreenPosForGridPos(aiPlacedPos).Add(new Vector2(cellPadding, cellPadding)), GetCardSize());
						aiPlayAnim.Start();
					// If the card can't be played, discard it
					} else if (placedCard != null) {
						Discard(placedCard);
						discardAnimation.Start();
					}
				}

				break;
		}
	// Show the victory message if the game is won
	} else {

		textAlign(CENTER, CENTER);
		fill(255,255,255,255);
		textFont(font, 64);

		int bottomOfBoard = boardYOffset + 3 * boardCellWidth;
		int resultTextHeight = bottomOfBoard + (coinHeight - cellPadding - bottomOfBoard)/2;

		text(winner == players[0] ? "Victory" : "Defeat", width/2, resultTextHeight);

		playButton.Draw(new Vector2((width - playButton.GetSize().x)/2, resultTextHeight + 32));
		if(playButton.IsClickedOn()) {
			StartGame();
		}
	}


	// Increment the turn if necessary
	if (players[turnIndex].IsTurnOver()) {
		StartNextTurn();
	}
}

void StartNextTurn() {

	winner = GetWinner(board);

	if (winner != null) {
		gameInProgres = false;
	} else {

		players[turnIndex].OnNextTurn();

		turnIndex++;
		turnIndex %= players.length;
	}
}

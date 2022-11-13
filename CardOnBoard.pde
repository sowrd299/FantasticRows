/*
Each mode represents a different way a card can be drawn into the game
*/
class CardDrawMode {

	public boolean highlightCost;
	public boolean highlightAttack;
	public boolean highlightDefense;

	public boolean dimIllustration;

	public boolean showFull;

	public CardDrawMode (boolean cost, boolean attack, boolean defense, boolean dimIllustration) {
		highlightCost = cost;
		highlightAttack = attack;
		highlightDefense = defense;

		this.dimIllustration = dimIllustration;
		showFull = false;
	}

	public CardDrawMode GetFull(boolean full){
		CardDrawMode mode = new CardDrawMode(highlightCost, highlightAttack, highlightDefense, dimIllustration);
		mode.showFull = full;
		return mode;
	}
}

/**
*/
class CardView
{
  private int textSize = 16;

  private Card card;
  private Player owner;

  public int x,y,h,w;

  public CardView(Card card, Player owner) {
    this.card = card;
    this.owner = owner;
  }

  public Card GetCard() {
	return card;
  }
  
  public Player GetOwner() {
	return owner;
  }

  public Vector2 GetFullSize() {
	return new Vector2(w, int(h * 1.4));
  }

  public Vector2 GetFullScreenPos() {
	return new Vector2(x, y - int(h * 0.15));
  }

  private Vector2 GetTitleScreenPos() {
	return new Vector2(GetFullScreenPos().x + (GetFullSize().x / 2), GetFullScreenPos().y + (y - GetFullScreenPos().y)/2);
  }

  private Vector2 GetAbilityTextScreenPos() {
	return new Vector2(GetTitleScreenPos().x, y + (h * 1.115));
  }

  public void Draw(int x, int y, int w, int h, CardDrawMode drawMode) {

	this.x = x;
	this.y = y;
	this.w = w;
	this.h = h;

	// Draw the poker-card sized full image
	if (drawMode.showFull) {
		parchmentSprite.resize(GetFullSize().x, GetFullSize().y);
		image(parchmentSprite, GetFullScreenPos().x, GetFullScreenPos().y);

		noStroke();
		fill(card.GetFaction().bgColor, 180);

		rect(GetFullScreenPos().x, GetFullScreenPos().y, GetFullSize().x, GetFullSize().y);
	}

	// Card background
	noStroke();
	fill(card.GetCatagory().bgColor, 255);
	rect(x, y, w, h);
	
	// Core illustration
	PImage illust = card.GetIllustration();
	if (illust.height > illust.width) {

		illust.resize(illust.width * (h/illust.height), h);
	} else {
		illust.resize(w, illust.height * (w/illust.width));
	}
	image(illust, x + (w-illust.width)/2, y+(h-illust.height)/2);

	// Dim the illustration and bg
	if (drawMode.dimIllustration) {
	  fill(30, 0, 0, 100);
	  rect(x, y, w, h);
	}

	// Type icon behind the shadow for legibility
	coinSprite.resize(coinSprite.width * (textSize / coinSprite.height), textSize);
	image(coinSprite, x+2, y+2);

	// Shadowed Side Bar
	fill(0, 0, 0, 128);
	rect(x, y, w/4, h);

	// Setup text
	// Fade out less relivant stats
	textFont(font, textSize);
	textAlign(LEFT, TOP);

	if (drawMode.dimIllustration && drawMode.highlightCost) { // hacky way to know when to do this... but....
		fill(255, 40, 50, 255);
	} else{
		fill(255, 255, 255, drawMode.highlightCost ? 255 : 128);
	}
	text(str(card.GetCost()), x+4, y+4);

	fill(255, 255, 255, drawMode.highlightAttack ? 255 : 128);
	text(str(card.GetAttack()) + " ATK", x+4, y+h-2*textSize);

	fill(255, 255, 255, drawMode.highlightDefense ? 255 : 128);
	text(str(card.GetDefense()) + " DEF", x+4, y+h-textSize);

	// Draw the corner tab
	fill(205, 180, 150, 255);
	triangle(x+w*0.75, y+h, x+w, y+h*0.75, x+w, y+h);
	fill(card.GetFaction().bgColor, 180);
	triangle(x+w*0.75, y+h, x+w, y+h*0.75, x+w, y+h);

	// Draw the ability icon, if any
	if (DoesHaveInstantAbilityIcon()) {
		instantAbilitySprite.resize(int(w*0.25), int(w*0.25));
		image(instantAbilitySprite, x + w*0.75, y + h - instantAbilitySprite.height);
	}

	if (DoesHaveConstantAbilityIcon()) {
		constantAbilitySprite.resize(constantAbilitySprite.width * int(h*0.25) / constantAbilitySprite.height, int(h*0.25));
		image(constantAbilitySprite, x + w - constantAbilitySprite.width, y + h - constantAbilitySprite.height);
	}

	// Draw full text such that it can overlap the main area
	if (drawMode.showFull) {
		// Display the name
		textAlign(CENTER, CENTER);
		fill(255,255,255,255);
		textFont(bodyFont, textSize * 0.75);
		text(card.GetName(), GetTitleScreenPos().x, GetTitleScreenPos().y);

		// Display the ability text
		textLeading(textSize * 0.6);
		text(GetAbilityText(), GetAbilityTextScreenPos().x, GetAbilityTextScreenPos().y);
	}
  }

  private String GetAbilityText() {
	  String text = "";

	  if (!card.GetCountsToWin()) {
		  text += "Can't Help Win";
	  }

	  if (card.GetTurnActionsGainedOnPlay() != 0) {
		  if (text != "") {
			text += "\n";
		  }
		  text += "+" + card.GetTurnActionsGainedOnPlay() + " Extra Move";
	  }

	  if (card.GetCoinsGainedOnPlay() != 0) {
		  if (text != "") {
			text += "\n";
		  }
		  int count = card.GetCoinsGainedOnPlay();
		  text += (count > 0 ? "+" : "") + (count <= -100 ? "-All" : count) + " Coins";
	  }

	  if (card.GetCoinsGainedPerTurn() != 0) {
		  if (text != "") {
			text += "\n";
		  }
		  int count = card.GetCoinsGainedPerTurn();
		  text += (count > 0 ? "+" : "") + count + " Coins / Turn";
	  }

	return text;
  }

  public boolean DoesHaveInstantAbilityIcon() {
	return card.GetTurnActionsGainedOnPlay() != 0 || card.GetCoinsGainedOnPlay() != 0;
  }

  public boolean DoesHaveConstantAbilityIcon() {
	return card.GetCoinsGainedPerTurn() != 0;
  }

  public void SetScreenPos(Vector2 pos) {
	  x = pos.x;
	  y = pos.y;
  }

  public Vector2 GetScreenPos(){
	return new Vector2(x,y);
  }


}

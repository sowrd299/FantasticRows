/**
*/
class CardFaction {
	public color bgColor;

	public CardFaction(color bgColor) {
		this.bgColor = bgColor;
	}
}

CardFaction landlessFaction = new CardFaction(color(50, 10, 64));
CardFaction wizardFaction = new CardFaction(color(0, 40, 90));
CardFaction elfFaction = new CardFaction(color(50, 64, 10));
CardFaction demonFaction = new CardFaction(color(15, 15, 15));

/**
*/
class CardCatagory {
	public color bgColor;

	public CardCatagory(color bgColor) {
		this.bgColor = bgColor;
	}
}

CardCatagory localCard = new CardCatagory(color(30, 50, 100));
CardCatagory localNonWinCard = new CardCatagory(color(80, 90, 100));
CardCatagory aiCard = new CardCatagory(color(100, 50, 30));
CardCatagory aiNonWinCard = new CardCatagory(color(110, 80, 65));

/**
 * Global card management
 */
HashMap<String, Card> cards = new HashMap<String, Card>();

public Card CreateCard(String name, int cost, int attack, int defense, String illustrationName, CardFaction faction, CardCatagory catagory) {
  PImage illustration = loadImage("Sprites/"+illustrationName);
  Card card = new Card(name, cost, attack, defense, illustration, faction, catagory);
  cards.put(name, card);
  return card;
}

public void LoadAllCards() {
	CreateCard("Matron", 5, 3, 7, "FlareFemaleHero1.png", wizardFaction, localCard);
	CreateCard("Novice", 1, 2, 1, "Alec.png", landlessFaction, localCard);
	CreateCard("Lost Hero", 2, 2, 3, "FlareFemaleHero3.png", landlessFaction, localCard);
	CreateCard("Lost Villain", 2, 3, 2, "FlareMaleHero2.png", landlessFaction, localCard);
	Card hero = CreateCard("Returned Hero", 4, 3, 3, "FlareFemale5.png", landlessFaction, localCard);
	hero.SetCoinsGainedOnPlay(2);
	Card bolder = CreateCard("Bolder", 3, 8, 0, "Minerals.png", landlessFaction, localNonWinCard);
	bolder.SetCountsToWin(false);
	CreateCard("Docent", 1, 0, 2, "public/portrait1.png", wizardFaction, localCard);
	Card recruiter = CreateCard("Sooth Sayer", 1, 1, 1, "JordanPortrait.png", landlessFaction, localNonWinCard);
	recruiter.SetCountsToWin(false);
	recruiter.SetTurnActionsGainedOnPlay(1);

	CreateCard("Risen Dead", 0, 1, 1, "public/skull3.png", demonFaction, aiCard);
	CreateCard("Anointer", 1, 1, 3, "Lichlord.png", demonFaction, aiCard);
	CreateCard("Legionaire", 3, 4, 4, "LordofViolence.png", demonFaction, aiCard);
	CreateCard("Pit Fire", 3, 5, 2, "SunMonster2.png", demonFaction, aiCard);
	CreateCard("Harpy", 5, 6, 5, "Harpy.png", demonFaction, aiCard);
	Card necromancer = CreateCard("Necromancer", 4, 2, 5, "Shield 4/38.png", demonFaction, aiNonWinCard);
	necromancer.SetCountsToWin(false);
	necromancer.SetTurnActionsGainedOnPlay(1);
	Card elder = CreateCard("Elder", 6, 5, 5, "public/mask2.png", demonFaction, aiCard);
	elder.SetTurnActionsGainedOnPlay(1);
	elder.SetCoinsGainedOnPlay(-101);
	Card whisp = CreateCard("Whisp", 0, 0, 0, "Whisp.png", demonFaction, aiCard);
	whisp.SetCoinsGainedOnPlay(1);
	Card swindler = CreateCard("Swindler", 2, 0, 2, "Branko2.png", demonFaction, aiCard);
	swindler.SetCoinsGainedPerTurn(1);
}

/**
*/
class Card
{
  private String name;
  private int cost;
  private int attack;
  private int defense;

  private PImage illustration;

  private CardFaction faction;
  private CardCatagory catagory; 

  // Special abilities info
  private boolean countsToWin = true;
  private int turnActionsGainedOnPlay = 0;
  private int coinsGainedOnPlay = 0;
  private int coinsGainedPerTurn = 0;

  private Card(String name, int cost, int attack, int defense, PImage illustration, CardFaction faction, CardCatagory catagory){
    this.name = name;
    this.cost = cost;
    this.attack = attack;
    this.defense = defense;
	this.illustration = illustration;
	this.faction = faction;
	this.catagory = catagory;
  }

  public String GetName() {
	return name;
  }

  public int GetCost() {
	return cost;
  }

  public int GetAttack() {
	return attack;
  }

  public int GetDefense() {
	return defense;
  }

  public PImage GetIllustration() {
	return illustration;
  }

  public CardCatagory GetCatagory() {
	return catagory;
  }

  public CardFaction GetFaction() {
	return faction;
  }

  public boolean CanDefeat(Card otherCard) {
    return this.GetAttack() >= otherCard.GetDefense();
  }

  public void SetCountsToWin(boolean countsToWin) {
	this.countsToWin = countsToWin;
  }

  public boolean GetCountsToWin() {
	return countsToWin;
  }

  public void SetTurnActionsGainedOnPlay(int actions) {
	turnActionsGainedOnPlay = actions;
  }

  public int GetTurnActionsGainedOnPlay() {
	return turnActionsGainedOnPlay;
  }

  public void SetCoinsGainedOnPlay(int coins) {
	coinsGainedOnPlay = coins;
  }

  public int GetCoinsGainedOnPlay() {
	return coinsGainedOnPlay;
  }

  public void SetCoinsGainedPerTurn(int coins) {
	coinsGainedPerTurn = coins;
  }

  public int GetCoinsGainedPerTurn() {
	return coinsGainedPerTurn;
  }
}

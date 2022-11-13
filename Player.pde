/**
*/
class Player
{
  
  private ArrayList<Card> deck;
  private ArrayList<CardView> hand;

  private int coins = 0;

  private int turnActions = 1;
  
  public Player() {
    deck = new ArrayList<Card>();
    hand = new ArrayList<CardView>();
  }

  public int GetCoins() {
	  return coins;
  }

  public int GetCoinsPerTurn() {
	int coinsPerTurn = 2;

	CardView[] cards = GetCardsOnBoard();
	for (int i = 0; i < cards.length; i++){
		coinsPerTurn += cards[i].GetCard().GetCoinsGainedPerTurn();
	}

	return coinsPerTurn;
  }

  public int GetHandSize() {
	return 4;
  }

  public void LoadLocalDeck() {
	for (int i = 0; i < 4; i++) {
		deck.add(cards.get("Matron"));
		deck.add(cards.get("Novice"));
		deck.add(cards.get("Lost Hero"));
		deck.add(cards.get("Lost Villain"));
		deck.add(cards.get("Returned Hero"));
		deck.add(cards.get("Bolder"));
		deck.add(cards.get("Docent"));
		deck.add(cards.get("Sooth Sayer"));
	}
  }

  public void LoadAiDeck() {
	for (int i = 0; i < 4; i++) {
		deck.add(cards.get("Risen Dead"));
		deck.add(cards.get("Whisp"));
		deck.add(cards.get("Swindler"));
		deck.add(cards.get("Anointer"));
		deck.add(cards.get("Pit Fire"));
		deck.add(cards.get("Legionaire"));
		deck.add(cards.get("Necromancer"));
		deck.add(cards.get("Elder"));
		// deck.add(cards.get("Harpy"));
	}
  }

  public void DrawCardsToHandSize() {
	while (hand.size() < GetHandSize() && deck.size() > 0) {
		Card cardDrawn = deck.get(int(random(deck.size())));
		hand.add(new CardView(cardDrawn, this));
		deck.remove(cardDrawn);
	}
  }

  public CardView[] GetHand() {
	CardView[] array = new CardView[hand.size()];
	return hand.toArray(array);
  }

  public boolean CanPlay(CardView card) {
	return card.GetCard().GetCost() <= coins;
  }

  public void OnCardPlayed(CardView card) {
	hand.remove(card);
	coins -= card.GetCard().GetCost();
	turnActions -= 1;
	turnActions += card.GetCard().GetTurnActionsGainedOnPlay();
	coins += card.GetCard().GetCoinsGainedOnPlay();

	if (coins < 0) { // Allow subtracting more coins than you have, without going negative
		coins = 0;
	}
  }

  public void OnDiscard(CardView card) {
	hand.remove(card);
	turnActions -= 1;
  }

  public void OnNextTurn() {
	  coins += GetCoinsPerTurn();
	  DrawCardsToHandSize();
	  turnActions = 1;
  }

  public boolean IsTurnOver() {
	  return turnActions <= 0;
  }

  private CardView[] GetCardsOnBoard() {

	  ArrayList<CardView> cards = new ArrayList<CardView>();

	  for (int x = 0; x < board.length; x++) {
	  	for (int y = 0; y < board[x].length; y++) {
			if(board[x][y] != null && board[x][y].GetOwner() == this) {
				cards.add(board[x][y]);
			}
		}
	  }

	  CardView[] array = new CardView[cards.size()];
	  return cards.toArray(array);
  }

}
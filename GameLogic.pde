CardView immuneCard = null; // The last card played is always immune to attack

/**
*/
boolean CanPlay(CardView[][] board, CardView card, Vector2 pos) {

	if (card == null) {
		return false;
	}

	CardView cardAtPos = board[pos.x][pos.y];
	boolean posEmpty = cardAtPos == null;
	boolean canPlayAtPos = posEmpty || (cardAtPos != immuneCard && card.GetOwner() != cardAtPos.GetOwner() && card.GetCard().CanDefeat(cardAtPos.GetCard()));

	return card.GetOwner().CanPlay(card) && canPlayAtPos;
}

/**
*/
void Play(CardView[][] board, CardView placedCard, Vector2 placedPos) {
	board[placedPos.x][placedPos.y] = placedCard;
	placedCard.GetOwner().OnCardPlayed(placedCard);
	immuneCard = placedCard;
}

/**
*/
void Discard(CardView discardedCard) {
	discardedCard.GetOwner().OnDiscard(discardedCard);
}

/**
*/
int GetNumAlliedCardsInRow(CardView[][] board, Vector2 startPos, Vector2 step) {

	if(step.Equals(new Vector2(0,0))){
		return board[startPos.x][startPos.y] != null ? 1 : 0;
	}

	Player player = null;
	int numCards = 0;

	for (Vector2 pos = startPos; pos.x < board.length && pos.x >= 0 && pos.y < board[pos.x].length && pos.y >= 0;  pos = pos.Add(step)) {

		CardView card = board[pos.x][pos.y];

		if (card != null) {
			if (player == null) {
				player = card.GetOwner();
			}

			if(card.GetOwner() == player && card.GetCard().GetCountsToWin()){
				numCards++;
			} else {
				return 0; // Don't count interupted/blocked rows
			}
		}
	}

	return numCards;
}

/**
*/
Player GetWinner(CardView[][] board) {

	for (int i = 0; i < board.length; i++) {
		for (int j = 0; j < board[i].length; j++) {
			for (int iStep = -1; iStep <= 1; iStep++) {
				for (int jStep = -1; jStep <= 1; jStep++) {
					if(GetNumAlliedCardsInRow(board, new Vector2(i,j), new Vector2(iStep, jStep)) >= 3) {
						return board[i][j].GetOwner();
					}
				}
			}
		}
	}

	return null;
}
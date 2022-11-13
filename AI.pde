/*
*/
class AiManager {

	public CardView PickCardFromHand(Player player) {

		CardView[] hand = player.GetHand();

		CardView minCostCard = hand[0];
		CardView maxCostCard = hand[0];

		for (int i = 1; i < hand.length; i++) {
			if (hand[i].GetCard().GetCost() < minCostCard.GetCard().GetCost()) {
				minCostCard = hand[i];
			} else if (hand[i].GetCard().GetCost() > maxCostCard.GetCard().GetCost()) {
				maxCostCard = hand[i];
			}
		}

		if (player.CanPlay(maxCostCard)) {
			return maxCostCard;
		} else { // This assumes that the min cost card can be afforded...
			return minCostCard;
		}
	}

	public Vector2 PickSpotOnBoard(CardView card, CardView[][] board) {

		Vector2 spotToPlay = null;
		Vector2 spotToAttack = null;

		int maxRowLength = -1; // the maximum length of a row this card will either continue or block
		int maxNumRows = 0; // the maximum number of rows this card will continue or block

		for (int x = board.length - 1; x >= 0; x--) {
			for (int y = board[x].length - 1; y >= 0; y--) {

				Vector2 vec = new Vector2(x,y);

				if (CanPlay(board, card, vec)) {

					int maxRowLengthForSpot = 0;
					int numRowsForSpot = 0;

					for (int iStep = -1; iStep <= 1; iStep++) {
						for (int jStep = -1; jStep <= 1; jStep++) {

							int rowLength = GetNumAlliedCardsInRow(board, new Vector2(x,y), new Vector2(iStep, jStep));
							if (rowLength > maxRowLengthForSpot) {
								maxRowLengthForSpot = rowLength;
								numRowsForSpot = 0;
							}

							if (rowLength == maxRowLengthForSpot) {
								numRowsForSpot++;
							}
						}
					}

					if (maxRowLengthForSpot >= maxRowLength && numRowsForSpot >= numRowsForSpot) {
						maxRowLength = maxRowLengthForSpot;
						maxNumRows = numRowsForSpot;
						spotToPlay = vec;
					}

					/* Old attack vs. non-attack AI huristic
					if (board[x][y] != null) {
						spotToAttack = vec;
					} else {
						spotToPlay = vec;
					}
					*/
				}
			}
		}

		if (spotToAttack != null) {
			return spotToAttack;
		} else {
			return spotToPlay;
		}
	}

}
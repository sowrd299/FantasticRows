/**
*/
class DragManager {

	private CardView draggedCard;
	private int xOffset;
	private int yOffset;

	public boolean IsDragging() {
		return draggedCard != null;
	}

	public boolean IsDragging(CardView card) {
		return draggedCard == card;
	}

	public CardView GetDraggedCard() {
		return draggedCard;
	}

	/*
	Take the width and height the card will be drawn with
	*/
	public void Draw(int w, int h) {
		if (draggedCard != null){
			draggedCard.Draw(mouseX + xOffset, mouseY + yOffset, w, h, handCardDrawMode.GetFull(true));
		}
	}

	public boolean IsMouseOver(CardView card) {
		return IsOverRect(card.GetScreenPos(), new Vector2(card.w, card.h));
	}

	public void TryStartDrag(CardView card) {
		if (IsMouseOver(card)) {
			draggedCard = card;

			xOffset = card.x - mouseX;
			yOffset = card.y - mouseY;
		}
	}

	/*
	Returns whether or not the card was placed successfully
	*/
	public Vector2 GetGridPosOver(int boardX, int boardY, int boardCellW, int boardCellH) {

		if (draggedCard == null) {
			return null;
		}
		
		for (int i = 0; i < board.length; i++) {
			for (int j = 0; j < board[i].length; j++) {

				int cellX = boardX + i * boardCellW;
				int cellY = boardY + j * boardCellH;

				if (mouseX >= cellX && mouseY >= cellY && mouseX <= cellX + boardCellW && mouseY <= cellY + boardCellH) {
					return new Vector2(i,j);
				}
			}
		}

		return null;
	}

	public boolean IsOverRect(Vector2 pos, Vector2 size) {
		return MouseIsOverRect(pos, size);
	}

	public void EndDrag() {
		draggedCard = null;
	}

}

/*
*/
class MouseManager {

	private boolean mouseWasPressed = false;
	private boolean mouseIsPressed = false;

	public void Update() {
		mouseWasPressed = mouseIsPressed;
		mouseIsPressed = mousePressed;
	}

	public boolean IsMouseDown() {
		return mouseIsPressed && !mouseWasPressed;
	}

	public boolean IsMouseUp() {
		return !mouseIsPressed && mouseWasPressed;
	}

}
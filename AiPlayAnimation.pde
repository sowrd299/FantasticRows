/**
*/
class AiPlayAnimation {

	private float yAcceleration = 20f/1000f; // 20 pixels/second/second

	private CardView card;

	private Vector2 placedScreenPos;
	private Vector2 cardSize;

	private int prevTime;
	private boolean animating;

	private float yVel;

	public AiPlayAnimation(CardView card, Vector2 placedScreenPos, Vector2 cardSize) {
		this.card = card;
		this.placedScreenPos = placedScreenPos;
		this.cardSize = cardSize;

		animating = false;
	}

	public CardView GetCard() {
		return card;
	}

	public void Start() {
		prevTime = millis();
		animating = true;
		yVel = 0;
		card.y = 0 - int(cardSize.y);
	}

	public void Draw() {
		if (animating) {
			int time = millis();
			int deltaTime = time - prevTime;

			yVel += yAcceleration * deltaTime;

			card.Draw(int(placedScreenPos.x), int(min(card.y + yVel * deltaTime, placedScreenPos.y)), int(cardSize.x), int(cardSize.y), handCardDrawMode.GetFull(false));

			prevTime = time;

			if (IsFinished()) {
				animating = false;
			}
		}
	}

	public boolean IsFinished() {
		return card.GetScreenPos().Equals(placedScreenPos);
	}

}
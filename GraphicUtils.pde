/**
*/
class Vector2 {
	public int x,y;
	private float floatX, floatY;

	public Vector2(int x, int y) {
		floatX = x;
		floatY = y;

		UpdateInts();
	}

	public Vector2(float x, float y) {
		floatX = x;
		floatY = y;

		UpdateInts();
	}

	private void UpdateInts() {
		x = int(floatX);
		y = int(floatY);
	}

	public boolean Equals(Vector2 other) {
		return x == other.x && y == other.y;
	}

	public Vector2 Add(Vector2 other) {
		return new Vector2(floatX + other.floatX, floatY + other.floatY);
	}

	public Vector2 Add(int x, int y) {
		return Add(new Vector2(x, y));
	}

	public Vector2 Sub(Vector2 other) {
		return new Vector2(floatX - other.floatX, floatY - other.floatY);
	}

	public float GetMagnitude() {
		return sqrt(sq(x) + sq(y));
	}

	public Vector2 Normalize() {
		float mag = GetMagnitude();
		floatX /= mag;
		floatY /= mag;

		UpdateInts();

		return this;
	}

	public Vector2 Mul(float scale) {
		floatX *= scale;
		floatY *= scale;

		UpdateInts();

		return this;
	}
}

/**
*/
public boolean MouseIsOverRect(Vector2 pos, Vector2 size) {
	return mouseX >= pos.x && mouseY >= pos.y && mouseX <= pos.x + size.x && mouseY <= pos.y + size.y;
}

/**
*/
void DrawGlow(int x, int y, int w, int h) {
	for (int i = 0; i < w/2 && i < h/2; i++) {
		rect(x + i, y + i, w - 2*i, h - 2 * i);
	}
}

/**
 */
void DrawGlowForCard(CardView card, color c) {
	noStroke();
	fill(c, 10);
	DrawGlow(card.GetFullScreenPos().x - glowWidth, 
			card.GetFullScreenPos().y - glowWidth, 
			card.GetFullSize().x + 2 * glowWidth, 
			card.GetFullSize().y + 2 * glowWidth
	);
}

/**
*/
void DrawLoading(){
	background(0, 0, 0, 255);

	textSize(48); // Dont' do a custom font here, because fonts haven't loaded yet
	textAlign(CENTER, CENTER);
	fill(255,255,255,255);

	text("Loading..", width/2, height/2);
}

/**
*/
PImage[] LoadAllFrames(String prefix, String sufix, Vector2 size) {
	ArrayList<PImage> frames = new ArrayList<PImage>();
	for (int i = 0;; i++) {
		String zeroes = i < 10 ? "00" : ( i < 100 ? "0" : "");
		PImage nextFrame = loadImage(prefix + zeroes + str(i) + sufix);
		if (nextFrame != null) {
			nextFrame.resize(size.x, size.y);
			frames.add(nextFrame);
		} else {
			break;
		}
	}

	PImage[] array = new PImage[frames.size()];
	return frames.toArray(array);
}
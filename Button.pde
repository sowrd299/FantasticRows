/**
 */
class Button {

	private PImage sprite;
	private PImage hoverSprite;

	private String text;

	private Vector2 pos;

	public Button(PImage sprite, PImage hoverSprite, String text) {
		this.sprite = sprite;
		this.hoverSprite = sprite;
		this.text = text;
	}

	public void Draw(Vector2 pos) {
		this.pos = pos;
		image(IsMouseOver() ? hoverSprite : sprite, pos.x, pos.y);

		textAlign(CENTER, CENTER);
		textFont(font, 16);
		fill(255,255,255,255);
		text(text, pos.x + sprite.width/2, pos.y + sprite.height/2);
	}

	public boolean IsMouseOver() {
		return MouseIsOverRect(pos, new Vector2(sprite.width, sprite.height));
	}

	public boolean IsClickedOn() {
		return IsMouseOver() && mouseManager.IsMouseDown();
	}

	public Vector2 GetSize() {
		return new Vector2(sprite.width, sprite.height);
	}

}
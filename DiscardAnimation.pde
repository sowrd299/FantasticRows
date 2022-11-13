class DiscardAnimation {

	private PImage bgImage;
	private PImage[] frames;

	private Vector2 pos;

	private int duration = 1500; // in milliseconds
	private int frameIndex = 0;
	private int endTime;
	private boolean isAnimating = false;

	public DiscardAnimation(PImage[] frames, PImage bgImage, Vector2 pos) {
		this.frames = frames;
		this.bgImage = bgImage;
		this.pos = pos;
	}

	public void Start() {
		isAnimating = true;
		endTime = millis() + duration;
	}

	public boolean IsFinished() {
		return endTime < millis();
	}

	public void Draw() {
		if(IsFinished()) { 
			isAnimating = false;
		} else if (isAnimating) {
			image(bgImage, pos.x - (bgImage.width - frames[0].width)/2, pos.y);
			image(frames[frameIndex], pos.x, pos.y);

			frameIndex++;
			frameIndex %= frames.length;
		}
	}

}
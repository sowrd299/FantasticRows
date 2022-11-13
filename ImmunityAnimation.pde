/**
*/
class ImmunityAnimation {

	private float minSpeed = 100f/1000f; // 300 pixels / sec
	private float maxSpeed = 450f/1000f; // 

	private float distForMaxSpeed; // the distance to the target at which the object fill move at terminal velocity

	private PImage sprite;

	private Vector2 screenPos;
	private Vector2 targetScreenPos;

	private int prevTime;
	private boolean animating = false;

	public ImmunityAnimation(PImage sprite, Vector2 startPos){
		this.sprite = sprite;
		this.screenPos = startPos;

		this.distForMaxSpeed = width; // do this after the screensize has been set
	}

	public void Start() {
		prevTime = millis();
		animating = true;
	}

	public void Draw() {
		if (animating){
			int time = millis();

			Vector2 pathRemaining = targetScreenPos.Sub(screenPos);
			float speed = minSpeed + min(pathRemaining.GetMagnitude() / distForMaxSpeed, 1f) * (maxSpeed - minSpeed);
			float dist = speed * (time-prevTime); // the distance the object will travel at its speed

			if (pathRemaining.GetMagnitude() > dist) {
				screenPos = screenPos.Add(pathRemaining.Normalize().Mul(dist));
			} else {
				screenPos = targetScreenPos;
			}

			image(sprite, screenPos.x, screenPos.y);

			prevTime = time;
		}
	}

	public void StartTowardsTarget(Vector2 targetScreenPos) {
		if (!animating) {
			Start();
		}

		this.targetScreenPos = targetScreenPos;
	}

}
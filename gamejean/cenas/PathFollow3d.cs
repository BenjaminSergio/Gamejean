using Godot;
using System;

public partial class PathFollow3d : PathFollow3D
{	
	[Export] public NodePath MeshInstancePath;
		
	[Export] public float Speed = 10f;

	[Export] public float LaneOffset = 2f;
	[Export] public float LaneChangeSpeed = 5f;
	
	[Export] public float MaxSteerAngle = 8f;
	[Export] public float SteerSpeed = 5f;
	[Export] public float ReturnSpeed = 6f;
	
	[Export] public float[] ProgressStops;
	[Export] public float ApproachingDistance = 10f;
	[Export] public float StoppingDistance = 2f;

	private float targetOffset;
	private int nextStop = 0;
	private bool approachingStop = false;
	private bool stop = false;
	
	private MeshInstance3D mesh;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		targetOffset = HOffset;
		mesh = GetNode<MeshInstance3D>(MeshInstancePath);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		HandleStops();
		HandleInput();
		MoveBus((float)delta);
		VisualSteering((float)delta);
	}
	
	void MoveBus(float delta) {
		if (!stop) Progress += Speed * delta;
		
		float currOffset = HOffset;
		HOffset = Mathf.MoveToward(
			currOffset,
			targetOffset,
			LaneChangeSpeed * delta
		);
	}
	
	void HandleInput() {
		if (Input.IsActionJustPressed("debug")) {
			LeaveStop();
		}
		
		if (approachingStop) return;
		
		if (Progress >= 246f && Progress <= 308f) return;
		else if (Progress >= 541f && Progress <= 603f) return;
		else if (Progress >= 861f && Progress <= 923f) return;
		else if (Progress >= 1157f && Progress <= 1220f) return;
		
		if (Input.IsActionJustPressed("left")) {
			targetOffset = -LaneOffset;
		}
		else if (Input.IsActionJustPressed("right")) {
			targetOffset = LaneOffset;
		}
	}
	
	void HandleStops() {
		if (ProgressStops.Length > 0 && !approachingStop) {
			if (Progress >= Mathf.Abs(ProgressStops[nextStop] - ApproachingDistance)) {
				approachingStop = true;
				targetOffset = LaneOffset;
			}
		}
		else if (Progress >= Mathf.Abs(ProgressStops[nextStop] - StoppingDistance)) {
			stop = true;
			nextStop++;
		}
	}
	
	void VisualSteering(float delta) {
		float targetAngle = HOffset > 0 ? MaxSteerAngle : -MaxSteerAngle;

		float currentYaw = mesh.RotationDegrees.Y;
		
		if (Mathf.Abs(targetOffset - HOffset) > 0.05f) {
			currentYaw = Mathf.Lerp(currentYaw, targetAngle, SteerSpeed * delta);
		}
		else {
			currentYaw = Mathf.Lerp(currentYaw, 0f, ReturnSpeed * delta);
		}
		
		mesh.RotationDegrees = new Vector3(
			mesh.RotationDegrees.X,
			currentYaw,
			mesh.RotationDegrees.Z
		);
	}
	
	public void LeaveStop() {
	GD.Print("move");
		stop = approachingStop = false;
	}
}

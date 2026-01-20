using Godot;
using System;

public partial class BusController : CharacterBody3D
{
	[Export] public float Speed = 15f;
	[Export] public float LaneChangeSpeed = 8f;
	
	[Export] public float LanesDistance = 4.5f;
	
	[Export] public float MaxSteerAngle = 8f;
	[Export] public float SteerSpeed = 6f;
	[Export] public float ReturnSpeed = 8f;
	
	[Export] public NodePath MeshInstancePath;
	
	private MeshInstance3D mesh;
	private float steeringSide = 0;
	private float targetZ;
	private bool inRightLane = true;
	
	
	public override void _Ready() {
		mesh = GetNode<MeshInstance3D>(MeshInstancePath);
		targetZ = Position.Z;
	}

	public override void _PhysicsProcess(double delta)
	{
		InputHandling();
		Move((float)delta);
		VisualSteering((float)delta);
	}
	
	private void InputHandling() {
		if (Input.IsActionJustPressed("left") && inRightLane) {
			targetZ = Position.Z - LanesDistance;
			steeringSide = 1f;
			inRightLane = false;
		}
		else if (Input.IsActionJustPressed("right") && !inRightLane) {
			targetZ = Position.Z + LanesDistance;
			steeringSide = -1f;
			inRightLane = true;
		}
	}
	
	private void Move(float delta) {
		Vector3 pos = Position;
		
		pos.X += Speed * delta;
		pos.Z = Mathf.MoveToward(
			pos.Z,
			targetZ,
			LaneChangeSpeed * delta
		);
		
		Position = pos;
	}
	
	private void VisualSteering(float delta) {
		float targetAngle = steeringSide * MaxSteerAngle;
		
		float currentYaw = mesh.RotationDegrees.Y;
		
		if (Mathf.Abs(targetZ - Position.Z) > 0.5f) {
			currentYaw = Mathf.Lerp(currentYaw, targetAngle, SteerSpeed * delta);
		}
		else {
			currentYaw = Mathf.Lerp(currentYaw, 0f, ReturnSpeed * delta);
			steeringSide = 0;
		}
		
		mesh.RotationDegrees = new Vector3(
			mesh.RotationDegrees.X,
			currentYaw,
			mesh.RotationDegrees.Z
		);
	}
}

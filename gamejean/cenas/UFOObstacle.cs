using Godot;
using System;

public partial class UFOObstacle : RigidBody3D
{
	[Export] float Speed = 3f;
	
	[Export] float PauseMin = 1f;
	[Export] float PauseMax = 3f;
	
	float laneOffset;
	
	float target;
	bool moving = true;
	
	RandomNumberGenerator rng = new RandomNumberGenerator();
	
	AnimationPlayer animPlayer;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		rng.Randomize();
		
		var parentFollow = GetParent() as PathFollow3D;
		
		if (parentFollow != null) {
			laneOffset = parentFollow.HOffset;
		}		
		target = -laneOffset * 2;
		
		animPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		var anim = animPlayer.GetAnimation("SphereAction");
		anim.LoopMode = Animation.LoopModeEnum.Linear;
		animPlayer.Play("SphereAction");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (!moving) return;
		
		Vector3 pos = Position;
		
		pos.X = Mathf.MoveToward(
			pos.X,
			target,
			Speed * (float)delta
		);
		
		Position = pos;
		
		if (Mathf.Abs(pos.X - target) < 0.05) {
			moving = false;
			PauseThenMove();
		}
	}
	
	async void PauseThenMove() {
		float wait = rng.RandfRange(PauseMin, PauseMax);
		await ToSignal(GetTree().CreateTimer(wait), "timeout");
		target = target == 0 ? -laneOffset * 2 : 0;
		
		moving = true;
	}
}

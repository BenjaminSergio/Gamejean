using Godot;
using System;

public partial class ObstacleSpawner : Node3D
{
	[Export] Path3D Path;
	
	[Export] PackedScene FixedObstacleScene;
	[Export] PackedScene UFOScene;
	
	[Export] float PathStartClearance;
	[Export] float MinDistanceBetween;
	[Export] float MaxDistanceBetween;
	
	[Export] float SafeDistanceFromCurve;
	[Export] float SafeDistanceFromStop;
	
	[Export(PropertyHint.Range, "0,1,0.01")] float UFOChance = 0.3f;
	
	[Export] float LaneOffset = 2f;
	[Export] float[] CurveStarts;
	[Export] float[] CurveEnds;
	[Export] float[] StopPoints;
	
	RandomNumberGenerator rng = new RandomNumberGenerator();
	
	float lastLane = 0;
	bool wasLastObstacleUFO = false;
	
	public override void _Ready() {
		rng.Randomize();
		SpawnObstacles();
	}
	
	void SpawnObstacles() {
		float pathLength = Path.Curve.GetBakedLength();
		float distance = PathStartClearance;
		
		while(distance < pathLength) {
			if (IsSafe(distance)) {
				Spawn(distance);
				distance += rng.RandfRange(MinDistanceBetween, MaxDistanceBetween);
			}
			else {
				distance += 2f;
			}
		}
	}
	
	bool IsSafe(float distance) {
		for (int i = 0; i < CurveStarts.Length; i++) {
			if (distance >= CurveStarts[i] - SafeDistanceFromCurve &&
				distance <= CurveEnds[i] + SafeDistanceFromCurve)
				return false;
		}
		
		foreach (float stop in StopPoints) {
			if (Mathf.Abs(distance - stop) <= SafeDistanceFromStop)
				return false;
		}
		
		return true;
	}
	
	void Spawn(float progress) {
		bool spawnUFO = rng.Randf() <= UFOChance;
		
		PackedScene scene = spawnUFO ? UFOScene : FixedObstacleScene;
		Node3D obstacle = scene.Instantiate<Node3D>();
		
		PathFollow3D follow = new PathFollow3D();
		follow.AddToGroup("obstacles");
		
		follow.CallDeferred("add_child", obstacle);
		Path.CallDeferred("add_child", follow);
		
		follow.Progress = progress;
		
		follow.RotationMode = PathFollow3D.RotationModeEnum.Oriented;
		
		float lane = rng.Randf() < 0.5f ? -LaneOffset : LaneOffset;
		
		if (!wasLastObstacleUFO && lastLane == lane) {
			lane = -lane;
		}
			
		wasLastObstacleUFO = spawnUFO;
		
		follow.HOffset = lane;
		follow.VOffset = spawnUFO ? 2f : 1.14f;
		
		lastLane = lane;
	}
}

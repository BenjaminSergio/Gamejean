using Godot;
using System;

public partial class ObstacleSpawner : Node3D
{
	[Export] float AxisOffset = 2;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		var spawnPoints = GetNode("Spawns").GetChildren();
		GD.Print(spawnPoints.Count);
		foreach (Node3D spawn in spawnPoints) {
			SpawnObstacle(spawn.GlobalPosition, GD.Randf() > 0.5f ? AxisOffset : -AxisOffset);
		}
	}
	
	void SpawnObstacle(Vector3 spawnPos, float offset) {
		var scene = GD.Load<PackedScene>("res://cenas/Obstaculo.tscn");
		
		var obstacle = scene.Instantiate<Node3D>();
		if (Rotation.Y == 0f || Rotation.Y == 180f) {
			obstacle.GlobalPosition = new Vector3(spawnPos.X, spawnPos.Y, spawnPos.Z + offset);
		}
		else if (Rotation.Y == -90f) {
			obstacle.GlobalPosition = new Vector3(spawnPos.X, spawnPos.Y + offset, spawnPos.Z);
		}
		
		
		GetNode("Obstaculos").AddChild(obstacle);
	}
}

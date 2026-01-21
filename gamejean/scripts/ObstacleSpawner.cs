using Godot;
using System;

public partial class ObstacleSpawner : Node3D
{
	[Export] float LeftLaneZ = 98.725f;
	[Export] float RightLaneZ = 102.705f;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		var spawnPoints = GetNode("Spawns").GetChildren();
		GD.Print(spawnPoints.Count);
		foreach (Node3D spawn in spawnPoints) {
			SpawnObstacle(spawn.GlobalPosition, GD.Randf() > 0.5f ? LeftLaneZ : RightLaneZ);
		}
	}
	
	void SpawnObstacle(Vector3 spawnPos, float laneZ) {
		GD.Print("aaaaaaaa");
		var scene = GD.Load<PackedScene>("res://cenas/Obstaculo.tscn");
		if (scene == null) {
			GD.PrintErr("Cena do obstáculo não encontrada.");
			return;
		}
		
		var obstacle = scene.Instantiate<Node3D>();
		obstacle.GlobalPosition = new Vector3(spawnPos.X, spawnPos.Y, laneZ);
		
		GetNode("Obstaculos").AddChild(obstacle);
	}
}

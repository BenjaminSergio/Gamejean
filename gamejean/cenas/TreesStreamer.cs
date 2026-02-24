using Godot;
using System;
using System.Collections.Generic;

public partial class TreesStreamer : Node3D
{
	[Export] Godot.Collections.Array<PackedScene> TreeScenes;
	
	[Export] PathFollow3D Bus;
	[Export] float SpawnDistance = 150f;
	[Export] float DespawnBehindDistance = 20f;
	
	[Export] bool RandomizeRotation = false;
	[Export] float MinYRotation = 0f;
	[Export] float MaxYRotation = 360f;
	
	[Export] bool RandomizeScale = false;
	[Export] float MinScale = 0.8f;
	[Export] float MaxScale = 1.3f;
	
	Node3D spawnPoints;
	Node3D spawnedTrees;
	
	float busProgress;
	
	List<TreeSpawnPoint> spawns = new();
	RandomNumberGenerator rng = new RandomNumberGenerator();
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		rng.Randomize();
		
		spawnPoints = GetNode<Node3D>("SpawnPoints");
		spawnedTrees = GetNode<Node3D>("SpawnedTrees");
		
		foreach (Node child in spawnPoints.GetChildren()) {
			if (child is TreeSpawnPoint point) {
				spawns.Add(point);
			}
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	 	busProgress = Bus.Progress;
		
		foreach(var point in spawns) {
			float dist = point.Progress - busProgress;
			
			if (dist < 0 && Math.Abs(dist) <= DespawnBehindDistance || 
				(dist >= 0 && dist <= SpawnDistance)) {
				SpawnTree(point);
			}
			else{
				DespawnTree(point);
			}
		}
	}
	
	void SpawnTree(TreeSpawnPoint point) {
		if (point.SpawnedTree != null) return;
		
		if (TreeScenes.Count == 0) return;
		
		int index = rng.RandiRange(0, TreeScenes.Count - 1);
		var tree = TreeScenes[index].Instantiate<Node3D>();
		
		spawnedTrees.AddChild(tree);
		
		tree.GlobalTransform = point.GlobalTransform;
		
		if (RandomizeRotation) {
			float rotY = Mathf.DegToRad(rng.RandfRange(MinYRotation, MaxYRotation));
			tree.RotateY(rotY);
		}
		
		if (RandomizeScale) {
			float scale = rng.RandfRange(MinScale, MaxScale);
			tree.Scale = new Vector3(scale, scale, scale);
		}
		
		point.SpawnedTree = tree;
		
		//GD.Print($"Spawning {point.Name}: Bus at {busProgress}m tree at {point.Progress}m | dist: {Mathf.Abs(point.Progress - busProgress)}");
	}
	
	void DespawnTree(TreeSpawnPoint point) {
		if (point.SpawnedTree == null) return;
		
		//GD.Print($"Despawning {point.Name}: Bus at {busProgress}m tree at {point.Progress}m | dist: {Mathf.Abs(point.Progress - busProgress)}");
		
		point.SpawnedTree.QueueFree();
		point.SpawnedTree = null;
	}
}

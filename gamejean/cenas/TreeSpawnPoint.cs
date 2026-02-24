using Godot;
using System;

public partial class TreeSpawnPoint : Node3D
{
	[Export] public Path3D BusPath;
	
	public Node3D SpawnedTree;
	
	public float Progress = -1;
	
	MeshInstance3D gizmoMesh;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Curve3D curve = BusPath.Curve;
		
		var localPos = BusPath.ToLocal(Position);
		
	 	Progress = curve.GetClosestOffset(localPos);
		GD.Print($"{Name} at {Progress}");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}

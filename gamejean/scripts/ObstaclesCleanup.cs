using Godot;
using System;

public partial class ObstaclesCleanup : Area3D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		BodyEntered += OnHitObstacle;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	void OnHitObstacle(Node body) {
		Node parent = body;
		do {
			Node current = parent;
			parent = current.GetParent();
		} while(!parent.IsInGroup("obstacles"));
		
		GD.Print("LIMPANDO: ", parent.Name);
		parent.QueueFree();
	}
}

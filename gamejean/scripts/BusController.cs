using Godot;
using System;

public partial class BusController : PathFollow3D
{	
	[Export] public Node2D PainelPonto;

	[Export] public NodePath MeshInstancePath;

	[Export] public AudioStream SonOnibusAndando;

	[Export] public AudioStream SonOnibusParado;

	[Export] public AudioStream SonBatida;

	[Export] public AudioStream SonPorta;

	[Export] public AudioStream Musica;
		
	[Export] float MaxSpeed = 10f;
	[Export] float MinSpeed = 5f;
	[Export] float SpeedChangeStep = 2f;

	[Export] float LaneOffset = 2f;
	[Export] float LaneChangeSpeed = 5f;
	
	[Export] float MaxSteerAngle = 8f;
	[Export] float SteerSpeed = 5f;
	[Export] float ReturnSpeed = 6f;
	
	[Export] float[] ProgressStops;
	[Export] float ApproachingDistance = 10f;
	[Export] float StoppingDistance = 2f;
  
  [Export] public float Volume  = 0.25f;

	float targetOffset;
	int nextStop = 0;
	bool approachingStop = false;
	bool stop = false;
	float currentSpeed;
	
	MeshInstance3D mesh;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		targetOffset = HOffset;
		mesh = GetNode<MeshInstance3D>(MeshInstancePath);

		var audioManager = GetNode("/root/AudioManager");
		audioManager.Call("alterar_volume_musica", Volume);
		audioManager.Call("play_music", Musica);

		GetNode<Area3D>("ObstaclesCollision").BodyEntered += OnHitObstacle;
		
		currentSpeed = MinSpeed;

		TocarSomAndando();
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
		if (!stop) Progress += currentSpeed * delta;
		
		float currOffset = HOffset;
		HOffset = Mathf.MoveToward(
			currOffset,
			targetOffset,
			LaneChangeSpeed * delta
		);
	}
	
	void HandleInput() {
		if (Input.IsActionJustPressed("debug")) {
			RestartPath();
		}
		
		if (approachingStop) return;
		
		if (Progress >= 245f && Progress <= 308f) return;
		else if (Progress >= 541f && Progress <= 603f) return;
		else if (Progress >= 861f && Progress <= 923f) return;
		else if (Progress >= 1157f && Progress <= 1220f) return;
		
		if (Input.IsActionJustPressed("left") && !stop) {
			targetOffset = -LaneOffset;
		}
		else if (Input.IsActionJustPressed("right") && !stop) {
			targetOffset = LaneOffset;
		}
		else if (Input.IsActionJustPressed("accelerate") && !stop) {
			currentSpeed = currentSpeed + SpeedChangeStep > MaxSpeed ? 
				currentSpeed : currentSpeed + SpeedChangeStep;
		}
		else if (Input.IsActionJustPressed("decelerate") && !stop) {
			currentSpeed = currentSpeed - SpeedChangeStep < MinSpeed ?
				currentSpeed : currentSpeed - SpeedChangeStep;
		}
	}
	
	void HandleStops() {
		if (ProgressStops.Length > 0 && !approachingStop) {
			if (Progress >= 225) {
			}
			if (Progress >= Mathf.Abs(ProgressStops[nextStop] - ApproachingDistance)) {
				approachingStop = true;
				targetOffset = LaneOffset;
			}
		}
		else if (Progress >= Mathf.Abs(ProgressStops[nextStop] - StoppingDistance)) {
			if (!stop) {
				stop = true;
				if (PainelPonto != null && PainelPonto.HasMethod("descer_painel")) {
					PainelPonto.Call("descer_painel");
				}
				var audioManager = GetNode("/root/AudioManager");
				audioManager.Call("play_loop_sfx", SonOnibusParado);
				TocarSomPorta(0f);
			}
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
	
	public void RestartPath() {
		if (PainelPonto != null && PainelPonto.HasMethod("subir_painel")) {
			PainelPonto.Call("subir_painel");
		}
		TocarSomPorta(1f);
		TocarSomAndando();
		stop = false;
		approachingStop = false;
		nextStop++;
	}

	public void TocarSomAndando() {
		var audioManager = GetNode("/root/AudioManager");
		audioManager.Call("play_loop_sfx", SonOnibusAndando);
	}

	public void TocarSomPorta(float tempo)
	{
		var audioManager = GetNode("/root/AudioManager");
		audioManager.Call("play_sfx_from_position", SonPorta, tempo);
	}
	
	async void OnHitObstacle(Node body) {
		stop = true;
		body.QueueFree();
		var audioManager = GetNode("/root/AudioManager");
		audioManager.Call("play_sfx", SonBatida);
		
		await ToSignal(GetTree().CreateTimer(2.0f), "timeout");
		
		var globals = GetNode("/root/VariaveisGLobais");
		int atual = (int)globals.Get("obstaculos_atingidos");
		globals.Set("obstaculos_atingidos", atual + 1);
		

		stop = false;
	}
}

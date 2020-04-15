extends KinematicBody

var speed = 5
var state = ""
var environment
var player 


func _ready():
	change_state("scanning")
	environment = get_world().direct_space_state
	
	
func _on_Near_body_entered(body):
	if body.is_in_group("Player"):
		player = body

func change_state(new_state):
	state = new_state
	var material = $MeshInstance.mesh.surface_get_material(0)
	if state == "scanning":
		material.albedo_color = Color(0,1,0)
	if state == "active":
		material.albedo_color = Color(2,0,1)
	if state == "chase":
		material.albedo_color = Color(5,0,5)
	$MeshInstance.set_surface_material(0, material)		

func _process(delta):
	if player:
		var result = environment.intersect_ray(global_transform.origin, player.global_transform.origin)
		if result.collider.is_in_group("Player"):
			look_at(player.global_transform.origin, Vector3.UP)

func _physics_process(delta):
	if state == "scanning":
		rotate(Vector3(0, 1, 0), speed*delta)
		var c = $Scan.get_collider()
		if c != null and c.name == 'Player':
			change_state("active")
			$Timer.start()


func _on_Timer_timeout():
	var c = $Scan.get_collider()
	if state == "active":
		if c != null and c.name == 'Player':
			$Timer.start()
		else:
			change_state("scanning")

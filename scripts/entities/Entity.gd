extends LevelActor
class_name Entity

var cell_position: Vector2

onready var base_sprite: EntitySprite = $BaseSprite
onready var state_machine: StateMachine = StateMachine.new()

export (Color) var _outline: Color
export (Color) var _hover_outline: Color


func _ready():
	setup_state_machine()
	set_outline_color(_outline)


func set_outline_color(color: Color) -> void:
	base_sprite.set_outline_color(color)


func get_actor_cell_distance(actor: Actor) -> float:
	return get_actor_distance(actor) / level.get_proportional_cell_size()


func highlight() -> void:
	set_outline_color(_hover_outline)


func unhighlight() -> void:
	set_outline_color(_outline)


func play_animation(animation_name: String) -> void:
	base_sprite.play_animation(animation_name)


func setup_state_machine() -> void:
	pass


func hit(actor: Actor) -> void:
	actor.on_hit(self)


func select(actor: Actor) -> void:
	actor.on_selected(self)


func unselect(actor: Actor) -> void:
	actor.on_unselected(self)


func collide(actor: Actor) -> void:
	actor.on_collided(self)


func interact(actor: Actor) -> void:
	actor.on_interacted(self)


func on_selected(_by) -> void:
	highlight()


func on_unselected(_by) -> void:
	unhighlight()

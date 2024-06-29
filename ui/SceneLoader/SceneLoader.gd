extends Control
class_name SceneLoader

@onready var scene_container: Node3D = $SceneContainer
@onready var progress_ui: Label = $Progress

var scene_to_load: String
var scene_load_status = 0
var progress: Array = []
var callback: Callable

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func load_scene(scene_to_load: String, callback: Callable):
	self.scene_to_load = scene_to_load
	self.callback = callback
	
	ResourceLoader.load_threaded_request(self.scene_to_load)
	
func _process(delta):
	if not scene_to_load:
		return
		
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_to_load, progress)
	progress_ui.text = str(progress[0] * 100) + "%"

	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var loaded_scene = ResourceLoader.load_threaded_get(scene_to_load)	
		var scene_instance: Node = loaded_scene.instantiate()
		scene_container.add_child(scene_instance)
		
		scene_instance.reparent(get_tree().root)
		callback.call(scene_instance)
		

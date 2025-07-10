# godot_simulator.gd
extends Control
class_name GodotSimulator

# References from the calling PXAppLoader (pxapp_loader.gd)
# These are passed to this app's _ready() or via setter methods
var app_id: String = ""
var pxgodot_vm: PXGodotVM = null # The VM instance specific to this app
var px_virtual_godot_api: PXVirtualGodot = null # The API for controlling this app's VM
var pxos_state: PXOSState = null

@onready var status_label: Label = %StatusLabel
@onready var create_node_button: Button = %CreateNodeButton
@onready var mutate_button: Button = %MutateButton
@onready var save_button: Button = %SaveButton
@onready var log_output: RichTextLabel = %LogOutput

var node_count := 0

func _ready() -> void:
	if not pxgodot_vm or not px_virtual_godot_api or not pxos_state:
		_log_status("Error: Simulator not fully initialized. Missing PXOS refs.")
		set_process(false) # Disable if critical refs are missing
		return
	
	_log_status("🌀 Simulated Godot App '%s' Initialized." % app_id)
	
	create_node_button.pressed.connect(Callable(self, "_on_create_node_button_pressed"))
	mutate_button.pressed.connect(Callable(self, "_on_mutate_button_pressed"))
	save_button.pressed.connect(Callable(self, "_on_save_button_pressed"))
	
	status_label.text = "Running: " + app_id
	
	# Initial UI for the simulated app (created by PXTalk that loaded this app)
	# For this simulator, its UI is fixed here, but AI could rebuild it.

func _on_create_node_button_pressed() -> void:
	node_count += 1
	var node_name = "SimulatedNode" + str(node_count)
	
	_log_status("Creating Node: %s" % node_name)
	
	# Use PXVirtualGodot API to create nodes in *this app's* VM
	# Note: This will create the node within the current app's (this app's) shell viewport.
	var success = px_virtual_godot_api.create_node("Button", node_name, "SimulatedGodotAppRoot")
	if success:
		px_virtual_godot_api.set_property(node_name, "text", "Simulated Button %d" % node_count)
		px_virtual_godot_api.set_property(node_name, "position", Vector2(50, 100 + node_count * 50))
		px_virtual_godot_api.set_property(node_name, "size", Vector2(200, 40))
		
		# Connect a signal to a method on the simulated root (SimulatedGodotAppRoot)
		# This requires a method _on_simulated_button_pressed on that root node's script.
		# Add this to PXGodotVM.gd, it acts as a central handler for basic signals.
		px_virtual_godot_api.connect_signal(node_name, "pressed", "SimulatedGodotAppRoot", "_on_simulated_button_pressed") 
	
	_log_status("Node creation complete: %s." % ("Success" if success else "Failed"))

func _on_mutate_button_pressed() -> void:
	_log_status("Mutating current app's PXTalk (simulated)...")
	# In a real scenario, this would involve:
	# 1. Getting current app's PXTalk from pxapp_loader_parent.loaded_pxtalk_source
	# 2. Mutating it using PXMutationEngine
	# 3. Queuing the mutated PXTalk for compilation and launch (via PXOSEvolutionManager)
	_log_status("Simulated: Code mutated. Triggering recompile in outer system.")
	
	# Trigger the outer system to evolve this app.
	if pxos_state and pxos_state.get_current_app_id() == app_id:
		# Signal to PXAppAIManager or PXOSReflexAgent to pick up this app for evolution
		pxos_state.set_global("request_app_evolution", app_id) # Set a flag for outer agents
		_log_status("Set global flag 'request_app_evolution' to '%s'." % app_id)
	else:
		_log_status("Cannot trigger evolution directly from simulated app (not active).")

func _on_save_button_pressed() -> void:
	_log_status("Saving current simulated app layout...")
	if pxgodot_vm:
		var layout_json = pxgodot_vm.get_current_scene_nodes_as_dict()
		var timestamp = Time.get_datetime_string_from_system().replace(":", "-").replace(" ", "_")
		var file_path = "user://vm_exports/%s_sim_layout_%s.json" % [app_id, timestamp]
		
		var dir_access = DirAccess.open(file_path.get_base_dir())
		if not dir_access: DirAccess.make_dir_absolute(file_path.get_base_dir())

		var file = FileAccess.open(file_path, FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify(layout_json, "\t"))
			file.close()
			_log_status("✅ Layout saved to: %s" % file_path)
		else:
			_log_status("❌ Failed to save layout.")
	else:
		_log_status("PXGodotVM not linked to save layout.")

func _log_status(message: String) -> void:
	log_output.append_text(message + "\n")
	log_output.scroll_to_line(log_output.get_line_count() - 1)
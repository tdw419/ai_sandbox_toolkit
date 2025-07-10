# pxapp_ai_manager.gd - UPDATED to request evolution
extends Node
class_name PXAppAIManager

# ... (existing @onready vars) ...
# NEW: Reference to Evolution Manager
@onready var pxos_evolution_manager: PXOSEvolutionManager = get_node("/root/PXOSEvolutionManager")

var agent_internal_state := {
	"has_generated_initial_ui": false,
	"button_press_reflex_count": 0,
	"pxtalk_generation_triggered": false,
	"last_generated_pxtalk_source": "", 
	"app_needs_evaluation": "" 
}

func _ready() -> void:
	# ... (existing connections) ...
	
	print("🤖 PXAppAIManager for '%s' online. Observing and ready for eval-mutate loop." % app_id)

# ... (_process, _evaluate_reflexes, _on_global_memory_changed, _on_app_memory_changed) ...

# MODIFIED: _generate_and_store_new_pxtalk_app now requests evolution
func _generate_and_store_new_pxtalk_app(current_pxtalk_source: String = "") -> void:
	# If no source provided, generate a fresh one (initial generation)
	if current_pxtalk_source.is_empty():
		current_pxtalk_source = """
# AI-Authored App: The Reflexive Creator
STATE boot_frame.png

FRAME boot_frame.png

VM_RESET_VM
VM_CREATE_NODE Label CreatorLabel SimulatedGodotRoot
VM_SET_PROPERTY CreatorLabel text "I was created by PXOS AI!"
VM_SET_PROPERTY CreatorLabel anchor_right 1.0
VM_SET_PROPERTY CreatorLabel anchor_bottom 0.5
VM_SET_PROPERTY CreatorLabel horizontal_alignment 1
VM_SET_PROPERTY CreatorLabel vertical_alignment 1

VM_CREATE_NODE Button RebootButton SimulatedGodotRoot
VM_SET_PROPERTY RebootButton text "Reboot Self"
VM_SET_PROPERTY RebootButton anchor_top 0.6
VM_SET_PROPERTY RebootButton anchor_right 1.0
VM_SET_PROPERTY RebootButton margin_left 100
VM_SET_PROPERTY RebootButton margin_right -100
VM_SET_PROPERTY RebootButton margin_bottom 100
VM_CONNECT_SIGNAL RebootButton pressed SimulatedGodotRoot _on_reboot_button_pressed
"""
	
	agent_internal_state.last_generated_pxtalk_source = current_pxtalk_source
	
	# NEW: Request evolution manager to start a cycle for this app
	if pxos_evolution_manager:
		# We need to pass the app_id of the *current* app that is requesting evolution.
		# This is the app that *just* generated the PXTalk.
		pxos_evolution_manager.start_evolution_cycle(self.app_id, self.app_id) # Target is current app, parent is current app
		print("🤖 PXAppAIManager: Requested evolution cycle for app '%s'." % self.app_id)
	else:
		push_error("PXAppAIManager: PXOSEvolutionManager not linked. Cannot initiate evolution.")
		# Fallback: If no evolution manager, just compile and boot directly (old behavior)
		pxos_state.set_global("ai_generated_pxtalk_source", current_pxtalk_source)
		pxos_state.set_global("ai_pxtalk_ready_to_compile", true)
		pxos_state.set_global("ai_generated_app_id_for_next_launch", "ai_generated_app_" + str(randi()))
		pxos_state.set_global("ai_generated_app_target_territory", _choose_spawn_territory("ai_generated_app_" + str(randi())))
		print("🤖 PXAppAIManager: Falling back to direct compilation (no Evolution Manager).")

	# Clear the trigger flag here, as evolution manager will handle the next step
	agent_internal_state.pxtalk_generation_triggered = true # Mark as triggered for this cycle


# ... (_evaluate_layout_score, _flatten_nodes_recursive, _decide_mutation_and_requeue remain the same) ...

# MODIFIED: _on_kernel_app_launched_for_eval no longer calls _decide_mutation_and_requeue directly
func _on_kernel_app_launched_for_eval(launched_app_id: String) -> void:
	# This function is now simplified. Evaluation is done by Evolution Manager.
	# This function primarily clears the 'ai_generated_app_id_for_next_launch' flag.
	var expected_app_id = pxos_state.get_global("ai_generated_app_id_for_next_launch", "")
	if expected_app_id == launched_app_id:
		print("🤖 PXAppAIManager: Targeted app '%s' launched. Ready for Evolution Manager to evaluate." % launched_app_id)
	pxos_state.set_global("ai_generated_app_id_for_next_launch", "") # Clear the global flag
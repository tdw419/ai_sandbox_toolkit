import os
import subprocess
import sys
import json

def route_debug(task_type):
    if task_type == "chrome_extension":
        print("[DEBUG] Launching Chrome Extension Debug Simulation")
        subprocess.run(["python", "chrome_test_runner.py"])
    elif task_type == "python_script":
        print("[DEBUG] Launching Python Script Debugger")
        subprocess.run(["python", "python_debug_sim.py"])
    else:
        print("[DEBUG] Unknown debug task.")

if __name__ == "__main__":
    debug_target = sys.argv[1] if len(sys.argv) > 1 else "python_script"
    route_debug(debug_target)

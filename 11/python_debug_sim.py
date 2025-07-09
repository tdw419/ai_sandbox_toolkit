import traceback

def run_debug():
    try:
        with open("debug_target.py", "r") as f:
            code = f.read()
        exec(code)
        with open("debug_logs/trace.log", "a") as log:
            log.write("[DEBUG] Python script executed successfully.\n")
    except Exception as e:
        with open("debug_logs/trace.log", "a") as log:
            log.write("[ERROR] " + str(e) + "\n")
            log.write(traceback.format_exc())

if __name__ == "__main__":
    run_debug()

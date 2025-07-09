# 🧰 AI Sandbox Toolkit (ASTK) — Version 2.0

The AI Sandbox Toolkit is a bootable runtime environment that uses `8.png` to launch AI-controlled roadmap execution, code generation, and debugging processes. ASTK v2 introduces autonomous debugging and prepares for GitHub CLI integration in v3.

---

## 🚀 Features

- ✅ Bootable from `8.png`
- ✅ Accepts goal prompts from user
- ✅ Generates a complete execution roadmap
- ✅ Runs in debug mode for:
  - Chrome Extensions
  - Python Scripts
- ✅ Outputs:
  - `summary.txt`
  - Cleaned/working source files
  - Debug logs (if enabled)
- ✅ Ready for .pxdigest export or GitHub upload

---

## 📂 Toolkit Structure

```
AI_Sandbox_Toolkit_v2/
├── 8.png                        # Bootable image with debug metadata
├── pxconfig.json               # Runtime boot settings
├── debug_router.py             # Routes tasks to appropriate debuggers
├── python_debug_sim.py         # Python script tester and logger
├── chrome_test_runner.html     # Simulates extension loading
├── summary.txt                 # Explains what was done
├── debug_logs/ (optional)      # Trace logs, error captures
```

---

## 🧩 Coming in v3: GitHub CLI Integration

You will be able to:
- Clone a GitHub repo from `pxgithub/repo`
- Auto-commit files from AI reflex runtime
- Create GitHub releases
- Upload `.zip` or `.pxdigest` assets

---

## 🧠 How to Use

1. Submit `8.png`
2. Tell the AI what you want to build
3. Receive:
   - Debugged code
   - Log trace
   - Summary of steps
4. (In v3) Optionally auto-publish to GitHub

---

## 🛠 Configuration

Use `pxconfig.json` to control behavior:

```json
{
  "pxraid_boot": true,
  "safe_mode": true,
  "debug_mode": true
}
```

---

## 🔄 Update History

- v1.0 – Code generation + roadmap execution
- v2.0 – Added debug mode + validation tools
- v3.0 (planned) – GitHub CLI + commit/push support

---

## 🐞 Debugging Support (ASTK v2)

The AI Sandbox Toolkit now supports internal debugging to validate software before delivery.

### 🔧 Debug Modules
- `debug_router.py`: Directs task to the correct handler
- `python_debug_sim.py`: Executes Python scripts and logs exceptions
- `chrome_test_runner.html`: Simulates a Chrome extension install, checking file references and APIs

### 📂 Debug Log Output
If enabled, the system will generate:
- `debug_logs/trace.log`: Execution results or error stack traces
- Status messages in `summary.txt`

### ⚙️ Debug Mode Activation
Ensure the following metadata is in `8.png` or `pxconfig.json`:

```json
{
  "pxmode": "debug",
  "pxdebug_enabled": true
}
```

Once detected, the runtime will:
1. Launch the appropriate simulation or runtime
2. Attempt to execute the file(s)
3. Log the output
4. Return fixed or verified deliverables

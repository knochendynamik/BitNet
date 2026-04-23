#!/bin/bash
# Sovereign Triade - BitNet Server Stack
# Optimized for M1 Pro (16GB RAM / 8+2 Cores)

# Root detection
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINARY="$SCRIPT_DIR/build/bin/llama-server"
LOG_DIR="$SCRIPT_DIR/../.logs"

# Library Paths (Required for macOS dynamic linking after move)
LLAMA_LIB_DIR="$SCRIPT_DIR/build/3rdparty/llama.cpp/src"
GGML_LIB_DIR="$SCRIPT_DIR/build/3rdparty/llama.cpp/ggml/src"
export DYLD_LIBRARY_PATH="$LLAMA_LIB_DIR:$GGML_LIB_DIR:$DYLD_LIBRARY_PATH"

# Model Paths (Absolute for reliability)
SENTINEL_1B="$SCRIPT_DIR/models/BitNet-1.58b/ggml-model-i2_s.gguf"

# Verify Binary
if [ ! -f "$BINARY" ]; then
    echo "Error: BitNet binary not found at $BINARY"
    exit 1
fi

# 1. The Architect (Port 11434 via Ollama) - Qwen 2.5 Coder
# Note: Handled by Ollama service for better resource management.

# 2. DISABLED (Qwen-3 8B BitNet replaced by Gemma 4 on Port 11434)
# echo "Starting Executor (Qwen-3 8B) on port 8086..."
# "$BINARY" -m "$QWEN_8B" --host 0.0.0.0 --port 8086 --ctx-size 8192 --threads 3 > "$LOG_DIR/triad_executor.log" 2>&1 &

# 3. The Sentinel (Port 8087) - BitNet 1.58b (Router / Monitor)
echo "Starting Sentinel (BitNet 1.58b) on port 8087..."
"$BINARY" -m "$SENTINEL_1B" --host 0.0.0.0 --port 8087 --ctx-size 4096 --threads 1 > "$LOG_DIR/triad_sentinel.log" 2>&1 &

echo "Sovereign Triad initialized and loading..."

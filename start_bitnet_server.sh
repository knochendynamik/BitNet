#!/bin/bash
# Dual BitNet Server Stack
BINARY="/Users/bjornbellmann/BitNet/build/bin/llama-server"

# Startup configuration
FALCON_MODEL="/Users/bjornbellmann/BitNet/models/ggml-model-i2_s.gguf"
BITNET_158B_MODEL="/Users/bjornbellmann/BitNet/models/BitNet-1.58b/ggml-model-i2_s.gguf"

# Start Falcon-3 10B on Port 8085 (Complex Tasks)
echo "Starting Falcon-3 10B BitNet on port 8085..."
$BINARY -m "$FALCON_MODEL" --host 0.0.0.0 --port 8085 --ctx-size 8192 --threads 4 > /Users/bjornbellmann/TRIPODS\ 2.0/.logs/falcon_bitnet.log 2>&1 &

# Start Microsoft BitNet 1.58b on Port 8086 (Fast Dispatcher)
echo "Starting Microsoft BitNet 1.58b on port 8086..."
$BINARY -m "$BITNET_158B_MODEL" --host 0.0.0.0 --port 8086 --ctx-size 8192 --threads 2 > /Users/bjornbellmann/TRIPODS\ 2.0/.logs/ms_bitnet_158b.log 2>&1 &

echo "Dual BitNet Stack initialized."
wait

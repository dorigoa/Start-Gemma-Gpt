#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <low|medium|high>" >&2
    exit 1
fi
REAS="$1"

/opt/llama.cpp/llama-server \
  --device CUDA1,CUDA0 \
  --model /nvme/gguf/ggml.org-gpt-oss-120b/gpt-oss-120b-MXFP4.gguf \
  -md /nvme/gguf/ggml.org-gpt-oss-120b/eagle3-gpt-oss-120b-Q8_0.gguf \
  --alias gpt-oss-120b-mxfp4 \
  --spec-type draft-eagle3 --spec-draft-n-max 3 \
  -ngld all -fa on \
  -c 131072 -b 2048 -ub 512 \
  -t 16 -np 1 \
  --load-mode none \
  --moe-cache-mib 6000 \
  --host 0.0.0.0 --port 11000 \
  --fit-target 2048 \
  --no-webui \
  --temp 1.0 --top-p 1.0 --top-k 100 --min-p 0.0 \
  --chat-template-kwargs '{"reasoning_effort": "$REAS"}' \
  --reasoning-budget 32768 \
  --reasoning-budget-message "I have reasoned enough. I will now write the answer." \
  --log-file /tmp/llama-server.log

# ysp-live v11.3 on Render (free, Singapore) — Docker runtime
# Why Docker, not Render's native Python runtime: the script needs ffmpeg
# (segment decode check) and node (companion ysp-engine.js); neither is
# guaranteed in the native Python environment. Render supports Dockerfile
# deploys on the free plan.
FROM python:3.12-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY ysp-live-v11.3.py ysp-engine.js ./

# Render sets $PORT automatically; the script takes the port as its first
# positional argument and binds 0.0.0.0 by default. --cache-mb 100 keeps the
# in-memory TS cache inside the free instance's 512 MB (default is 200).
CMD ["sh", "-c", "YSP_ENGINE_PORT=8787 python3 ysp-live-v11.3.py $PORT --cache-mb 100"]

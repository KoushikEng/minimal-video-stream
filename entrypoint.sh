#!/bin/sh

# Default: Enable preprocessing (Assume powerful x86 or Apple Silicon)
ARGS="/media"

# Get Architecture and Kernel Info
ARCH=$(uname -m)
KERNEL=$(uname -r)

# Logic:
# 1. If we are on ARM (aarch64)...
# 2. AND we are NOT on Docker Desktop for Mac (which uses 'linuxkit' kernel)...
# 3. THEN we assume it's a slow SBC (Raspberry Pi, etc.) and disable preprocessing unless overridden.

if [ "$ARCH" = "x86_64" ]; then
    echo "Detected x86_64 Architecture. Keeping preprocessing ON."
    apk add --no-cache ffmpeg
elif [ "$ARCH" = "aarch64" ]; then
    if echo "$KERNEL" | grep -q "linuxkit"; then
        echo "Detected Apple Silicon (Docker Desktop). Keeping preprocessing ON."
        apk add --no-cache ffmpeg
    else
        echo "Detected Low-Power ARM Device (likely Raspberry Pi). Recommended disabling preprocessing."
        # Check if a preprocessing argument is passed and extract its value
        preprocessing_value=""
        i=0
        for arg in "$@"; do
            i=$((i + 1))
            if [ "$arg" = "--preprocessing" ]; then
                # Get the next argument
                eval "preprocessing_value=\${$((i + 1))}"
                break
            elif [[ $arg == --preprocessing=* ]]; then
                preprocessing_value="${arg#--preprocessing=}"
                break
            fi
        done
        
        if [ "$preprocessing_value" = "force" ]; then
            echo "Preprocessing forced ON via --preprocessing=force or --preprocessing force argument."
            apk add --no-cache ffmpeg
            ARGS="/media"
        elif [ -z "$preprocessing_value" ]; then
            ARGS="/media --preprocessing skip"
        fi
    fi
fi

# Execute the application
exec python main.py $ARGS "$@"
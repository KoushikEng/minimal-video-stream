#!/bin/sh

# Get Architecture and Kernel Info
ARCH=$(uname -m)
KERNEL=$(uname -r)

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

# Determine whether to skip preprocessing based on the argument and system characteristics
# ARCH x86_64 and Apple Silicon (aarch64 on linuxkit) will run with preprocessing by default
if [[ "$preprocessing_value" == "skip" || ( -z "$preprocessing_value" && "$ARCH" = "aarch64" && ! "$KERNEL" =~ linuxkit ) ]]; then
    echo "Preprocessing will be skipped."
    ARGS="/media --preprocessing skip"
else
    # Default: Enable preprocessing (Assume powerful x86 or Apple Silicon)
    ARGS="/media"
    apk add --no-cache ffmpeg
fi

# Execute the application
exec python main.py $ARGS "$@"
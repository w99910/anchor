#!/bin/bash
#
# Build ExecuTorch Llama runner for Android
# Assumes ExecuTorch is already installed via pip
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR}/../.."
ANDROID_NDK="${ANDROID_NDK:-$HOME/Android/Sdk/ndk/28.2.13676358}"

# Find ExecuTorch installation
ET_PATH=$(python3 -c "import executorch; print(executorch.__path__[0])" 2>/dev/null || echo "")

if [ -z "$ET_PATH" ]; then
    echo "Error: ExecuTorch not found. Install it first:"
    echo "  pip install executorch"
    exit 1
fi

# ExecuTorch source should be in a parent directory or we need to clone
ET_SRC="${ET_PATH}/../.."
if [ ! -f "${ET_SRC}/CMakeLists.txt" ]; then
    echo "ExecuTorch source not found at ${ET_SRC}"
    echo "Cloning ExecuTorch source..."
    
    BUILD_DIR="${PROJECT_DIR}/native_build"
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    
    if [ ! -d "executorch" ]; then
        git clone --depth 1 https://github.com/pytorch/executorch.git
        cd executorch
        git submodule update --init --recursive --depth 1
    else
        cd executorch
    fi
    ET_SRC="$(pwd)"
fi

echo "========================================"
echo "Building ExecuTorch Llama for Android"
echo "========================================"
echo "ExecuTorch source: $ET_SRC"
echo "NDK: $ANDROID_NDK"
echo ""

cd "$ET_SRC"

# Check NDK
if [ ! -d "$ANDROID_NDK" ]; then
    echo "Error: Android NDK not found at $ANDROID_NDK"
    echo "Please set ANDROID_NDK environment variable"
    exit 1
fi

# Build ExecuTorch core for Android
echo "Step 1/3: Building ExecuTorch core libraries..."
cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_INSTALL_PREFIX=cmake-out-android \
    -DCMAKE_BUILD_TYPE=Release \
    -DEXECUTORCH_BUILD_EXTENSION_DATA_LOADER=ON \
    -DEXECUTORCH_BUILD_EXTENSION_FLAT_TENSOR=ON \
    -DEXECUTORCH_BUILD_EXTENSION_MODULE=ON \
    -DEXECUTORCH_BUILD_EXTENSION_TENSOR=ON \
    -DEXECUTORCH_ENABLE_LOGGING=1 \
    -DEXECUTORCH_BUILD_XNNPACK=ON \
    -DEXECUTORCH_BUILD_KERNELS_OPTIMIZED=ON \
    -DEXECUTORCH_BUILD_KERNELS_QUANTIZED=ON \
    -DEXECUTORCH_BUILD_KERNELS_LLM=ON \
    -Bcmake-out-android .

cmake --build cmake-out-android -j$(nproc) --target install --config Release

# Build llama runner
echo "Step 2/3: Building Llama runner..."
cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_INSTALL_PREFIX=cmake-out-android \
    -DCMAKE_BUILD_TYPE=Release \
    -DEXECUTORCH_BUILD_XNNPACK=ON \
    -DEXECUTORCH_BUILD_KERNELS_OPTIMIZED=ON \
    -DEXECUTORCH_BUILD_KERNELS_QUANTIZED=ON \
    -DEXECUTORCH_BUILD_KERNELS_LLM=ON \
    -DSUPPORT_REGEX_LOOKAHEAD=ON \
    -Bcmake-out-android/examples/models/llama \
    examples/models/llama

cmake --build cmake-out-android/examples/models/llama -j$(nproc) --config Release

# Copy to Flutter project
echo "Step 3/3: Copying to Flutter project..."
JNILIB_DIR="${PROJECT_DIR}/android/app/src/main/jniLibs/arm64-v8a"
mkdir -p "$JNILIB_DIR"

# Copy llama_main binary
if [ -f "cmake-out-android/examples/models/llama/llama_main" ]; then
    cp cmake-out-android/examples/models/llama/llama_main "${JNILIB_DIR}/"
    echo "Copied llama_main"
else
    echo "Warning: llama_main not found!"
fi

# Copy shared libraries
find cmake-out-android -name "*.so" -exec cp {} "$JNILIB_DIR/" \; 2>/dev/null || true

echo ""
echo "========================================"
echo "Build complete!"
echo "========================================"
ls -la "${JNILIB_DIR}/"
echo ""
echo "Next: Push model and tokenizer to device"
echo "  adb push /path/to/model.pte /sdcard/Download/"
echo "  adb push /path/to/tokenizer.model /sdcard/Download/"

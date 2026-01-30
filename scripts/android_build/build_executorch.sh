#!/bin/bash
#
# Build ExecuTorch LLM runner for Android
# This script builds the native libraries needed to run Llama on Android
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR}/../.."
BUILD_DIR="${PROJECT_DIR}/native_build"
ANDROID_NDK="${ANDROID_NDK:-$HOME/Android/Sdk/ndk/28.2.13676358}"

echo "========================================"
echo "ExecuTorch Android Build Script"
echo "========================================"
echo "Project: $PROJECT_DIR"
echo "Build dir: $BUILD_DIR"
echo "NDK: $ANDROID_NDK"
echo ""

# Check NDK
if [ ! -d "$ANDROID_NDK" ]; then
    echo "Error: Android NDK not found at $ANDROID_NDK"
    echo "Please set ANDROID_NDK environment variable"
    exit 1
fi

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Clone ExecuTorch if not exists
if [ ! -d "executorch" ]; then
    echo "Cloning ExecuTorch..."
    git clone --depth 1 https://github.com/pytorch/executorch.git
    cd executorch
    git submodule update --init --recursive --depth 1
else
    echo "ExecuTorch already cloned"
    cd executorch
fi

# Create Python virtual environment
if [ ! -d ".venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv .venv
fi
source .venv/bin/activate

# Install Python dependencies
echo "Installing Python dependencies..."
pip install --quiet --upgrade pip
pip install --quiet cmake pyyaml wheel setuptools

# Install ExecuTorch (simplified - just install Python package)
echo "Installing ExecuTorch Python package..."
pip install .

# Install LLM requirements
echo "Installing LLM requirements..."
if [ -f "./examples/models/llama/install_requirements.sh" ]; then
    ./examples/models/llama/install_requirements.sh
fi

# Build for Android arm64-v8a
echo "Building ExecuTorch for Android arm64-v8a..."
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
    -DPYTHON_EXECUTABLE=python \
    -DEXECUTORCH_BUILD_XNNPACK=ON \
    -DEXECUTORCH_BUILD_KERNELS_OPTIMIZED=ON \
    -DEXECUTORCH_BUILD_KERNELS_QUANTIZED=ON \
    -DEXECUTORCH_BUILD_KERNELS_LLM=ON \
    -Bcmake-out-android .

cmake --build cmake-out-android -j$(nproc) --target install --config Release

# Build llama runner for Android
echo "Building Llama runner..."
cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_INSTALL_PREFIX=cmake-out-android \
    -DCMAKE_BUILD_TYPE=Release \
    -DPYTHON_EXECUTABLE=python \
    -DEXECUTORCH_BUILD_XNNPACK=ON \
    -DEXECUTORCH_BUILD_KERNELS_OPTIMIZED=ON \
    -DEXECUTORCH_BUILD_KERNELS_QUANTIZED=ON \
    -DEXECUTORCH_BUILD_KERNELS_LLM=ON \
    -DSUPPORT_REGEX_LOOKAHEAD=ON \
    -Bcmake-out-android/examples/models/llama \
    examples/models/llama

cmake --build cmake-out-android/examples/models/llama -j$(nproc) --config Release

# Copy binary and libraries to Flutter project
echo "Copying files to Flutter project..."
JNILIB_DIR="${PROJECT_DIR}/android/app/src/main/jniLibs/arm64-v8a"
mkdir -p "$JNILIB_DIR"

# Copy the llama_main binary (we'll run it via exec)
cp cmake-out-android/examples/models/llama/llama_main "${JNILIB_DIR}/"

# Copy required shared libraries
find cmake-out-android -name "*.so" -exec cp {} "$JNILIB_DIR/" \;

echo ""
echo "========================================"
echo "Build complete!"
echo "========================================"
echo "Binary: ${JNILIB_DIR}/llama_main"
echo ""
echo "Next steps:"
echo "1. Push the model to your device"
echo "2. The Flutter app will use the native runner"

#!/bin/bash
set -e

ANDROID_HOME=/opt/android-sdk
BUILD_TOOLS=$ANDROID_HOME/build-tools/35.0.0
PLATFORM=$ANDROID_HOME/platforms/android-28
AAPT2="/opt/android-sdk/aapt2-wrapper.sh"
KEYSTORE="/root/pinduoduo-quick/debug.keystore"

cd "$(dirname "$0")"

# 清理
rm -rf build/*
mkdir -p build/{gen,obj,apk}

# 1. 编译资源
echo "[1/7] 编译资源..."
$AAPT2 compile --dir app/src/main/res -o build/resources.zip

# 2. 链接资源
echo "[2/7] 链接资源..."
$AAPT2 link -o build/apk/app.unsigned.apk \
    -I $PLATFORM/android.jar \
    --manifest app/src/main/AndroidManifest.xml \
    --java build/gen \
    build/resources.zip

# 3. 编译 Java
echo "[3/7] 编译 Java..."
javac -encoding UTF-8 -source 1.8 -target 1.8 \
    -bootclasspath $PLATFORM/android.jar \
    -classpath $PLATFORM/android.jar \
    -d build/obj \
    build/gen/com/example/pinduoduo/quick/R.java \
    app/src/main/java/com/example/pinduoduo/quick/MainActivity.java

# 4. DEX
echo "[4/7] DEX 转换..."
$BUILD_TOOLS/d8 --output build/apk/ \
    build/obj/com/example/pinduoduo/quick/*.class

# 5. 打包 DEX
echo "[5/7] 打包..."
cd build/apk
jar -uf app.unsigned.apk classes.dex

# 6. 对齐
echo "[6/7] 对齐..."
/usr/bin/qemu-x86_64 -L /opt/x86_64-sysroot $BUILD_TOOLS/zipalign -f 4 \
    app.unsigned.apk app.aligned.apk

# 7. 签名
echo "[7/7] 签名..."
if [ ! -f "$KEYSTORE" ]; then
    echo "生成新密钥..."
    keytool -genkey -v -keystore "$KEYSTORE" \
        -storepass android -keypass android \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias androiddebugkey \
        -dname "CN=Android Debug,O=Android,C=US"
fi

jarsigner -sigalg SHA256withRSA -digestalg SHA-256 \
    -keystore "$KEYSTORE" \
    -storepass android -keypass android \
    app.aligned.apk androiddebugkey

# 复制到 MT2（改名快取）
cp app.aligned.apk "/storage/emulated/0/MT2/apks/快取.apk"

echo ""
echo "===== 构建完成 ====="
echo "APK: /storage/emulated/0/MT2/apks/快取.apk"

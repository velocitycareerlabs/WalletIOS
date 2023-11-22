#! /bin/sh -e
FRAMEWORK_NAME=VCCrypto
# Output Path
# Clean the old framework
xcodebuild -project $FRAMEWORK_NAME.xcodeproj -configuration Release -target $FRAMEWORK_NAME -sdk iphonesimulator clean
xcodebuild -project $FRAMEWORK_NAME.xcodeproj -configuration Release -target $FRAMEWORK_NAME -sdk iphoneos clean
# Build the simulator and device version of the framework
# iOS devices
xcodebuild archive \
    -scheme $FRAMEWORK_NAME \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "./build/$FRAMEWORK_NAME-iOS.xcarchive" \
    -sdk iphoneos \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES
# iOS simulators
xcodebuild archive \
    -scheme $FRAMEWORK_NAME \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "./build/$FRAMEWORK_NAME-iOS-simulator.xcarchive" \
    -sdk iphonesimulator \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES
# Create the xcframework from them
xcodebuild -create-xcframework \
    -framework "./build/$FRAMEWORK_NAME-iOS.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
    -framework "./build/$FRAMEWORK_NAME-iOS-simulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
    -output "./build/$FRAMEWORK_NAME.xcframework"
# Clean up interfce naming
find . -name "*.swiftinterface" -exec sed -i -e "s/$FRAMEWORK_NAME\.//g" {} \;
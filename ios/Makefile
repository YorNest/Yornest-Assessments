# ScoopLite iOS Assessment Makefile
# Provides convenient commands for building and testing the assessment app

.PHONY: help setup generate build test test-unit test-ui clean install

# Default target
help:
	@echo "ScoopLite iOS Assessment Commands:"
	@echo "  setup              - Generate project, install pods, and open workspace"
	@echo "  generate           - Generate Xcode project from project.yml"
	@echo "  build              - Build the project"
	@echo "  test               - Run all tests"
	@echo "  test-unit          - Run unit tests only"
	@echo "  test-ui            - Run UI tests only"
	@echo "  clean              - Clean build artifacts"
	@echo "  install            - Install to simulator"

# Generate Xcode project using XcodeGen
generate:
	@which xcodegen > /dev/null || (echo "Installing XcodeGen..." && brew install xcodegen)
	xcodegen generate --spec project.yml

# Setup project (generate + install pods)
# Note: Podfile and xcodeproj are both at assessments/ios/ level
setup: generate
	pod install
	open ScoopLiteIOS.xcworkspace

# Build the project
build:
	xcodebuild -workspace ScoopLiteIOS.xcworkspace \
		-scheme ScoopLiteIOS \
		-configuration Debug \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		build

# Run all tests
test: test-unit

# Run unit tests only
test-unit:
	xcodebuild -workspace ScoopLiteIOS.xcworkspace \
		-scheme ScoopLiteIOS \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		test

# Run UI tests only
test-ui:
	xcodebuild -workspace ScoopLiteIOS.xcworkspace \
		-scheme ScoopLiteIOSUITests \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		test

# Clean build artifacts
clean:
	-xcodebuild -workspace ScoopLiteIOS.xcworkspace \
		-scheme ScoopLiteIOS \
		clean 2>/dev/null || true
	rm -rf ~/Library/Developer/Xcode/DerivedData/ScoopLiteIOS-*
	rm -rf Pods Podfile.lock ScoopLiteIOS.xcworkspace ScoopLiteIOS.xcodeproj

# Install to simulator
install:
	xcodebuild -workspace ScoopLiteIOS.xcworkspace \
		-scheme ScoopLiteIOS \
		-configuration Debug \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		install

# Quick development cycle
dev: clean build test-unit
	@echo "Development cycle complete!"


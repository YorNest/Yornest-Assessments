# ScoopLite Assessment Makefile
# Provides convenient commands for building and testing the assessment app

.PHONY: help build test test-unit test-instrumented clean lint

# Default target
help:
	@echo "ScoopLite Assessment Commands:"
	@echo "  build              - Build the debug APK"
	@echo "  test               - Run all tests (unit + instrumented)"
	@echo "  test-unit          - Run unit tests only"
	@echo "  test-instrumented  - Run instrumented tests only (requires device/emulator)"
	@echo "  clean              - Clean build artifacts"
	@echo "  lint               - Run lint checks"
	@echo "  install            - Install debug APK to connected device"

# Build the debug APK
build:
	./gradlew assembleDebug

# Run all tests
test: test-unit test-instrumented

# Run unit tests only
test-unit:
	./gradlew :app:testDevelopDebugUnitTest

# Run instrumented tests (requires connected device or emulator)
test-instrumented:
	./gradlew connectedAndroidTest

# Clean build artifacts
clean:
	./gradlew clean

# Run lint checks
lint:
	./gradlew lint

# Install debug APK to connected device
install:
	./gradlew installDebug

# Check code quality (lint + tests)
check:
	./gradlew check

# Build and install in one command
build-install: build install

# Quick development cycle: clean, build, test unit tests
dev: clean build test-unit
	@echo "Development cycle complete!"

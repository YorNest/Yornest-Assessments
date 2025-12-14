/*
 File:       Luciq/LCQNonFatal.h

 Contains:   API for using Luciq's SDK.

 Copyright:  (c) 2013-2022 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LCQNonFatalLevel) {
    LCQNonFatalLevelInfo,
    LCQNonFatalLevelWarning,
    LCQNonFatalLevelError,
    LCQNonFatalLevelCritical
} NS_SWIFT_NAME(NonFatalLevel);

typedef NS_ENUM(NSInteger, LCQNonFatalStackTraceMode) {
    LCQNonFatalStackTraceModeFull,
    LCQNonFatalStackTraceModeCallerThread
} NS_SWIFT_NAME(NonFatalStackTraceMode);

NS_SWIFT_NAME(NonFatalBuilder)
@protocol LCQNonFatalBuilder <NSObject>

/// Report the non-fatal incident.
- (void)report;

@end

NS_SWIFT_NAME(NonFatalError)
@interface LCQNonFatalError : NSObject<LCQNonFatalBuilder>

/// The error to be reported.
@property (atomic, strong, nonnull) NSError* error;

/// The Grouping String that to be sent with the non-fatal error.
@property (atomic, strong, nonnull) NSString *groupingString;

/// Number of frames to be dropped from the start of the stacktrace
/// Default value is `0`
@property (assign) NSInteger stackFramesToTrim;

/// The user attributes that will be attached to the report.
@property (atomic, copy, nonnull) NSDictionary<NSString *, NSString*> *userAttributes;

/// The error level.
@property (atomic, assign) LCQNonFatalLevel level;

/// Stack trace Mode
@property (atomic, assign) LCQNonFatalStackTraceMode stackTraceMode;

- (instancetype)init __attribute__((unavailable("Init is not available, use +[LCQCrashReporting error:] instead.")));

@end

NS_SWIFT_NAME(NonFatalException)
@interface LCQNonFatalException : NSObject<LCQNonFatalBuilder>

/// The exception to be reported.
@property (atomic, strong, nonnull) NSException* exception;

/// The Grouping String that to be sent with the non-fatal exception.
@property (atomic, strong, nonnull) NSString *groupingString;

/// Number of frames to be dropped from the start of the stacktrace
/// Default value is `0`
@property (assign) NSInteger stackFramesToTrim;

/// The user attributes that will be attached to the report.
@property (atomic, copy, nonnull) NSDictionary<NSString *, NSString*> *userAttributes;

/// The exception level.
@property (atomic, assign) LCQNonFatalLevel level;

/// Stack trace Mode
@property (atomic, assign) LCQNonFatalStackTraceMode stackTraceMode;

- (instancetype)init __attribute__((unavailable("Init is not available, use +[LCQCrashReporting exception:] instead.")));

@end


NS_ASSUME_NONNULL_END

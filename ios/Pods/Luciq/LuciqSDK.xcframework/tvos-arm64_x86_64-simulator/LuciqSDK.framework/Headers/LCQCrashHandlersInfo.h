/*
 File:       Luciq/LCQCrashHandlersInfo.h

 Contains:   API for using Luciq's SDK.

 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import <Foundation/Foundation.h>
#import "LCQFunctionInfo.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(CrashHandlersInfo)
@interface LCQCrashHandlersInfo : NSObject

/// The crash handler’s Mach exception port number.
@property (nonatomic, assign, readonly) mach_port_t machExceptionPort;

/// The crash handler’s signal handler function info.
@property (nonatomic, strong, readonly) LCQFunctionInfo *signalHandler;

/// The crash handler’s uncaught `NSException` handler function info.
@property (nonatomic, strong, readonly) LCQFunctionInfo *uncaughtNSExceptionHandler;

@end

NS_ASSUME_NONNULL_END

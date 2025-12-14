/*
 File:       Luciq/LCQCrashReporterState.h

 Contains:   API for using Luciq's SDK.

 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import <Foundation/Foundation.h>
#import "LCQCrashHandlersInfo.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(CrashReporterState)
@interface LCQCrashReporterState : NSObject

/// The currently registered crash handlers information.
@property (nonatomic, strong, readonly) LCQCrashHandlersInfo *currentHandlers;

/// Luciq’s crash handlers information.
@property (nonatomic, strong, readonly) LCQCrashHandlersInfo *luciqHandlers;

/// Whether Luciq’s crash reporter is the first to handle all types of exceptions.
@property (nonatomic, assign, readonly) BOOL isLuciqCrashReporterActive;

@end

NS_ASSUME_NONNULL_END

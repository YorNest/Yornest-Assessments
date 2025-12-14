/*
 File:       Luciq/LCQCrashMetaData.h

 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(CrashMetaData)
@interface LCQCrashMetaData : NSObject

/// The ID for the crash occurrence.
@property (atomic, copy, nonnull, readonly) NSString* occurrenceID;

/// The error code for the crash.
@property (atomic, copy, nonnull, readonly) NSString *errorCode;

/// The error type for the crash.
@property (atomic, copy, nonnull, readonly) NSString *errorType;

/// A brief description of the error.
@property (atomic, copy, nonnull, readonly) NSString *errorDescription;

/// The user attributes that will be attached to the report.
@property (atomic, copy, readonly) NSDictionary<NSString *, NSString *> *userAttributes;

/// The Crash metadata that added by `onCrashHandler` callback
@property (atomic, copy, nullable, readonly) NSDictionary<NSString *, id> *additionalCrashData;

/// A boolean to indicate if crash logs and attachments are dropped
@property(atomic, readonly) BOOL rateLimited;

/// The crash processing duration in milliseconds
@property(atomic, readonly, nullable) NSNumber *processingDuration;

- (instancetype)initWithOccurrnceID:(NSString *)occurrenceID
                          errorCode:(NSString *)errorCode
                          errorType:(NSString *)errorType
                   errorDescription:(NSString *)errorDescription
                     userAttributes:(NSDictionary<NSString *, NSString *> *)userAttributes
                        rateLimited:(BOOL)rateLimited
                 processingDuration:(nullable NSNumber *)processingDuration
                additionalCrashData:(nullable NSDictionary<NSString *, id> *)additionalCrashData;
@end

NS_ASSUME_NONNULL_END

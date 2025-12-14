/*
 File:       Luciq/LCQReport.h
 
 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Report)
@interface LCQReport : NSObject

@property (nonatomic, copy, readonly) NSArray<NSString *> *tags;
@property (nonatomic, copy, readonly) NSArray<NSDictionary *> *luciqLogs;
@property (nonatomic, copy, readonly) NSArray<NSDictionary *> *consoleLogs;
@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *userAttributes;
@property (nonatomic, copy, readonly) NSArray<NSString *> *fileLocations;
@property (nonatomic, copy) NSString *userData;

- (void)appendTag:(NSString *)tag;
- (void)logVerbose:(NSString *)log;
- (void)logDebug:(NSString *)log;
- (void)logInfo:(NSString *)log;
- (void)logWarn:(NSString *)log;
- (void)logError:(NSString *)log;
- (void)appendToConsoleLogs:(NSString *)log;
- (void)setUserAttribute:(NSString *)userAttribute withKey:(NSString *)key;
- (void)addFileAttachmentWithURL:(NSURL *)url;
- (void)addFileAttachmentWithData:(NSData *)data;
- (void)addFileAttachmentWithData:(NSData *)data andName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

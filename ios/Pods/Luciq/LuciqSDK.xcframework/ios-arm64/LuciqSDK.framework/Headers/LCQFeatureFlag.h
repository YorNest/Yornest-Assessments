/*
 File:       Luciq/LCQFeatureFlag.h
 
 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.
 
 Version:    19.1.1
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(FeatureFlag)
@interface LCQFeatureFlag : NSObject
@property (atomic, copy, readonly) NSString *name;
@property (atomic, copy, readonly, nullable) NSString *variant;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithName:(NSString *)name
                     variant:(nullable NSString *)variant;
- (instancetype)initWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END

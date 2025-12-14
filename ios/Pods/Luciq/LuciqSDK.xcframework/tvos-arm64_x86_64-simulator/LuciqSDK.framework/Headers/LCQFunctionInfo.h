/*
 File:       Luciq/LCQFunctionInfo.h

 Contains:   API for using Luciq's SDK.

 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(FunctionInfo)
@interface LCQFunctionInfo : NSObject

/// The function address.
@property (nonatomic, assign, readonly) NSUInteger functionAddress;

/// The function name.
@property (nonatomic, copy, readonly, nullable) NSString *functionName;

/// The binary image name that contains the function.
@property (nonatomic, copy, readonly, nullable) NSString *binaryImageName;

/// The binary image path that contains the function.
@property (nonatomic, copy, readonly, nullable) NSString *binaryImagePath;

@end

NS_ASSUME_NONNULL_END

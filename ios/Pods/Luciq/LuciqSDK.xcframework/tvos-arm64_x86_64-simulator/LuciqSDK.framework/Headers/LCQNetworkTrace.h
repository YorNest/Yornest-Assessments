/*
 File:       Luciq/LCQNetworkTrace.h
 
 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2021 by Luciq, Inc., all rights reserved.
 
 Version:    19.1.1
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(NetworkTrace)
@interface LCQNetworkTrace : NSObject

@property (nonatomic, strong) NSURLRequest* request;

/// Object will be nil if there isn't a response.
@property (nonatomic, strong, nullable) NSURLResponse* response;

/// Object will be nil if there isn't response data, or data size exceeded the maximum limit.
@property (nonatomic, strong, nullable) NSData* responseData;

@property (nonatomic, assign) NSUInteger responseDataSize;

@end

NS_ASSUME_NONNULL_END

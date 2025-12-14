/*
 File:       Luciq/LCQSurvey.h
 
 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import <Foundation/Foundation.h>

NS_SWIFT_NAME(Survey)
@interface LCQSurvey : NSObject

@property (nonatomic, readonly) NSString *title;

- (void)show;

@end

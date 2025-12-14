/*
 File:       Luciq/LCQUserStep.h
 
 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import <Foundation/Foundation.h>
#if __has_include (<InstabugUtilities/LCQTypes.h>)
#import <InstabugUtilities/LCQTypes.h>
#else
#import "LCQTypes.h"
#endif

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(UserStep)
@interface LCQUserStep: NSObject

- (instancetype) init __attribute__((unavailable("use initWithEvent: instead")));
- (instancetype)initWithEvent:(LCQUIEventType)event;
- (instancetype _Nullable)initWithEvent:(LCQUIEventType)event automatic:(BOOL)automatic;
- (LCQUserStep *)setMessage:(NSString *)message;
- (LCQUserStep *)setViewType:(LCQInteractionViewType)viewType;
- (LCQUserStep *)setViewTypeName:(NSString *)viewType;
- (void)logUserStep;

@end

NS_ASSUME_NONNULL_END

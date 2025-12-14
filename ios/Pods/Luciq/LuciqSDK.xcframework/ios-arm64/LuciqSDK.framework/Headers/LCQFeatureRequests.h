/*
 File:       Luciq/LCQFeatureRequests.h
 
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

NS_SWIFT_NAME(FeatureRequests)
@interface LCQFeatureRequests : NSObject

/**
 @brief Acts as a master switch for the Feature Requests.
 
 @discussion It's enabled by default. When disabled, all the functionalities related to the Feature Requests is disabled.
 */
@property (class, atomic, assign) BOOL enabled;

/**
 @brief Serves as a switch for enabling user identifications..
 
 @discussion It's enabled by default. When disabled, user name and email will not be collected when creating or commenting on a feature request.
 */
@property (class, atomic, assign) BOOL userIdentificationDataCollectionEnabled;

/**
 @brief Sets whether users are required to enter an email address or not when doing a certain action `LCQAction`.
 
 @discussion Defaults to YES.
 
 @param isEmailFieldRequired A boolean to indicate whether email field is required or not.
 @param actionType An enum that indicates which action types will have the isEmailFieldRequired.
 */
+ (void)setEmailFieldRequired:(BOOL)isEmailFieldRequired forAction:(LCQAction)actionType;

/**
 @brief Shows the UI for feature requests list
 */
+ (void)show;

@end

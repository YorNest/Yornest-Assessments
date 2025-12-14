/*
 File:       Luciq/UIView+Luciq.h
 
 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.
 
 Version:    19.1.1
 */

#import <UIKit/UIKit.h>

@interface UIView (Luciq)

/**
 @brief Set this to true on any UIView to mark it as private.
 Doing this will exclude it from all screenshots, view hierarchy captures and screen recordings.
 */
@property (nonatomic, assign) BOOL luciq_privateView;

@end

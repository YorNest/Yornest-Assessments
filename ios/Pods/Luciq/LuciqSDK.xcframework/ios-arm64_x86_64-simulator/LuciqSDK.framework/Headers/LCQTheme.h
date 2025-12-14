/*
 File:       Luciq/LCQTheme.h
 
 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Theme)
@interface LCQTheme : NSObject

@property (strong) UIFont *primaryTextFont;
@property (strong) UIFont *secondaryTextFont;
@property (strong) UIFont *callToActionTextFont;


@property (strong) UIColor *primaryColor;
@property (strong) UIColor *backgroundColor;


@property (strong) UIColor *titleTextColor;
@property (strong) UIColor *subtitleTextColor;
@property (strong) UIColor *primaryTextColor;
@property (strong) UIColor *secondaryTextColor;
@property (strong) UIColor *callToActionTextColor;


@property (strong) UIColor *headerBackgroundColor;
@property (strong) UIColor *footerBackgroundColor;
@property (strong) UIColor *rowBackgroundColor;

@property (strong) UIColor *rowSeparatorColor;

@property (strong) UIColor *selectedRowBackgroundColor;

@property (strong) UIColor *inboundBubbleBackgroundColor;

@end

NS_ASSUME_NONNULL_END

/*
 File:       Luciq/LCQBugReporting.h
 
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

#if __has_include (<InstabugUtilities/LCQProactiveReportingConfigurations.h>)
#import <InstabugUtilities/LCQProactiveReportingConfigurations.h>
#else
#import "LCQProactiveReportingConfigurations.h"
#endif

NS_SWIFT_NAME(BugReporting)
@interface LCQBugReporting : NSObject

/**
 @brief Acts as master switch for the Bug Reporting.
 
 @discussion It's enabled by default. When disabled, both "Report a bug" and "Suggest an improvement" will be removed from Luciq Prompt Options. In addition, when disabled +showWithReportType:options: won’t have an effect.
 */
@property (class, atomic, assign) BOOL enabled;

/**
 @returns `YES` if Bug Reporting has exceeded the usage limit on your plan. Otherwise, returns `NO`.
 
 @discussion If you have exceeded the usage limit on your plan, the Bug Reporting prompt will still appear to the end users normally. In that case, the bug won't be sent to the dashboard.
 */
@property (class, atomic, readonly) BOOL usageExceeded;

/**
 @brief Sets a block of code to be executed just before the SDK's UI is presented.
 
 @discussion This block is executed on the UI thread. Could be used for performing any UI changes before the SDK's UI
 is shown.
 */
@property(class, atomic, strong) void(^ _Nullable willInvokeHandler)(void);

/**
 @brief Sets a block of code to be executed right after the SDK's UI is dismissed.
 
 @discussion This block is executed on the UI thread. Could be used for performing any UI changes after the SDK's UI
 is dismissed.
 
 The block has the following parameters:
 
 - dismissType: How the SDK was dismissed.
 - reportCategory: Category of the report that has been sent. Will be set to LCQReportCategoryBug in case the SDK has been dismissed
 without selecting a report category, so you might need to check dismissType before reportCategory.
 
 @see LCQReportCategory, LCQDismissType
 */
@property(class, atomic, strong) void(^ _Nullable didDismissHandler)(LCQDismissType dismissType, LCQReportCategory reportCategory);

/**
 @brief Sets a block of code to be executed when a prompt option is selected
 
 @param promptOption The selected promptOption.
 
 The block has the following parameters:
 - prompOption: The option selected in prompt.
 */
@property(class, atomic, strong) void(^ _Nullable didSelectPromptOptionHandler)(LCQPromptOption promptOption);

/**
 @brief Sets the events that invoke the feedback form.
 
 @discussion Default is set by `startWithToken:invocationEvent:`.
 
 @see LCQInvocationEvent
 */
@property(class, atomic, assign) LCQInvocationEvent invocationEvents;

/**
 @brief Sets the threshold value of the shake gesture for iPhone/iPod Touch.
 
 @discussion Default for iPhone is 2.5. The lower the threshold, the easier it will be to invoke Luciq with the
 shake gesture. A threshold which is too low will cause Luciq to be invoked unintentionally.
 */
@property(class, atomic, assign) CGFloat shakingThresholdForiPhone;

/**
 @brief Sets the threshold value of the shake gesture for iPad.
 
 @discussion Default for iPad is 0.6. The lower the threshold, the easier it will be to invoke Luciq with the
 shake gesture. A threshold which is too low will cause Luciq to be invoked unintentionally.
 */
@property(class, atomic, assign) CGFloat shakingThresholdForiPad;

/**
 @brief Sets the default edge at which the floating button will be shown. Different orientations are already handled.
 
 @discussion Default for `floatingButtonEdge` is `CGRectMaxXEdge`.
 */
@property(class, atomic, assign) CGRectEdge floatingButtonEdge;

/**
 @brief Sets the default offset from the top at which the floating button will be shown.
 
 @discussion Default for `floatingButtonOffsetFromTop` is 50
 */
@property(class, atomic, assign) CGFloat floatingButtonTopOffset;

/**
 @brief Sets whether attachments in bug reporting and in-app messaging are enabled.
 */
@property(class, atomic, assign) LCQAttachmentType enabledAttachmentTypes;

/**
 @brief Controls if Luciq Prompt Options should contain "Report a problem” and/or "Suggest an improvement" or not.
 
 @discussion By default, both options are enabled.
 */
@property(class, atomic, assign) LCQBugReportingReportType promptOptionsEnabledReportTypes;

/**
 @brief Sets whether the extended bug report mode should be disabled, enabled with required fields or enabled with optional fields.
 
 @discussion This feature is disabled by default. When enabled, it adds more fields for your reporters to fill in. You can set whether the extra fields are required or optional.
 1. Expected Results.
 2. Actual Results.
 3. Steps to Reproduce.
 
 An enum to disable the extended bug report mode, enable it with required or with optional fields.
 */
@property(class, atomic, assign) LCQExtendedBugReportMode extendedBugReportMode;

/**
 @brief Use to specify different options that would affect how Luciq is shown and other aspects about the reporting experience.
 
 @discussion See LCQBugReportingOption.
 */
@property(class, atomic, assign) LCQBugReportingOption bugReportingOptions;

/**
 @brief Sets the default position at which the Luciq screen recording button will be shown. Different orientations are already handled.
 
 @discussion Default for `position` is `bottomRight`.
 */
@property(class, atomic, assign) LCQPosition videoRecordingFloatingButtonPosition;

/**
 @method +showWithReportType:options:
 @brief Shows the compose view of a bug report or a feedback.
 
 @see LCQBugReportingReportType
 @see LCQBugReportingOption
 */
+ (void)showWithReportType:(LCQBugReportingReportType)reportType
                   options:(LCQBugReportingOption)options;

/**
 @brief Dismisses any Luciq views that are currently being shown.
 */
+ (void)dismiss;

/**
 @brief Enables/disables inspect view hierarchy when reporting a bug/feedback.
 */
@property (class, atomic, assign) BOOL shouldCaptureViewHierarchy;

/**
 @brief Sets whether the SDK is recording the screen or not.
 
 @discussion Enabling auto screen recording would give you an insight on the scenario a user has performed before encountering a bug. screen recording is attached with each bug being sent.
 
 Auto screen recording is disabled by default.
 */
@property (class, atomic, assign) BOOL autoScreenRecordingEnabled;

/**
 @brief Sets maximum auto screen recording video duration.
 
 @discussion sets maximum auto screen recording video duration with max value 30 seconds and min value greater than 1 sec.
 */
@property (class, atomic, assign) CGFloat autoScreenRecordingDuration;

/**
 @brief Sets the disclaimer text in the bug report by parsing it and detecting any kind of link. Embedded links should be in Markdown in the form of @code @"[Link Name](http/https://www.example.com)" @endcode
 
 @discussion if `text` in empty or `nil` the disclaimer text view will be hidden. Max characters of the text without the link url is 200 characters and any extra characters will be truncated.
 We will accept links starts with `http` and `https` only.
 */
+ (void)setDisclaimerText:(NSString *_Nullable)text;

/// @brief Sets the minimum accepted number of characters in the comment field in a report
/// @discussion Calling this method will make the comment field required for the specified report types. In case the report's comment is less than the limit set by this API, an alert will be shown to the user and the report will not be sent
/// @param reportTypes The report types to be affected by the limit
/// @param limit The minimum characters allowed for the comment field. Minimum accepted value is 2.
+ (void)setCommentMinimumCharacterCountForReportTypes:(LCQBugReportingReportType)reportTypes
                                            withLimit:(NSInteger)limit __attribute__((unavailable("This API has been removed. Please Use [LCQBugReporting setCommentMinimumCharacterCount: forBugReportType: ]")));

/// @brief Sets the minimum accepted number of characters in the comment field in a report
/// @discussion Calling this method will make the comment field required for the specified report types. In case the report's comment is less than the limit set by this API, an alert will be shown to the user and the report will not be sent
/// @param count The minimum characters allowed for the comment field. Minimum accepted value is 2.
/// @param bugReportType The report categories  to be affected by the limit
+ (void)setCommentMinimumCharacterCount:(NSInteger)count forBugReportType:(LCQBugReportingType)bugReportType;
/// @brief Adds a User Consent to the Bug Reports.
/// @discussion Added User Consents will be displayed in the Bug Reporting UI with all Bug Report types.
/// @param key Consent unique key which will represents the consent on the dashboard. Can't be `nil` or empty string. Adding a consent with the same key as an existing consent will replace it.
/// @param description Consent description to be displayed to the user. If `nil`, a default description will be displayed.
/// @param mandatory If `true`, the user must accept the consent to be able to send the Bug Report.
/// @param checked The consent is checked (accepted) by default or not.
+ (void)addUserConsentWithKey:(NSString *_Nullable)key
                  description:(NSString *_Nullable)description
                    mandatory:(BOOL)mandatory
                      checked:(BOOL)checked;

/// @brief Adds a User Consent to the Bug Reports.
/// @discussion Added User Consents will be displayed in the Bug Reporting UI with all Bug Report types.
/// @param key Consent unique key which will represents the consent on the dashboard. Can't be `nil` or empty string. Adding a consent with the same key as an existing consent will replace it.
/// @param description Consent description to be displayed to the user. If `nil`, a default description will be displayed.
/// @param mandatory If `true`, the user must accept the consent to be able to send the Bug Report.
/// @param checked The consent is checked (accepted) by default or not.
/// @param actionType The action taken by SDK if consent is not checked
+ (void)addUserConsentWithKey:(NSString *_Nullable)key
                  description:(NSString *_Nullable)description
                    mandatory:(BOOL)mandatory
                      checked:(BOOL)checked
                   actionType:(LCQConsentAction)actionType;

/// @brief Sets Proactive Reporting configurations.
/// @discussion Sets a Proactive Reporting configurations controlling proactive reporting settings.
/// @param configurations The configurations object to be set and used to control proactive reporting..
+ (void)setProactiveReportingConfigurations:(LCQProactiveReportingConfigurations * _Nonnull)configurations;

@end

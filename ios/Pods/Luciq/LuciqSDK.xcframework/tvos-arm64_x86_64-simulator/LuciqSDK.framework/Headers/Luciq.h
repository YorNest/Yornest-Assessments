/*
 File:       Luciq/Luciq.h

 Contains:   API for using Luciq's SDK.

 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import <UIKit/UIKit.h>

#if __has_include (<InstabugUtilities/LCQTypes.h>)
#import <InstabugUtilities/LCQTypes.h>
#else
#import "LCQTypes.h"
#endif

@class LCQTheme, LCQReport, LCQFeatureFlag;

/**
 This is the API for using Luciq's SDK. For more details about the SDK integration,
 please visit https://docs.luciq.ai/docs/ios-integration
 */

NS_ASSUME_NONNULL_BEGIN

@interface Luciq : NSObject

/**
 @brief Acts as master switch for Luciq.
 
 @discussion It's enabled by default. When disabled, We will send pending data then disable all features related to Luciq.
 */
@property (class, atomic, assign) BOOL enabled;

/**
 @brief Sets custom branding image asset.
 
 @discussion Set this property to replace Luciq's logo throughout the UI with your own image asset.
 You can register multiple images in the image asset for different display scales and user interface idioms.
 */
@property (class, atomic, strong) UIImageAsset *customBrandingImage;

/**
 @brief Sets custom font.
 
 @discussion Set this property to replace Luciq's font throughout the UI with your own font.
 */
@property (class, atomic, strong) UIFont *font;

/**
 @brief Sets custom theme for the SDK.
 
 @discussion Set this property to change Luciq's fonts and colors throughout the UI.
 */
@property (class, atomic, strong) LCQTheme *theme;

/**
 @brief Sets whether the session profiler is enabled or disabled.
 
 @discussion The session profiler is enabled by default and it attaches to the bug and crash reports the following information during the last 60 seconds before the report is sent.
 1. CPU load.
 2. Dispatch queues latency.
 3. Memory usage.
 4. Storage usage.
 5. Connectivity.
 6. Battery percentage and state.
 7. Orientation.
 */
@property (class, atomic, assign) BOOL sessionProfilerEnabled;

/**
 @brief Enables/Disables instrumenting CoreData operations.
 */
@property (class, atomic, assign) BOOL coreDataInstrumentationEnabled;

/**
 @brief Sets the primary color of the SDK's UI.
 
 @discussion Sets the color of UI elements indicating interactivity or call to action.
 */
@property (class, atomic, strong) UIColor *tintColor __attribute__((unavailable("Luciq.tintColor has been removed. Please use Luciq.theme instead.")));

/**
 @brief Sets a block of code to be executed before sending each report.
 
 @discussion This block is executed in the background before sending each report. Could be used for attaching logs
 and extra data to reports. In case of a crash report, the block will be executed before sending the crash which is on the
 following session, not while the app is crashing.
 
 @param report The report to be sent.
 */
@property(class, atomic, strong) LCQReport*(^willSendReportHandler)(LCQReport *report);

/**
 @brief Sets whether the SDK is tracking user steps or not.
 
 @discussion Enabling user steps would give you an insight on the scenario a user has performed before encountering a
 bug or a crash. User steps are attached with each report being sent.
 
 User Steps tracking is enabled by default if it's available in your current plan.
 */
@property (class, atomic, assign) BOOL trackUserSteps;

/**
 @brief Sets whether the SDK is using Swizzling to track SwiftUI user steps or not.

 SwiftUI User Steps tracking is enabled by default.
 */
@property (class, atomic, assign) BOOL swizzleOnSwiftUIInteractions;

/**
 @brief Sets the welcome message mode to live, beta or disabled.
 
 @discussion By default, the welcome message live mode is enabled. It appears automatically after 10 seconds from the user's first session. You can change it to the beta mode or disable it.
 The live mode consists of one step to inform the users how to report a bug or feedback. The beta mode consists of three steps to welcome your testers on board, inform them how to report a bug or feedback and to motivate them to always be on the latest app version. Please note, the into message appears only if the invocation event isn't set to none.
 */
@property (class, atomic, assign) LCQWelcomeMessageMode welcomeMessageMode;

/**
 @brief Sets a block of code to be executed when a welcome message is dismissed

 */
@property(class, atomic, strong) void(^didDismissWelcomeMessageHandler)(void);

/**
 @brief Attaches user data to each report being sent.
 
 @discussion Each call to this method overrides the user data to be attached.
 Maximum size of the string is 1,000 characters.
 */
@property (class, atomic, strong) NSString *userData;

/**
 @brief Either SwiftUI views should be masked automatically or not

 @discussion Define the behavior for masking SwiftUI views when ``setAutoMaskScreenshots`` is being called.
 This call has no effect if ``setAutoMaskScreenshots`` is not used 
 */
@property (class, assign) BOOL autoMaskAllSwiftUIViews;

/**
 @brief Sets the appVariant value before SDK initialization.

 @discussion This property sets the `appVariant` string to be included in all network requests.
 It should be set before calling `startWithToken`.

 @limitations
  - The maximum length for `appVariant` is **30 characters**; any excess characters will be **trimmed**.
  - Any **leading or trailing whitespace** will be automatically **trimmed**.
  - If set multiple times, only the **last assigned value** will be used.
  - All **cached requests** will include the most recently set `appVariant` value.
 */

@property (class, nullable, strong) NSString *appVariant;

/**
 @brief Starts the SDK.
 
 @discussion This is the main SDK method that does all the magic. This is the only method that SHOULD be called.
 Should be called at the end of `-[UIApplicationDelegate application:didFinishLaunchingWithOptions:]`.
 
 @param token The token that identifies the app, you can find it on your dashboard.
 @param invocationEvents One or more event that invokes the SDK's UI.
 
 @see LCQInvocationEvent
 */
+ (void)startWithToken:(NSString *)token invocationEvents:(LCQInvocationEvent)invocationEvents;

/**
 @brief Set codePush version before starting the SDK.
 
 @discussion Sets Code Push version to be used for all reports.
 should be called from `-[UIApplicationDelegate application:didFinishLaunchingWithOptions:]`
 and before `startWithToken`.
 
 @Note Should only be set for React Native apps
 
 @param codePushVersion the Code Push version to with.
 */
+ (void)setCodePushVersion:(nullable NSString *)codePushVersion DEPRECATED_MSG_ATTRIBUTE("Luciq.setCodePushVersion is deprecated. Use Luciq.setOverAirVersion instead.");

/**
 @brief Set over-the-air update version before starting the SDK.
 
 @discussion Sets Over Air version to be used for all reports.
 should be called before `startWithToken`.
 
 @Note Should only be set for React Native apps
 
 @param overAirVersion the over-the-air update version.
 @param type an enum to set over-the-air type.
 */
+ (void)setOverAirVersion:(nullable NSString *)overAirVersion withType:(LCQOverAirType)type;

/**
@brief Control what type of views should not be captured when capturing a screenshot

@discussion This method helps keep the customer data private based on the what views is considered private. The masked views will neither be captured nor saved on the disk. Masked views will be replaced with a black view.

@param autoMaskScreenshots one or more masking Options. Default value is masking nothing
*/
+ (void)setAutoMaskScreenshots:(LCQAutoMaskScreenshotOption)autoMaskScreenshots;

/**
 @brief Shows Luciq Prompt Options.
 
 @discussion By default, it contains Report a problem, Suggest an improvement, Ask a question, and a button that navigates to the chats list. To control which options should be enabled, see LCQBugReporting.enabled, LCQReplies.enabled.
 */
+ (void)show;

/**
 @brief Add file to attached files with each report being sent.

 @discussion A new copy of the file at fileURL will be attached with each bug report being sent. The file is only copied
 at the time of sending the report, so you could safely call this API whenever the file is available on disk, and the copy
 attached to your bug reports will always contain that latest changes at the time of sending the report.

 Each call to this method adds the file to the files attached, until a maximum of 3 then it overrides the first file. 
 The file has to be available locally at the provided path when the report is being sent.

 @param fileURL Path to a file that's going to be attached to each report.
 */
+ (void)addFileAttachmentWithURL:(NSURL *)fileURL;


/**
 @brief Add a set of data as a file attachment to be sent with each report.
 
 @discussion The data will be written to a file and will be attached with each report.
 
 Each call to this method adds this set of data as a file attachment, until a maximum of 3 then it overrides the first data.
 
 @param data NSData to be added as a file attachment with each report.
 */
+(void)addFileAttachmentWithData:(NSData *)data;

/**
 @brief Add a set of data as a file attachment to be sent with each report.
 
 @discussion The data will be written to a file with the specified name and will be attached with each report.
 
 Each call to this method adds this set of data as a file attachment, until a maximum of 3 then it overrides the first data.
 
 @param data NSData to be added as a file attachment with each report.
 @param name NSString name of the file including the extension. Allowed format is Alphanumeric and [-_.] as special characters.
 */
+ (void)addFileAttachmentWithData:(NSData *)data andName:(NSString *)name;

/**
 @brief Clear list of files to be attached with each report.

 @discussion This method doesn't delete any files from the file system. It will just removes them for the list of files
 to be attached with each report.
 */
+ (void)clearFileAttachments;

/**
 @brief Shows the welcome message in a specific mode.

 @discussion By default, the welcome message live mode is enabled. It appears automatically after 10 seconds from the user's first session. You can show it manually in a specific mode through this API.
 The live mode consists of one step to inform the users how to report a bug or feedback. The beta mode consists of three steps to welcome your testers on board, inform them how to report a bug or feedback and to motivate them to always be on the latest app version. Please note, the into message appears only if the invocation event isn't set to none.
 
 @param welcomeMessageMode An enum to set the welcome message mode to live, beta or disabled.
 */
+ (void)showWelcomeMessageWithMode:(LCQWelcomeMessageMode)welcomeMessageMode;


/**
 @brief Sets the user email and name for all sent reports.
 
 @param email Email address to be set as the user's email.
 @param name Name of the user to be set.
 */
+ (void)identifyUserWithEmail:(NSString *)email name:(nullable NSString *)name
    __attribute__((unavailable("This method has been removed. Use [Luciq identifyUserWithID:email:name:] instead.")));

/**
 @brief Sets the user email and name for all sent reports.
 
 @param userID ID to be set as the user's id.
 @param email Email address to be set as the user's email.
 @param name Name of the user to be set.
 */
+ (void)identifyUserWithID:(nullable NSString *)userID email:(nullable NSString *)email name:(nullable NSString *)name;

/**
 @brief Resets the value of the user's email and name, previously set using `+ [Luciq identifyUserWithID:email:name:]`.
 
 @discussion This method also resets all chats currently on the device and removes any set user attributes.
 */
+ (void)logOut;

/**
 @brief Sets the SDK's locale.
 
 @discussion Use to change the SDK's UI to different language.
 Defaults to the device's current locale.
 
 @param locale A locale to set the SDK to.
 
 @see LCQLocale
 */
+ (void)setLocale:(LCQLocale)locale;

/**
 @brief Sets the color theme of the SDK's whole UI.
 
 @discussion Defaults is `LCQColorThemeLight`. Color theme is not updated
 automatically based on iOS Light or Dark mode changes.

 @param colorTheme An `LCQColorTheme` to set the SDK's UI to.
 
 @see LCQColorTheme
 */
+ (void)setColorTheme:(LCQColorTheme)colorTheme;

/**
 @brief Sets a block of code that is used to capture a screenshot.
 
 @discussion Should only be used if your app uses OpenGL.
 
 @param screenshotCapturingHandler A block of code that's going to be used to capture screenshots.
 */
+ (void)setScreenshotCapturingHandler:(UIImage *(^)(void))screenshotCapturingHandler;

/**
 @brief Appends a set of tags to previously added tags of reported feedback, bug or crash.

 @param tags An array of tags to append to current tags.
*/
+ (void)appendTags:(NSArray<NSString *> *)tags;

/**
 @brief Manually removes all tags of reported feedback, bug or crash.
 */
+ (void)resetTags;

/**
 @brief Gets all tags of reported feedback, bug or crash.
 
 @return An array of tags.
 */
+ (NSArray *)getTags;

/**
 @brief Overrides any of the strings shown in the SDK with custom ones.
 
 @discussion Allows you to customize any of the strings shown to users in the SDK.
 
 @param value String value to override the default one.
 @param key Key of string to override. Use predefined keys like LCQShakeStartAlertTextStringName,
 LCQEmailFieldPlaceholderStringName, etc.
 
 @see LCQTypes
 */
+ (void)setValue:(NSString *)value forStringWithKey:(NSString *)key;

/**
 @brief Set custom user attributes that are going to be sent with each feedback, bug or crash.
 
 @param value User attribute value.
 @param key User attribute key.
 */
+ (void)setUserAttribute:(NSString *)value withKey:(NSString *)key;

/**
 @brief Returns the user attribute associated with a given key.

 @param key The key for which to return the corresponding value..
 
 @return The value associated with aKey, or nil if no value is associated with aKey.
 */
+ (nullable NSString *)userAttributeForKey:(NSString *)key;

/**
 @brief Removes a given key and its associated value from user attributes.
 
 Does nothing if aKey does not exist.
 
 @param key The key to remove.
 */
+ (void)removeUserAttributeForKey:(NSString *)key;

/**
 @brief Returns all user attributes.
 
 @return A new dictionary containing all the currently set user attributes, or an empty dictionary if no user attributes have been set.
 */
+ (nullable NSDictionary *)userAttributes;

/**
 @brief Added Experiments will be attached with all crash reports, including Fatal, Non-fatal and OOM crashes.
 
 @discussion You can have a total of 600 experiments. Exceeding maximum limit will cause previously added experiments to be dropped.

 An Experiment string length shouldn't exceed 70 characters limit. Experiments which exceed that limit won't be added.

 Experiments strings are not case-sensitive.
 */
+ (void)addExperiments:(NSArray<NSString *> *)experiments __attribute__((unavailable("Experiments has been replaced with Feature Flags. Please use [Luciq addFeatureFlag:] or [Luciq addFeatureFlags:] instead")));

/**
 @brief Remove previously added Experiments.
 */
+ (void)removeExperiments:(NSArray<NSString *> *)experiments __attribute__((unavailable("Experiments has been replaced with Feature Flags. Please use [Luciq removeFeatureFlag:] instead")));

/**
 @brief Clear all saved experiments.
 */
+ (void)clearAllExperiments __attribute__((unavailable("Experiments has been replaced with Feature Flags. Please use [Luciq removeAllFeatureFlags] instead")));

/**
 @brief Add a single Feature flag

 @discussion You can have a total of 200 feature flags. Exceeding maximum limit will cause previously added feature flags to be dropped.
 
 A Feature flag string length shouldn't exceed 70 characters limit. Feature flags which exceed that limit won't be added.
 */
+ (void)addFeatureFlag:(LCQFeatureFlag *)featureFlag NS_SWIFT_NAME(add(featureFlag:));

/**
 @brief Add multiple Feature flags

 @discussion You can have a total of 200 feature flags. Exceeding maximum limit will cause previously added feature flags to be dropped.
 
 A Feature flag string length shouldn't exceed 70 characters limit. Feature flags which exceed that limit won't be added.
 */
+ (void)addFeatureFlags:(NSArray<LCQFeatureFlag *> *)featureFlags NS_SWIFT_NAME(add(featureFlags:));
/**
 @brief Remove previously added Feature flag.
 */
+ (void)removeFeatureFlag:(NSString *)featureFlag;
/**
 @brief Remove previously added Feature flags.
 */
+ (void)removeFeatureFlags:(NSArray<LCQFeatureFlag *> *)featureFlags NS_SWIFT_NAME(remove(featureFlags:));

/**
 @brief Clear all saved Feature flags.
 */
+ (void)removeAllFeatureFlags;

/// -------------------
/// @name SDK Reporting
/// -------------------

/**
 @brief Logs a user event that happens through the lifecycle of the application.
 
 @discussion Logged user events are going to be sent with each report, as well as at the end of a session.
 
 @param name Event name.
 */
+ (void)logUserEventWithName:(NSString *)name;

/**
 @brief Disable all method swizzling inside SDK. You need to call this API before startWithToken:
 
 @discussion Disable all method swizzling inside SDK. Disable method swizzling will affect the automatic capturing of user steps and repro steps inside the SDK so you need to use manual APIs to make it work again.
 
 */
+ (void)disableMethodSwizzling;

/**
@brief Log view did appear event when you disable method swizzling

@discussion Log  view did appear event when you disable method swizzling. This will be reflected in user steps and repro steps.
 
@param viewName Name of view controller.
*/
+ (void)logViewDidAppearEvent:(NSString *)viewName;

/**
@brief Log user's touch event when you disable method swizzling

@discussion Log user's touch event when you disable method swizzlin. This will be reflected in user steps and repro steps.
 
@param event An enum to set user's touch event.
@param viewName View that recieves this event.
*/
+ (void)logTouchEvent:(LCQUIEventType)event viewName:(NSString *)viewName;

/**
 @brief Async method that gets the UUID for the current user
 
 @discussion As this method gets the UUID, we recommend using it only in case the user's email is not identified. Using the email is our top recommendation when communicating with Luciq's APIs. So, unless the user's email is not available, please don't depend on the UUID
 @param userUUIDCompletionHandler Receives the value saved for the current user UUID.
 nil will be returned in one of case of Luciq not initialized or is disabled.
 */
+ (void)userUUID:(void (^)(NSString * _Nullable uuid))userUUIDCompletionHandler;

/**
 @brief Sets whether user steps tracking is visual, non visual or disabled.

 @discussion Enabling user steps would give you an insight on the scenario a user has
 performed before encountering a bug or a crash. User steps are attached with each report being sent.

 User Steps tracking is enabled by default if it's available in your current plan.
 @param issueType The type of issues that will be affected by this call
 @param mode The mode that shoud be set, each report type has its own default mode
 */
+ (void)setReproStepsFor:(LCQIssueType)issueType withMode:(LCQUserStepsMode)mode;

/**
 @brief Notifies Luciq that the app is going to redirect to the App Store.

 @discussion Call this API exactly before redirecting the App Store
 using openURL:options:completionHandler:
 */
+ (void)willRedirectToAppStore;

/**
 @brief Triggers Luciq to capture a screenshot from the current content on the screen

 @discussion There is a one-sec cooldown period between each API call. Any api calls done within this 1-sec period will be ignored.
 This is to reduce the impacton the main thread as capturing screenshots is a heavy operation.
 All the configurations done for the automatic screenshots capturing logic will be respected from this API
 */
+ (void)captureScreenshot;

/**
 @brief Sets whether data stored in user defaults should be encrypted or not..

 @discussion Values stored in user defaults are encrypted by default. Set this property to false to override this behavior and store values as plaintext instead.
 */
@property (class, atomic, assign) BOOL userDefaultsEncryptionEnabled;

#pragma mark - SDK Debugging

/// ------------------------
/// @name SDK Debugging
/// ------------------------

/**
 @brief Sets the verbosity level of logs used to debug the Luciq SDK itself.
 
 @discussion This API sets the verbosity level of logs used to debug The SDK. The defualt value in debug mode is LCQSDKDebugLogsLevelVerbose and in production is LCQSDKDebugLogsLevelError.
 */
@property (class, atomic, assign) LCQSDKDebugLogsLevel sdkDebugLogsLevel;

@end


NS_ASSUME_NONNULL_END

/*
 File:       Luciq/LCQCrashReporting.h
 
 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.
 
 Version:    19.1.1
 */

#import <Foundation/Foundation.h>

#if __has_include (<InstabugCrashReporting/LCQNonFatal.h>)
#import <InstabugCrashReporting/LCQNonFatal.h>
#else
#import "LCQNonFatal.h"
#endif

#if __has_include (<InstabugCoreInternal/LCQCrashMetaData.h>)
#import <InstabugCoreInternal/LCQCrashMetaData.h>
#else
#import "LCQCrashMetaData.h"
#endif

#if __has_include (<InstabugUtilities/LCQTypes.h>)
#import <InstabugUtilities/LCQTypes.h>
#else
#import "LCQTypes.h"
#endif

#if __has_include (<InstabugCrashReporting/LCQNonFatal.h>)
#import <InstabugCrashReporting/LCQCrashReportWriter.h>
#else
#import "LCQCrashReportWriter.h"
#endif

#if __has_include (<InstabugCoreInternal/LCQCrashReporterState.h>)
#import <InstabugCoreInternal/LCQCrashReporterState.h>
#else
#import "LCQCrashReporterState.h"
#endif

NS_SWIFT_NAME(CrashReporting)
@interface LCQCrashReporting : NSObject

/**
 @brief Enable/Disable crash reporting.
 
 Crash reporting is enabled by default. If you need to disable it, It's recommended to call it before startWithToken.
 */
@property (class, atomic, assign) BOOL enabled;

/**
 @brief Enable/Disable out of memory crash reporting.
 
 Out of memory crash reporting is enabled by default. OOM will be disabled if crash reporting is disabled.
 */
@property (class, atomic, assign) BOOL OOMEnabled;

/**
@brief Controls the reporting of application hangs.

@discussion
This feature is forcibly disabled if Crash Reporting is disabled.

The default value is true.
*/
@property (class, atomic, assign) BOOL appHangEnabled;

/**
 @brief Controls the reporting of application force restart .

 @discussion
This feature is forcibly disabled if Crash Reporting is disabled.

The default value is true.
 */
@property (class, atomic, assign) BOOL forceRestartEnabled;

/**
 @brief Sets a block of code to be executed when a crash happens.

 @discussion This block of code will be executed on the \b main thread after a crash is reported to the dashboard.

 */
@property (class, atomic, copy) void(^didSendCrashReportHandler)(LCQCrashMetaData *);

/**
 * Defines a completion type for handling crash report consent.
 *
 * This completion type takes an LCQCrashReportConsent parameter and does not return a value.
 *
 * @param consent An LCQCrashReportConsent value representing the user's consent for crash reporting.
 */
typedef void (^LCQCrashReportConsentReplyHandler)(LCQCrashReportConsent consent);
/**
 @brief A callback function that instructs Luciq to await user confirmation before sending crash reports. This callback specifically applies
 to fatal errors (crashes), force restart and out-of-memory (OOM) reports, excluding app hangs and non-fatals errors.

 If no response is received within a 2-minute window, the callback triggers a timeout mechanism, preventing the automatic sending of the crash report.
 
 @Note This callback is designed to enhance user privacy and control by giving them the option to approve or decline the submission of crash reports, ensuring a more transparent and user-centric experience.

 @property onWillSendCrashReportHandler
   A class property that accepts an LCQCrashType representing the crash type and
   an LCQCrashReportConsentReplyHandler block for managing crash report consent.

 Objective c Example usage:
 @code
   LCQCrashReporting.onWillSendCrashReportHandler = ^(LCQCrashType crashType, LCQCrashReportConsentReplyHandler completionHandler) {
       // Your implementation to handle crash report consent and sending mechanism
   };
 @endcode

 Swift Example usage:
 @code
     CrashReporting.onWillSendCrashReportHandler = { (crashType, completionHandler) in
         // Your implementation to handle crash report consent and sending mechanism
     }
 @endcode
 */
@property (class, atomic, copy) void (^onWillSendCrashReportHandler)(LCQCrashType crashType, LCQCrashReportConsentReplyHandler completionHandler);

typedef void (*OnCrashCallback)(struct LCQCrashReportWriter *);
/**
 @brief C callback function that called when Luciq caught a crash and wait user to add crash metadata
 */
@property (class, atomic, assign) OnCrashCallback onCrashHandler;

/**
 @brief Enable/Disable unhandled crash reporting.
 
 Unhandled crash reporting is enabled by default. If you need to disable it, you need to call it before startWithToken, And It will disable OOM as well.
 */
@property (class, atomic, assign) BOOL unhandledEnabled;

/**
 @brief Enable/Disable collecting user identification data in crash reports. It's recommended to set this variable after the `startWithToken` method call

 Crash reporting collects the user identification data by default.
 */
@property (class, atomic, assign) BOOL userIdentificationDataCollectionEnabled;

/**
 @brief Returns true if the last session ended with a fatal crash (not including OOM crashes).
 */
@property (class, nonatomic, readonly) BOOL didLastSessionCrash;

/**
 * An API property used to configure the launch duration in milliseconds.
 *
 * @discussion The default value is 5000 milliseconds. Crashes occurring before the launch duration
 * has passed will be marked as launch crashes and sent synchronously if enableSendingLaunchCrashesSynchronously
 * is enabled.
 *
 * @note Launch start is defined as when the startWithToken method is called.
 * @note This should be called before startWithToken.
 * @note Only values between 0 and 20000 milliseconds are valid. Values outside this range will be ignored.
 */
@property (class, nonatomic) double launchDuration;

/**
 * Marks the launch as completed.
 *
 * @discussion Crashes occurring after this call will be treated as regular crashes. Crashes occurring
 * before this call will be marked as launch crashes and sent synchronously if enableSendingLaunchCrashesSynchronously
 * is enabled.
 *
 * @note This should be called after startWithToken otherwise will be ignored and the launch will respect to `launchDuration`
 * @note will be ignored if called after the launch duration
 */
+ (void)markLaunchCrashFree;

/**
 * Enables synchronous sending of launch crashes with default timeout.
 *
 * @discussion When enabled, launch crashes will be sent by blocking the main thread while the crash is sent.
 * If not called, all crashes will be sent asynchronously with the normal flow.
 *
 * @note This should be called before startWithToken.
 * @note Uses default timeout of 2000 milliseconds.
 */
+ (void)enableSendingLaunchCrashesSynchronously;

/**
 * Enables synchronous sending of launch crashes with custom timeout.
 *
 * @discussion When enabled, launch crashes will be sent by blocking the main thread while the crash is sent.
 * If not called, all crashes will be sent asynchronously with the normal flow.
 *
 * @param timeout The maximum duration to block the main thread while sending launch crashes (in milliseconds).
 * @note This should be called before startWithToken.
 * @note Only timeout values between 1000 and 5000 milliseconds are valid. Values outside this range will be
 * ignored and the default 2000ms timeout will be used instead.
 */
+ (void)enableSendingLaunchCrashesSynchronouslyWithTimeout:(double)timeout;

/**
 @brief Creates a new NonFatalException object to report a handled exception with customizable metadata.

 @param exception exception to be reported
 @returns NonFatalException object
 */
+ (LCQNonFatalException *)exception:(NSException *)exception;

/**
 @brief Creates a new NonFatalError object to report a handled error with customizable metadata.

 @param error error to be reported
 @returns NonFatalError object
 */
+ (LCQNonFatalError *)error:(NSError *)error;

/**
 @brief Returns an `LCQCrashReporterState` object with the state of the currently registered crash reporter and Luciq's crash reporter.
 
 @returns `LCQCrashReporterState` object if the SDK has been initialized and `nil` otherwise.
 */
+ (LCQCrashReporterState *)crashReporterState;

@end

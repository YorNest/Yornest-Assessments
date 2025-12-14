/*
 File:       Luciq/LCQLog.h
 
 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import <Foundation/Foundation.h>

@interface LCQLog : NSObject

@property (class, atomic, assign) BOOL printsToConsole;

/**
 @brief Adds custom logs that will be sent with each report. Logs are added with the debug log level.
 
 @param log Message to be logged.
 */
+ (void)log:(NSString *)log;

/**
 @brief Adds custom logs with the verbose log level. Logs will be sent with each report.
 
 @param log Message to be logged.
 */
+ (void)logVerbose:(NSString *)log;

/**
 @brief Adds custom logs with the debug log level. Logs will be sent with each report.
 
 @param log Message to be logged.
 */
+ (void)logDebug:(NSString *)log;

/**
 @brief Adds custom logs with the info log level. Logs will be sent with each report.
 
 @param log Message to be logged.
 */
+ (void)logInfo:(NSString *)log;

/**
 @brief Adds custom logs with the warn log level. Logs will be sent with each report.
 
 @param log Message to be logged.
 */
+ (void)logWarn:(NSString *)log;

/**
 @brief Adds custom logs with the error log level. Logs will be sent with each report.
 
 @param log Message to be logged.
 */
+ (void)logError:(NSString *)log;

/**
 @brief Clear all Logs.
 
 @discussion Clear all Luciq logs, console logs, network logs and user steps.
 
 */
+ (void)clearAllLogs;

/**
 @brief Adds custom logs that will be sent with each report.
 
 @discussion Can be used in a similar fashion to NSLog. Logs are added with the debug log level.
 For usage in Swift, see `LCQLog.log()`.
 
 @param format Format string.
 @param ... Optional varargs arguments.
 */
OBJC_EXTERN void LuciqLog(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

/**
 @brief Adds custom logs with the verbose log level. Logs will be sent with each report.
 
 @discussion Can be used in a similar fashion to NSLog. For usage in Swift, see `LCQLog.logVerbose()`.
 
 @param format Format string.
 @param ... Optional varargs arguments.
 */
OBJC_EXTERN void LCQLogVerbose(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

/**
 @brief Adds custom logs with the debug log level. Logs will be sent with each report.
 
 @discussion Can be used in a similar fashion to NSLog. For usage in Swift, see `LCQLog.logDebug()`.
 
 @param format Format string.
 @param ... Optional varargs arguments.
 */
OBJC_EXTERN void LCQLogDebug(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

/**
 @brief Adds custom logs with the info log level. Logs will be sent with each report.
 
 @discussion Can be used in a similar fashion to NSLog. For usage in Swift, see `LCQLog.logInfo()`.
 
 @param format Format string.
 @param ... Optional varargs arguments.
 */
OBJC_EXTERN void LCQLogInfo(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

/**
 @brief Adds custom logs with the warn log level. Logs will be sent with each report.
 
 @discussion Can be used in a similar fashion to NSLog. For usage in Swift, see `LCQLog.logWarn()`.
 
 @param format Format string.
 @param ... Optional varargs arguments.
 */
OBJC_EXTERN void LCQLogWarn(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

/**
 @brief Adds custom logs with the error log level. Logs will be sent with each report.
 
 @discussion Can be used in a similar fashion to NSLog. For usage in Swift, see `LCQLog.logError()`.
 
 @param format Format string.
 @param ... Optional varargs arguments.
 */
OBJC_EXTERN void LCQLogError(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2) ;

/**
 @brief Used to reroute all your NSLogs to Luciq to be able to automatically include them with reports.
 
 @discussion For details on how to reroute your NSLogs to Luciq, see https://docs.luciq.ai/docs/ios-logging
 
 @param format Format string.
 @param args Arguments list.
 */
OBJC_EXTERN void LCQNSLog(NSString *format, va_list args);

/**
 @brief Used to reroute all your NSLogs to Luciq with their log level to be able to automatically include them with reports.
 
 @discussion For details on how to reroute your NSLogs to Luciq, see https://docs.luciq.ai/docs/ios-logging
 
 @param format Format string.
 @param args Arguments list.
 @param logLevel log level.
 */
OBJC_EXTERN void LCQNSLogWithLevel(NSString *format, va_list args, LCQLogLevel logLevel);

@end

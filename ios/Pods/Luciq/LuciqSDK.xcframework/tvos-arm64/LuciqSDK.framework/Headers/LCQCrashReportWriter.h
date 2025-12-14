/*
 File:       Luciq/LCQCrashReportWriter.h

 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#ifndef LCQCrashReportWriter_h
#define LCQCrashReportWriter_h

#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>

#ifdef __OBJC__
#include <Foundation/Foundation.h>
#endif

#if __has_include (<InstabugUtilities/LCQCrashAsyncFile.h>)
#import <InstabugUtilities/LCQCrashAsyncFile.h>
#else
#import "LCQCrashAsyncFile.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef struct LCQCrashReportWriterContext {
    const char *filePath;
    lcqcrash_async_file_t file;
    
    /** true if this is the first entry at the current container level. */
    bool containerFirstEntry;
    
    int addedElementsCount;
    
    /** Close File by writer Context*/
    void (*closeFile)(struct LCQCrashReportWriterContext *const context);
} LCQCrashReportWriterContext NS_SWIFT_NAME(CrashReportWriterContext);

/**
 * Encapsulates report writing functionality.
 */
typedef struct LCQCrashReportWriter {
    /** Internal contextual data for the writer */
    void *context;
    
    /** Add an integer element to the report.
     * @param writer This writer.
     * @param key The name to give this element.
     * @param value The value to add.
     */
    void (*addIntegerElement)(struct LCQCrashReportWriter *writer, const char *key, int64_t value);
    
    /** Add an unsigned integer element to the report.
     * @param writer This writer.
     * @param key The name to give this element.
     * @param value The value to add.
     */
    void (*addUIntegerElement)(struct LCQCrashReportWriter *writer, const char *key, uint64_t value);
    
    /** Add a string element to the report.
     * @param writer This writer.
     * @param key The name to give this element.
     * @param value The string value to add.
     */
    void (*addStringElement)(struct LCQCrashReportWriter *writer, const char *key, const char *value);
} LCQCrashReportWriter NS_SWIFT_NAME(CrashReportWriter);

#ifdef __cplusplus
}
#endif

#endif  // LCQCrashReportWriter_h



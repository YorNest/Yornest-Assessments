/*
 File:       Luciq/LCQCrashAsyncFile.h

 Contains:   API for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#ifndef lcqcrash_async_file_h
#define lcqcrash_async_file_h


#ifdef __cplusplus
extern "C" {
#endif


/**
 * @internal
 * @ingroup lcqcrash_async_bufio
 *
 * Async-safe buffered file output. This implementation is only intended for use
 * within signal handler execution of crash log output.
 */
typedef struct lcqcrash_async_file {
    /** Output file descriptor */
    int fd;
    
    /** Output limit */
    off_t limit_bytes;
    
    /** Total bytes written */
    off_t total_bytes;
    
    /** Current length of data in buffer */
    size_t buflen;
    
    /** Buffered output */
    char buffer[256];
} lcqcrash_async_file_t;

#ifdef __cplusplus
}
#endif

#endif /* lcqcrash_async_file_h */

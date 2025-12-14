/*
 File:       LuciqSDK/LuciqSDK.h

 Contains:   API for using Luciq's SDK.

 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.

 Version:    19.1.1
 */

#import "LCQNetworkLogger.h"
#import "LCQLog.h"

#if __has_include (<InstabugI/Luciq.h>)
#import <InstabugI/Luciq.h>
#else
#import "Luciq.h"
#endif

#if __has_include (<InstabugUtilities/UIView+Luciq.h>)
#import <InstabugUtilities/UIView+Luciq.h>
#else
#import "UIView+Luciq.h"
#endif

#if __has_include (<InstabugCoreInternal/LCQReport.h>)
#import <InstabugCoreInternal/LCQReport.h>
#else
#import "LCQReport.h"
#endif

#if __has_include (<InstabugCoreInternal/LCQFeatureFlag.h>)
#import <InstabugCoreInternal/LCQFeatureFlag.h>
#else
#import "LCQFeatureFlag.h"
#endif

#if __has_include (<InstabugDefaults/LCQTheme.h>)
#import <InstabugDefaults/LCQTheme.h>
#else
#import "LCQTheme.h"
#endif

#if !TARGET_OS_TV
#if __has_include (<InstabugUserSteps/LCQUserStep.h>)
#import <InstabugUserSteps/LCQUserStep.h>
#else
#import "LCQUserStep.h"
#endif
#endif

#if __has_include("LCQBugReporting.h")
#import "LCQBugReporting.h"
#endif

#if __has_include (<InstabugCrashReporting/LCQCrashReporting.h>)
#import <InstabugCrashReporting/LCQCrashReporting.h>
#elif __has_include("LCQCrashReporting.h")
#import "LCQCrashReporting.h"
#endif

#if __has_include("LCQSurveys.h")
#import "LCQSurveys.h"
#endif

#if __has_include (<InstabugFeatureRequests/LCQFeatureRequests.h>)
#import <InstabugFeatureRequests/LCQFeatureRequests.h>
#elif __has_include ("LCQFeatureRequests.h")
#import "LCQFeatureRequests.h"
#endif

#if __has_include (<InstabugI/LCQReplies.h>)
#import <InstabugI/LCQReplies.h>
#elif __has_include ("LCQReplies.h")
#import "LCQReplies.h"
#endif

#if __has_include (<InstabugAPM/LCQAPM.h>)
#import <InstabugAPM/LCQAPM.h>
#elif __has_include ("LCQAPM.h")
#import "LCQAPM.h"
#endif

#if __has_include (<InstabugSessionReplay/LCQSessionReplay.h>)
#import <InstabugSessionReplay/LCQSessionReplay.h>
#elif __has_include("LCQSessionReplay.h")
#import "LCQSessionReplay.h"
#endif

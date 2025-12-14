/*
 File:       Luciq/LCQTypes.h
 
 Contains:   Enums and Constants for using Luciq's SDK.
 
 Copyright:  (c) 2013-2025 by Luciq, Inc., all rights reserved.
 
 Version:    19.1.1
 */

#import <UIKit/UIKit.h>

/// ------------------------------
/// @name User-facing Strings Keys
/// ------------------------------

// Predefined keys to be used to override any of the user-facing strings in the SDK. See + [Luciq setValue:forStringWithKey]

extern NSString * const kLCQStartAlertTextStringName;
extern NSString * const kLCQShakeStartAlertTextStringName;
extern NSString * const kLCQTwoFingerSwipeStartAlertTextStringName;
extern NSString * const kLCQEdgeSwipeStartAlertTextStringName;
extern NSString * const kLCQScreenshotStartAlertTextStringName;
extern NSString * const kLCQFloatingButtonStartAlertTextStringName;
extern NSString * const kLCQBetaWelcomeMessageWelcomeStepTitle;
extern NSString * const kLCQBetaWelcomeMessageWelcomeStepContent;
extern NSString * const kLCQBetaWelcomeMessageHowToReportStepTitle;
extern NSString * const kLCQBetaWelcomeMessageHowToReportStepContent;
extern NSString * const kLCQBetaWelcomeMessageFinishStepTitle;
extern NSString * const kLCQBetaWelcomeMessageFinishStepContent;
extern NSString * const kLCQBetaWelcomeDoneButtonTitle;
extern NSString * const kLCQLiveWelcomeMessageTitle;
extern NSString * const kLCQLiveWelcomeMessageContent;
extern NSString * const kLCQInvalidEmailMessageStringName;
extern NSString * const kLCQInvalidEmailTitleStringName;
extern NSString * const kLCQInvalidNumberTitleStringName;
extern NSString * const kLCQReportCategoriesAccessibilityScrollStringName;
extern NSString * const kLCQAnnotationCloseButtonStringName;
extern NSString * const kLCQAnnotationSaveButtonStringName;
extern NSString * const kLCQAnnotationDrawnShapeStringName;
extern NSString * const kLCQAttachmentActionSheetStopScreenRecording;
extern NSString * const kLCQAttachmentActionSheetUnmuteMic;
extern NSString * const kLCQAttachmentActionSheetMuteMic;
extern NSString * const kLCQScreenRecordingDuration;
extern NSString * const kLCQInvalidNumberMessageStringName;
extern NSString * const kLCQCloseConversationsStringLabel;
extern NSString * const kLCQBackToConversationsStringLabel;
extern NSString * const kLCQSendMessageStringLabel;
extern NSString * const kLCQDismissMessageStringLabel;
extern NSString * const kLCQReplyToMessageStringLabel;
extern NSString * const kLCQInvocationTitleStringName;
extern NSString * const kLCQInvocationTitleHintStringName;
extern NSString * const kLCQChatsListHintStringName;
extern NSString * const kLCQOneChatsListHintStringName;
extern NSString * const kLCQOneChatsListHintStringName;
extern NSString * const kLCQCancelPromptHintStringName;
extern NSString * const kLCQReportCategoriesBackButtonStringName;
extern NSString * const kLCQReportCategoriesBackButtonHintStringName;
extern NSString * const kLCQAskAQuestionStringName;
extern NSString * const kLCQFrustratingExperienceStringName;
extern NSString * const kLCQReportBugStringName;
extern NSString * const kLCQReportFeedbackStringName;
extern NSString * const kLCQReportBugDescriptionStringName;
extern NSString * const kLCQReportFeedbackDescriptionStringName;
extern NSString * const kLCQReportQuestionDescriptionStringName;
extern NSString * const kLCQRequestFeatureDescriptionStringName;

extern NSString * const kLCQProactiveReportingForceRestartAlertTitle;
extern NSString * const kLCQProactiveReportingForceRestartAlertMessage;
extern NSString * const kLCQProactiveReportingReportActionTitleName;
extern NSString * const kLCQProactiveReportingCancelActionTitleName;

extern NSString * const kLCQAccessibilityReportFeedbackDescriptionStringName;
extern NSString * const kLCQAccessibilityReportBugDescriptionStringName;
extern NSString * const kLCQAccessibilityRequestFeatureDescriptionStringName;
extern NSString * const kLCQPhotoPickerTitle;
extern NSString * const kLCQProgressViewTitle;
extern NSString * const kLCQGalleryPermissionDeniedAlertTitle;
extern NSString * const kLCQGalleryPermissionDeniedAlertMessage;
extern NSString * const kLCQMaximumSizeExceededAlertTitle;
extern NSString * const kLCQMaximumSizeExceededAlertMessage;
extern NSString * const kLCQiCloudImportErrorAlertTitle;
extern NSString * const kLCQiCloudImportErrorAlertMessage;
extern NSString * const kLCQEmailFieldPlaceholderStringName;
extern NSString * const kLCQEmailFieldAccessibilityStringLabel;
extern NSString * const kLCQEmailFieldAccessibilityStringHint;
extern NSString * const kLCQNumberFieldPlaceholderStringName;
extern NSString * const kLCQNumberInfoAlertMessageStringName;
extern NSString * const kLCQCommentFieldPlaceholderForBugReportStringName;
extern NSString * const kLCQCommentFieldPlaceholderForFeedbackStringName;
extern NSString * const kLCQCommentFieldPlaceholderForQuestionStringName;
extern NSString * const kLCQCommentFieldPlaceholderForFrustratingExperienceStringName;
extern NSString * const kLCQCommentFieldAccessibilityStringLabel;
extern NSString * const kLCQCommentFieldBugAccessibilityStringHint;
extern NSString * const kLCQCommentFieldImprovementAccessibilityStringHint;
extern NSString * const kLCQCommentFieldAskQuestionAccessibilityStringHint;
extern NSString * const kLCQCommentFieldFrustratingExperienceAccessibilityStringHint;
extern NSString * const kLCQChatReplyFieldPlaceholderStringName;
extern NSString * const kLCQAddScreenRecordingMessageStringName;
extern NSString * const kLCQAddVoiceMessageStringName;
extern NSString * const kLCQAddImageFromGalleryStringName;
extern NSString * const kLCQExtraFieldsStringLabel;
extern NSString * const kLCQAccessibilityExtraFieldsStepsLabel;
extern NSString * const kLCQAccessibilityExtraFieldsStepsRequiredLabel;
extern NSString * const kLCQRequiredExtraFieldsStringLabel;
extern NSString * const kLCQAddExtraScreenshotStringName;
extern NSString * const kLCQAccessibilityReproStepsDisclaimerStringLabel;
extern NSString * const kLCQAccessibilityImageAttachmentStringHint;
extern NSString * const kLCQAccessibilityVideoAttachmentStringHint;
extern NSString * const kLCQTakeScreenshotAccessibilityStringLabel;
extern NSString * const kLCQTakeScreenRecordingAccessibilityStringLabel;
extern NSString * const kLCQSelectImageFromGalleryLabel;
extern NSString * const kLCQAddAttachmentAccessibilityStringLabel;
extern NSString * const kLCQAddAttachmentAccessibilityStringHint;
extern NSString * const kLCQExpandAttachmentAccessibilityStringLabel;
extern NSString * const kLCQCollapseAttachmentAccessibilityStringLabel;
extern NSString * const kLCQAudioRecordingPermissionDeniedTitleStringName;
extern NSString * const kLCQAudioRecordingPermissionDeniedMessageStringName;
extern NSString * const kLCQScreenRecordingPermissionDeniedMessageStringName;
extern NSString * const kLCQMicrophonePermissionAlertSettingsButtonTitleStringName;
extern NSString * const kLCQMicrophonePermissionAlertLaterButtonTitleStringName;
extern NSString * const kLCQChatsTitleStringName;
extern NSString * const kLCQTeamStringName;
extern NSString * const kLCQRecordingMessageToHoldTextStringName;
extern NSString * const kLCQRecordingMessageToReleaseTextStringName;
extern NSString * const kLCQMessagesNotificationTitleSingleMessageStringName;
extern NSString * const kLCQMessagesNotificationTitleMultipleMessagesStringName;
extern NSString * const kLCQScreenshotTitleStringName;
extern NSString * const kLCQOkButtonTitleStringName;
extern NSString * const kLCQSendButtonTitleStringName;
extern NSString * const kLCQCancelButtonTitleStringName;
extern NSString * const kLCQThankYouAlertTitleStringName;
extern NSString * const kLCQThankYouAccessibilityConfirmationTitleStringName;
extern NSString * const kLCQThankYouAlertMessageStringName;
extern NSString * const kLCQAudioStringName;
extern NSString * const kLCQScreenRecordingStringName;
extern NSString * const kLCQImageStringName;
extern NSString * const kLCQReachedMaximimNumberOfAttachmentsTitleStringName;
extern NSString * const kLCQReachedMaximimNumberOfAttachmentsMessageStringName;
extern NSString * const kLCQVideoRecordingFailureMessageStringName;
extern NSString * const kLCQSurveyEnterYourAnswerTextPlaceholder;
extern NSString * const kLCQSurveyNoAnswerTitle;
extern NSString * const kLCQSurveyNoAnswerMessage;
extern NSString * const kLCQVideoPressRecordTitle;
extern NSString * const kLCQCollectingDataText;
extern NSString * const kLCQLowDiskStorageTitle;
extern NSString * const kLCQLowDiskStorageMessage;
extern NSString * const kLCQInboundByLineMessage;
extern NSString * const kLCQExtraFieldIsRequiredText;
extern NSString * const kLCQExtraFieldMissingDataText;
extern NSString * const kLCQFeatureRequestsTitle;
extern NSString * const kLCQFeatureDetailsTitle;
extern NSString * const kLCQStringFeatureRequestsRefreshText;
extern NSString * const kLCQFeatureRequestErrorStateTitleLabel;
extern NSString * const kLCQFeatureRequestErrorStateDescriptionLabel;
extern NSString * const kLCQFeatureRequestSortingByRecentlyUpdatedText;
extern NSString * const kLCQFeatureRequestSortingByTopVotesText;
extern NSString * const kLCQStringFeatureRequestAllFeaturesText;
extern NSString * const kLCQAddNewFeatureRequestText;
extern NSString * const kLCQAddNewFeatureRequestToastText;
extern NSString * const kLCQAddNewFeatureRequestErrorToastText;
extern NSString * const kLCQAddNewFeatureRequestLoadingHUDTitle;
extern NSString * const kLCQAddNewFeatureRequestSuccessHUDTitle;
extern NSString * const kLCQAddNewFeatureRequestSuccessHUDMessage;
extern NSString * const kLCQAddNewFeatureRequestTryAgainText;
extern NSString * const kLCQAddNewFeatureRequestCancelPromptTitle;
extern NSString * const kLCQAddNewFeatureRequestCancelPromptYesAction;
extern NSString * const kLCQFeatureRequestInvalidEmailText;
extern NSString * const kLCQFeatureRequestTimelineEmptyText;
extern NSString * const kLCQFeatureRequestTimelineErrorDescriptionLabel;
extern NSString * const kLCQFeatureRequestStatusChangeText;
extern NSString * const kLCQFeatureRequestAddButtonText;
extern NSString * const kLCQFeatureRequestVoteWithCountText;
extern NSString * const kLCQFeatureRequestVoteText;
extern NSString * const kLCQFeatureRequestPostButtonText;
extern NSString * const kLCQFeatureRequestCommentsText;
extern NSString * const kLCQFeatureRequestAuthorText;
extern NSString * const kLCQFeatureRequestEmptyViewTitle;
extern NSString * const kLCQFeatureRequestAddYourIdeaText;
extern NSString * const kLCQFeatureRequestAnonymousText;
extern NSString * const kLCQFeatureRequestStatusPosted;
extern NSString * const kLCQFeatureRequestStatusPlanned;
extern NSString * const kLCQFeatureRequestStatusStarted;
extern NSString * const kLCQFeatureRequestStatusCompleted;
extern NSString * const kLCQFeatureRequestStatusMaybeLater;
extern NSString * const kLCQFeatureRequestStatusMoreText;
extern NSString * const kLCQFeatureRequestStatusLessText;
extern NSString * const kLCQFeatureRequestAddYourThoughtsText;
extern NSString * const kLCQEmailRequiredText;
extern NSString * const kLCQNameText;
extern NSString * const kLCQEmailText;
extern NSString * const kLCQTitleText;
extern NSString * const kLCQDescriptionText;
extern NSString * const kLCQUserConsentRequired;
extern NSString * const kLCQUserConsentDefaultDescription;
extern NSString * const kLCQStringFeatureRequestMyFeaturesText;
extern NSString * const kLCQSurveyIntroTitleText;
extern NSString * const kLCQSurveyIntroDescriptionText;
extern NSString * const kLCQSurveyIntroTakeSurveyButtonText;
extern NSString * const kLCQDismissButtonTitleStringName;
extern NSString * const kLCQStoreRatingThankYouTitleText;
extern NSString * const kLCQStoreRatingThankYouDescriptionText;
extern NSString * const kLCQSurveysNPSLeastLikelyStringName;
extern NSString * const kLCQSurveysNPSMostLikelyStringName;
extern NSString * const kLCQSurveyNextButtonTitle;
extern NSString * const kLCQSurveySubmitButtonTitle;
extern NSString * const kLCQSurveyAppStoreThankYouTitle;
extern NSString * const kLCQSurveyAppStoreButtonTitle;
extern NSString * const kLCQExpectedResultsStringName;
extern NSString * const kLCQActualResultsStringName;
extern NSString * const kLCQStepsToReproduceStringName;
extern NSString * const kLCQReplyButtonTitleStringName;
extern NSString * const kLCQAddAttachmentButtonTitleStringName;
extern NSString * const kLCQDiscardAlertTitle;
extern NSString * const kLCQDiscardAlertMessage;
extern NSString * const kLCQDiscardAlertAction;
extern NSString * const kLCQDiscardAlertCancel;
extern NSString * const kLCQVideoGalleryErrorMessageStringName;
extern NSString * const kLCQVideoDurationErrorTitle;
extern NSString * const kLCQVideoDurationErrorMessage;
extern NSString * const kLCQAutoScreenRecordingAlertAllowText;
extern NSString * const kLCQAutoScreenRecordingAlertAlwaysAllowText;
extern NSString * const kLCQAutoScreenRecordingAlertDenyText;
extern NSString * const kLCQAutoScreenRecordingAlertTitleText;
extern NSString * const kLCQAutoScreenRecordingAlertBodyText;
extern NSString * const kLCQReproStepsDisclaimerBody;
extern NSString * const kLCQReproStepsDisclaimerLink;
extern NSString * const kLCQReproStepsListHeader;
extern NSString * const kLCQReproStepsListEmptyStateLabel;
extern NSString * const kLCQReproStepsListTitle;
extern NSString * const kLCQReproStepsListItemName;
extern NSString * const kLCQInsufficientContentTitleStringName;
extern NSString * const kLCQInsufficientContentMessageStringName;

/// -----------
/// @name Enums
/// -----------

/**
 The event used to invoke the feedback form.
 */
typedef NS_OPTIONS(NSInteger, LCQInvocationEvent) {
    /** Shaking the device while in any screen to show the feedback form. */
    LCQInvocationEventShake = 1 << 0,
    /** Taking a screenshot using the Home+Lock buttons while in any screen to show the feedback form. */
    LCQInvocationEventScreenshot = 1 << 1,
    /** Swiping two fingers left while in any screen to show the feedback form. */
    LCQInvocationEventTwoFingersSwipeLeft = 1 << 2,
    /** Swiping one finger left from the right edge of the screen to show the feedback form, substituted with LCQInvocationEventTwoFingersSwipeLeft on iOS 6.1.3 and earlier. */
    LCQInvocationEventRightEdgePan = 1 << 3,
    /**  Shows a floating button on top of all views, when pressed it takes a screenshot. */
    LCQInvocationEventFloatingButton = 1 << 4,
    /** No event will be registered to show the feedback form, you'll need to code your own and call the method showFeedbackForm. */
    LCQInvocationEventNone = 1 << 5,
} NS_SWIFT_NAME(InvocationEvent);

/**
 The UI views that should be masked automatically
 */
typedef NS_OPTIONS(NSInteger, LCQAutoMaskScreenshotOption) {
    LCQAutoMaskScreenshotOptionMaskNothing = 1 << 0,
    LCQAutoMaskScreenshotOptionTextInputs = 1 << 1,
    LCQAutoMaskScreenshotOptionLabels = 1 << 2,
    LCQAutoMaskScreenshotOptionMedia = 1 << 3,
} NS_SWIFT_NAME(AutoMaskScreenshotOption);

/**
 The color theme of the different UI elements.
 */
typedef NS_ENUM(NSInteger, LCQColorTheme) {
    LCQColorThemeLight,
    LCQColorThemeDark
} NS_SWIFT_NAME(ColorTheme);

/**
 The mode used upon invoking the SDK.
 */
typedef NS_ENUM(NSInteger, LCQInvocationMode) {
    LCQInvocationModeNA,
    LCQInvocationModeNewBug,
    LCQInvocationModeNewFeedback,
    LCQInvocationModeNewQuestion,
    LCQInvocationModeNewChat,
    LCQInvocationModeChatsList,
    LCQInvocationModeNewQuestionManually // Only when you call Chats.show()
} NS_SWIFT_NAME(InvocationMode);

/**
 Type of report to be submitted.
 */
typedef NS_OPTIONS(NSInteger, LCQBugReportingReportType) {
    LCQBugReportingReportTypeBug = 1 << 0,
    LCQBugReportingReportTypeFeedback = 1 << 1,
    LCQBugReportingReportTypeQuestion = 1 << 2,
} NS_SWIFT_NAME(BugReportingReportType);

typedef NS_OPTIONS(NSInteger, LCQBugReportingType) {
    LCQBugReportingTypeBug = 1 << 0,
    LCQBugReportingTypeFeedback = 1 << 1,
    LCQBugReportingTypeQuestion = 1 << 2,
    LCQBugReportingTypeFrustratingExperience = 1 << 3
} NS_SWIFT_NAME(BugReportingReportCategory);

typedef NS_OPTIONS(NSInteger, LCQBugReportingOption) {
    LCQBugReportingOptionEmailFieldHidden = 1 << 0,
    LCQBugReportingOptionEmailFieldOptional = 1 << 1,
    LCQBugReportingOptionCommentFieldRequired = 1 << 2,
    LCQBugReportingOptionDisablePostSendingDialog = 1 << 3,
    LCQBugReportingOptionNone = 1 << 4,
} NS_SWIFT_NAME(BugReportingOption);

typedef NS_ENUM(NSInteger, LCQReportCategory) {
    LCQReportCategoryBug = 1 << 0,
    LCQReportCategoryFeedback = 1 << 1,
    LCQReportCategoryQuestion = 1 << 2,
    LCQReportCategoryOther = 1 << 3,
    LCQReportCategoryFrustratingExperience = 1 << 4
} NS_SWIFT_NAME(ReportCategory);

/**
 Type of consent to be added to a bug report.
 */

typedef NS_ENUM(NSInteger, LCQConsentAction) {
    LCQConsentActionDropAutoCapturedMedia = 1 << 0,
    LCQConsentActionDropLogs = 1 << 1,
    LCQConsentActionNoChat = 1 << 2,
} NS_SWIFT_NAME(ConsentAction);

/**
 Type of SDK dismiss.
 */
typedef NS_ENUM(NSInteger, LCQDismissType) {
    /** Dismissed after report submit */
    LCQDismissTypeSubmit,
    /** Dismissed via cancel */
    LCQDismissTypeCancel,
    /** Dismissed while taking screenshot */
    LCQDismissTypeAddAttachment
} NS_SWIFT_NAME(SDKDismissType);

/**
 Supported locales.
 */
typedef NS_ENUM(NSInteger, LCQLocale) {
    LCQLocaleArabic,
    LCQLocaleAzerbaijani,
    LCQLocaleChineseSimplified,
    LCQLocaleChineseTaiwan,
    LCQLocaleChineseTraditional,
    LCQLocaleCzech,
    LCQLocaleDanish,
    LCQLocaleDutch,
    LCQLocaleEnglish,
    LCQLocaleFrench,
    LCQLocaleGerman,
    LCQLocaleItalian,
    LCQLocaleJapanese,
    LCQLocaleKorean,
    LCQLocaleNorwegian,
    LCQLocalePolish,
    LCQLocalePortuguese,
    LCQLocalePortugueseBrazil,
    LCQLocaleRussian,
    LCQLocaleSlovak,
    LCQLocaleSpanish,
    LCQLocaleSwedish,
    LCQLocaleTurkish,
    LCQLocaleHungarian,
    LCQLocaleFinnish,
    LCQLocaleCatalan,
    LCQLocaleCatalanSpain,
    LCQLocaleRomanian
} NS_SWIFT_NAME(SDKLocale);

/**
 The prompt option selected in Luciq prompt.
 */
typedef NS_OPTIONS(NSInteger, LCQPromptOption) {
    LCQPromptOptionChat = 1 << 0,
    LCQPromptOptionBug = 1 << 1,
    LCQPromptOptionFeedback = 1 << 2,
    LCQPromptOptionNone = 1 << 3,
} NS_SWIFT_NAME(PromptOption);

/**
 Luciq floating buttons positions.
 */
typedef NS_ENUM(NSInteger, LCQPosition) {
    LCQPositionBottomRight,
    LCQPositionTopRight,
    LCQPositionBottomLeft,
    LCQPositionTopLeft
} NS_SWIFT_NAME(SDKPosition);

/**
 The Conosle Log Level.
 */
typedef NS_ENUM(NSInteger, LCQLogLevel) {
    LCQLogLevelNone = 0,
    LCQLogLevelError,
    LCQLogLevelWarning,
    LCQLogLevelInfo,
    LCQLogLevelDebug,
    LCQLogLevelVerbose,
} NS_SWIFT_NAME(SDKLogLevel);

/**
 Verbosity level of the SDK debug logs. This has nothing to do with LCQLog, and only affect the logs used to debug the
 SDK itself.
 
 Defaults to LCQSDKDebugLogsLevelError. Make sure you only use LCQSDKDebugLogsLevelError or LCQSDKDebugLogsLevelNone in
 production builds.
 */
typedef NS_ENUM(NSInteger, LCQSDKDebugLogsLevel) {
    LCQSDKDebugLogsLevelVerbose = 1,
    LCQSDKDebugLogsLevelDebug = 2,
    LCQSDKDebugLogsLevelError = 3,
    LCQSDKDebugLogsLevelNone = 4
} NS_SWIFT_NAME(SDKDebugLogsLevel);

/**
 The user steps option.
 */
typedef NS_ENUM(NSInteger, LCQUserStepsMode) {
    LCQUserStepsModeEnable,
    LCQUserStepsModeEnabledWithNoScreenshots,
    LCQUserStepsModeDisable
} NS_SWIFT_NAME(UserStepsMode);

 /**
    The attachment types selected in Attachment action sheet.
 */
typedef NS_OPTIONS(NSInteger, LCQAttachmentType) {
    LCQAttachmentTypeScreenShot = 1 << 1,
    LCQAttachmentTypeExtraScreenShot = 1 << 2,
    LCQAttachmentTypeGalleryImage = 1 << 4,
    LCQAttachmentTypeScreenRecording = 1 << 6,
} NS_SWIFT_NAME(ReportAttachmentType);

/**
 The extended bug report mode.
 */
typedef NS_ENUM(NSInteger, LCQExtendedBugReportMode) {
    LCQExtendedBugReportModeEnabledWithRequiredFields,
    LCQExtendedBugReportModeEnabledWithOptionalFields,
    LCQExtendedBugReportModeDisabled
} NS_SWIFT_NAME(ExtendedBugReportMode);

typedef NS_OPTIONS(NSInteger, LCQAction) {
    LCQActionAllActions = 1 << 0,
    LCQActionReportBug = 1 << 1,
    LCQActionRequestNewFeature = 1 << 2,
    LCQActionAddCommentToFeature = 1 << 3,
} NS_SWIFT_NAME(SDKAction);

/**
 The welcome message mode.
 */
typedef NS_ENUM(NSInteger, LCQWelcomeMessageMode) {
    LCQWelcomeMessageModeLive,
    LCQWelcomeMessageModeBeta,
    LCQWelcomeMessageModeDisabled
} NS_SWIFT_NAME(WelcomeMessageMode);

/* CHECK NULLABILITY! */
typedef void (^NetworkObfuscationCompletionBlock)(NSData *data, NSURLResponse *response);

/* Platform */
typedef NS_ENUM(NSInteger, LCQPlatform) {
    LCQPlatformIOS,
    LCQPlatformReactNative,
    LCQPlatformCordova,
    LCQPlatformXamarin,
    LCQPlatformUnity,
    LCQPlatformFlutter
} NS_SWIFT_NAME(SDKPlatform);

/**
User's touch event types
*/
typedef NS_ENUM(NSInteger, LCQUIEventType) {
    LCQUIEventTypeTap,
    LCQUIEventTypeDoubleTap,
    LCQUIEventTypeForceTouch,
    LCQUIEventTypeLongPress,
    LCQUIEventTypePinch,
    LCQUIEventTypeSwipe,
    LCQUIEventTypeScroll
} NS_SWIFT_NAME(UserInteractionEventType);

typedef NS_ENUM(NSInteger, LCQInteractionViewType) {
    LCQInteractionViewTypeText,
    LCQInteractionViewTypeImage,
    LCQInteractionViewTypeButton,
    LCQInteractionViewTypeToggle,
    LCQInteractionViewTypeTextField,
    LCQInteractionViewTypeSecureField,
    LCQInteractionViewTypePicker,
    LCQInteractionViewTypeSlider,
    LCQInteractionViewTypeStepper,
    LCQInteractionViewTypeList,
    LCQInteractionViewTypeScrollView,
    LCQInteractionViewTypeVStack,
    LCQInteractionViewTypeHStack,
    LCQInteractionViewTypeZStack,
    LCQInteractionViewTypeTabView,
    LCQInteractionViewTypeSheet,
    LCQInteractionViewTypeAlert
} NS_SWIFT_NAME(InteractionViewType);

/**
 Report issue type
 */
typedef NS_ENUM(NSInteger, LCQIssueType) {
    LCQIssueTypeBug,
    LCQIssueTypeCrash __attribute__((unavailable("This type has been removed. Please use LCQIssueTypeAllCrashes instead."))),
    LCQIssueTypeSessionReplay,
    LCQIssueTypeAll,
    LCQIssueTypeAllCrashes,
    LCQIssueTypeNonFatal,
    LCQIssueTypeFatal,
    LCQIssueTypeAppHang,
    LCQIssueTypeForceRestart,
    LCQIssueTypeOutOfMemory
} NS_SWIFT_NAME(ReportableIssueType);

typedef NS_ENUM(NSInteger, LCQCrashType) {
    LCQCrashTypeCrash,
    LCQCrashTypeForceRestart,
    LCQCrashTypeOOM
} NS_SWIFT_NAME(CrashType);

typedef NS_ENUM(NSInteger, LCQCrashReportConsent) {
    LCQCrashReportConsentAccept,
    LCQCrashReportConsentReject
} NS_SWIFT_NAME(CrashReportConsent);

typedef NS_ENUM(NSInteger, LCQOverAirType) {
    LCQOverAirTypeCodePush,
    LCQOverAirTypeExpo
} NS_SWIFT_NAME(OverAirType);

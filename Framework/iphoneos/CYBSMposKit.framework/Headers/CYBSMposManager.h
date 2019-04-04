//
//  CYBSMposManager.h
//  CYBSMposKit
//
//  Created by CyberSource on 5/22/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//
#import "CYBSMposPaymentRequest.h"
#import "CYBSMposPaymentResponse.h"
#import "CYBSMposReceiptRequest.h"
#import "CYBSMposSettings.h"
#import "CYBSMposTransactionSearchQuery.h"
#import "CYBSMposTransactionSearchResult.h"
#import "CYBSMposTransaction.h"
#import "CYBSMposRefundRequest.h"
#import "CYBSMposVoidRequest.h"
#import "CYBSMposUISettings.h"
#import "CYBSMposError.h"
#import "CYBSMposCaptureRequest.h"
#import "CYBSMposBluetoothDevice.h"
#import "CYBSMposItem.h"
#import "CYBSEMVTag.h"
#import "CYBSMerchantDescriptor.h"
#import "CYBSMposAddress.h"
#import "CYBSMposCardDataManual.h"
#import "CYBSMposPurchaseDetails.h"
#import "CYBSMposAuthorizationReversalRequest.h"


@protocol CYBSMposManagerDelegate;

typedef NS_ENUM(NSInteger, CYBSMposOTAResultCode) {
    CYBSMposOTASuccess,
    CYBSMposOTASetupError,
    CYBSMposOTABatteryLowError,
    CYBSMposOTADeviceCommError,
    CYBSMposOTAServerCommError,
    CYBSMposOTAFailed,
    CYBSMposOTAStopped,
    CYBSMposOTANoUpdateRequired,
    CYBSMposOTANoInvalidControllerState,
    CYBSMposOTAIncompatibleFirmwareHex,
    CYBSMposOTAIncompatibleConfigHex
};

typedef NS_ENUM(NSInteger, CYBSMposDeviceErrorCode) {
    CYBSMposDeviceNoError,
    CYBSMposDeviceErrorInvalidControllerState,
    CYBSMposDeviceErrorConfigHex,
    CYBSMposDeviceErrorInvalidInputs,
    CYBSMposDeviceErrorCommError,
    CYBSMposDeviceErrorUnknown,
    CYBSMposDeviceErrorAudioFailToStart,
    CYBSMposDeviceErrorCommandNotAvailable,
    CYBSMposDeviceErrorAudioRecordingPermissionDenied,
    CYBSMposDeviceErrorAudioBackgroundTimeout,
    CYBSMposDeviceErrorAudioFailToStartOtherAudioIsPlaying,
    CYBSMposDeviceErrorDeviceBusy,
    CYBSMposDeviceErrorCommLinkUninitialized,
    CYBSMposDeviceErrorBTv4NotSupported,
    CYBSMposDeviceErrorFailedToStart,
    CYBSMposDeviceErrorIllegalException,
    CYBSMposDeviceErrorBTSettingsOff,
    CYBSMposDeviceErrorAlreadyConnected,
    CYBSMposDeviceErrorHardwareNotSupported,
    CYBSMposDeviceErrorPCI
};

typedef NS_ENUM (NSInteger, CYBSMposOTAOperation) {
    CYBSMposOTAOperationNone,
    CYBSMposOTAOperationCheckForUpdate,
    CYBSMposOTAOperationFirmwareUpdate,
    CYBSMposOTAOperationConfigUpdate,
    CYBSMposOTAOperationConfigAndFirmwareUpdate
};

/**
 The completion handler, it will be invoked with device info
 */
typedef void (^OTACheckUpdateRequiredBlock)(BOOL iFirmwareUpdateRequired, BOOL iConfigurationUpdateRequired, CYBSMposDeviceErrorCode iErrorCode, NSString * _Nullable iErrorString, CYBSMposOTAResultCode iStatusCode, NSString * _Nullable iStatusMessage);

/**
 The completion handler, it will be invoked with device info
 */
typedef void (^OTACheckUpdateCompletedBlock)(BOOL iUpdateSuccessful, CYBSMposDeviceErrorCode iErrorCode, NSString * _Nullable iErrorString, CYBSMposOTAResultCode iOTAStatusCode, NSString * _Nullable iStatusMessage);

/**
 The completion handler, it will be invoked with device info
 */
typedef void (^OTAUpdateProgressBlock)(float iPercentage, CYBSMposOTAOperation iUpdateType);

/**
 A CYBSMposManager object let you perform MPOS operations. It is the central point of CyberSource MPOS SDK.
 */
@interface CYBSMposManager : NSObject

/**
 @brief The CyberSource MPOS SDK settings.
 @see CYBSMposSettings
 */
@property (nonatomic, copy, nonnull) CYBSMposSettings *settings;
/**
 @brief The CyberSource MPOS SDK UI settings.
 @see CYBSMposUISettings
 */
@property (nonatomic, copy, nonnull) CYBSMposUISettings *uiSettings;
/**
 @brief The CyberSource MPOS SDK Merchant Descriptor settings.
 @see CYBSMerchantDescriptor
 */
@property (nonatomic, copy, nonnull) CYBSMerchantDescriptor *merchantDescriporSettings;
/**
 @brief The CYBSMposManager delegate object.
 @see CYBSMposManagerDelegate
 */
@property (nonatomic, weak, nullable) id<CYBSMposManagerDelegate> delegate;

+ (CYBSMposManager *_Nonnull)sharedInstance;

- (void)updateSettings;

- (void)updateMerchantDescriptorSettings:(CYBSMerchantDescriptor *_Nonnull)merchantDescriptor;

- (void)activateDeviceWithClientId:(nonnull NSString *)paramClientId
                       withUserName:(nonnull NSString *)paramUserName
                       withPassword:(nonnull NSString *)paramPassword
                     withMerchantId:(nonnull NSString *)paramMerchantId
                       withDeviceId:(nonnull NSString *)paramDeviceId
                    withDescription:(nullable NSString *)paramDescription
                 withDevicePlatform:(nullable NSString *)paramDevicePlatform
                     withSDKVersion:(nullable NSString *)paramSDKVersion
                     withAppVersion:(nullable NSString *)paramApplicationVersion
                    withPhoneNumber:(nullable NSString *)paramPhoneNumber
                       withDelegate:(nullable id<CYBSMposManagerDelegate>)paramDelegate;

- (void)activateDeviceWithClientId:(nonnull NSString *)paramClientId
                    withMerchantId:(nonnull NSString *)paramMerchantId
                      withDeviceId:(nonnull NSString *)paramDeviceId
                  withClientSecret:(nonnull NSString *)paramClientSecret
                   withDescription:(nullable NSString *)paramDescription
                withDevicePlatform:(nullable NSString *)paramDevicePlatform
                    withSDKVersion:(nullable NSString *)paramSDKVersion
                    withAppVersion:(nullable NSString *)paramApplicationVersion
                   withPhoneNumber:(nullable NSString *)paramPhoneNumber
                      withDelegate:(nullable id<CYBSMposManagerDelegate>)paramDelegate;

/**
 @brief Performs payment capture

 @param request the payment request
 @param parentViewController the Application view controller
 @param delegate the delegate object
 @see CYBSMposPaymentRequest
 @see CYBSMposManagerDelegate
 */
- (void)performPayment:(nonnull CYBSMposPaymentRequest *)request
  parentViewController:(nonnull UIViewController *)parentViewController
              delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Performs refund

 @param request the refund request
 @param delegate the delegate object
 @see CYBSMposRefundRequest
 @see CYBSMposManagerDelegate
 */
- (void)performRefund:(nonnull CYBSMposRefundRequest *)request
             delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Performs void

 @param request the void request
 @param delegate the delegate object
 @see CYBSMposVoidRequest
 @see CYBSMposManagerDelegate
 */
- (void)performVoid:(nonnull CYBSMposVoidRequest *)request
           delegate:(nullable id<CYBSMposManagerDelegate>)delegate;


/**
 @brief Performs Capture
 
 @param request the void request
 @param delegate the delegate object
 @see CYBSMposCaptureRequest
 @see CYBSMposManagerDelegate
 */
- (void)performCapture:(nonnull CYBSMposCaptureRequest *)request
           delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Performs Authorization Reversal
 
 @param request the void request
 @param delegate the delegate object
 @see CYBSMposCaptureRequest
 @see CYBSMposManagerDelegate
 */
- (void)performAuthorizationReversal:(nonnull CYBSMposAuthorizationReversalRequest *)request
                            delegate:(nullable id<CYBSMposManagerDelegate>)delegate;


/**
 @brief Performs transaction search

 @param query the TransactionSearchQuery object
 @param accessToken the oAuth access token
 @param delegate the delegate object
 @see CYBSMposTransactionSearchQuery
 @see CYBSMposManagerDelegate
 */
- (void)performTransactionSearch:(nonnull CYBSMposTransactionSearchQuery *)query
                     accessToken:(nonnull NSString *)accessToken
                        delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Retrieves next transaction search result

 @param currentResult the current CYBSMposTransactionSearchResult object
 @param accessToken the oAuth access token
 @param delegate the delegate object
 @see CYBSMposTransactionSearchResult
 @see CYBSMposManagerDelegate
 */
- (void)nextTransactionSearchResult:(nonnull CYBSMposTransactionSearchResult *)currentResult
                        accessToken:(nonnull NSString *)accessToken
                           delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Retrieves transaction detail

 @param transactionID the transaction ID
 @param accessToken the oAuth access token
 @param delegate the delegate object
 @see CYBSMposManagerDelegate
 */
- (void)getTransactionDetail:(nonnull NSString *)transactionID
                 accessToken:(nonnull NSString *)accessToken
                    delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

- (void)getTransactionSignature:(nonnull NSString *)transactionID
                    accessToken:(nonnull NSString *)accessToken
                       delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Sends transaction receipt

 @param request the receipt request
 @param delegate the delegate object
 @see CYBSMposReceiptRequest
 @see CYBSMposManagerDelegate
 */
- (void)sendReceipt:(nonnull CYBSMposReceiptRequest *)request
           delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Prints transaction receipt
 
 @param request transaction request
 @param response transaction response
 @param delegate the delegate object
 @see CYBSMposReceiptRequest
 @see CYBSMposManagerDelegate
 */
- (void)printReceipt:(nonnull CYBSMposPaymentRequest *)request
            response:(nonnull CYBSMposPaymentResponse *)response
            delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Prints transaction receipt
 
 @param recptImage receipt format to print
 @param delegate the delegate object
 @see CYBSMposReceiptRequest
 @see CYBSMposManagerDelegate
 */
- (void)printReceiptImage:(nonnull UIImage *)recptImage
                 delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Device info, wait result dictionary in callback method.
 onReturnDeviceInfo
 */
- (void)getDeviceInfo:(nullable id<CYBSMposManagerDelegate>)delegate;
// Bluetooth card reader related
- (void)scanBTDevices:(nullable id<CYBSMposManagerDelegate>)delegate;

- (void)connectBTDevice:(nonnull NSObject *)deviceObj;

- (void)connectBTDeviceWithName:(nonnull NSString *)deviceName;

- (void)disconenctBTDevice:(nullable id<CYBSMposManagerDelegate>)delegate;

// Audio/Microphone card reader related
- (void)startAudio:(nullable id<CYBSMposManagerDelegate>)delegate;

- (void)stopAudio:(nullable id<CYBSMposManagerDelegate>)delegate;

- (BOOL)isAudioDevicePlugged;

/**
 * Start OTA Update
 * @param isTestReader if this is true then SDK will treat the reader as test reader and will try to update from TMS demo site else it will connect the TMS live version site
 please make sure that the reader is registered at tms website
 https://tms-demo.bbpos.com/login
 https://tms.bbpos.com/login
 * @param iUpdateCheckBlock This block will be executed once SDK finds the status of the update, application will be notified if any of the following is outdated
 i)  Reader Device Firmware
 ii) Reader Device Configuration
 */
- (void)checkForOTAUpdateIsTestReader:(BOOL)isTestReader
                  withOTAUpdateStatus:(OTACheckUpdateRequiredBlock _Nonnull)iUpdateCheckBlock;

/**
 * Start OTA Update
 * @param isTestReader if this is true then SDK will treat the reader as test reader and will try to update from TMS demo site else it will connect the TMS live version site
 please make sure that the reader is registered at tms website
 https://tms-demo.bbpos.com/login
 https://tms.bbpos.com/login
 * @param iOTAProgressBlock This block will be exceuted on change in progress of update, Application will be notified about the progress of the update
 * @param iUpdateCompleteBlock This block will be executed on completion of update, Application will be notified about the update in case of success or failure
 */
- (void)startOTAUpdateIsTestReader:(BOOL)isTestReader
                      withProgress:(OTAUpdateProgressBlock _Nonnull)iOTAProgressBlock
             andOTACompletionBlock:(OTACheckUpdateCompletedBlock _Nonnull)iUpdateCompleteBlock;


- (void)startConfigurationUpdateIsTestReader:(BOOL)isTestReader
                                withProgress:(OTAUpdateProgressBlock _Nonnull)iOTAProgressBlock
                       andOTACompletionBlock:(OTACheckUpdateCompletedBlock _Nonnull)iUpdateCompleteBlock;

- (void)startFirmwareUpdateIsTestReader:(BOOL)isTestReader
                           withProgress:(OTAUpdateProgressBlock _Nonnull)iOTAProgressBlock
                  andOTACompletionBlock:(OTACheckUpdateCompletedBlock _Nonnull)iUpdateCompleteBlock;

+ (void)resetCYBSMposManager;

- (NSString *_Nullable)getTerminalDeviceType;

/**
 * Stop OTA Update, Application can only stop the update in case application called
 "- (void)startOTAUpdateIsTestReader:(BOOL)isTestReader withProgress:(OTAUpdateProgressBlock _Nonnull)iOTAProgress andOTACompletionBlock:(OTACheckUpdateCompletedBlock _Nonnull)iUpdateCompleteBlock"
 to update
 */
- (void)stopOTAUpdate;

@end


@protocol CYBSMposManagerDelegate <NSObject>

@optional
// Card Reader related
- (void)onReturnDeviceInfo:(NSDictionary *_Nullable)deviceInfo;

// Error
- (void)onReturnDeviceError:(CYBSMposDeviceErrorCode)iErrorCode errorMessage:(NSString * _Nullable)iErrorMessage;

// Bluetooth Card Reader related
- (void)onBTReturnScanResults:(nullable NSArray<CYBSMposBluetoothDevice*> *)devices;
- (void)onBTScanTimeout;
- (void)onBTConnectTimeout;
- (void)onBTConnected;
- (void)onBTDisconnected;
- (void)onRequestEnableBluetoothInSettings;

// Microphone/Audiojack Card Reader related
- (void) onAudioDevicePlugged;
- (void) onAudioDeviceUnplugged;
- (void) onAudioInterrupted;
- (void) onNoAudioDeviceDetected;

// Transaction related
- (void)performPaymentDidFinish:(nullable CYBSMposPaymentResponse *)result
                          error:(nullable NSError *)error;

- (void)performTransactionSearchDidFinish:(nullable CYBSMposTransactionSearchResult *)result
                                    error:(nullable NSError *)error;

- (void)getTransactionDetailDidFinish:(nullable CYBSMposTransaction *)transaction
                                error:(nullable NSError *)error;

- (void)getTransactionSignatureDidFinish:(nullable NSData *)signature
                                   error:(nullable NSError *)error;

- (void)performVoidDidFinish:(nullable CYBSMposPaymentResponse *)result
                       error:(nullable NSError *)error;

- (void)performRefundDidFinish:(nullable CYBSMposPaymentResponse *)result
                         error:(nullable NSError *)error;

- (void)performCaptureDidFinish:(nullable CYBSMposPaymentResponse *)result
                          error:(nullable NSError *)error;

- (void)performAuthorizationReversalDidFinish:(nullable CYBSMposPaymentResponse *)result
                                        error:(nullable NSError *)error;

- (void)sendReceiptDidFinish:(nullable NSDictionary *)result
                       error:(nullable NSError *)error;

// Print Receipt related

- (void)onReturnReceiptPrintResult:(BOOL)result;

- (void)onReceiptPrintDataEnd;

- (void)onReceiptPrintDataCancelled;

- (void)onDeviceRegister:(NSError *_Nonnull)responseData;

@end

//
//  CYBSMposSettings.h
//  CYBSMposKit
//
//  Created by CyberSource on 5/22/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsLiveSimpleOrderAPIURL;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsLiveTransactionSearchAPIURL;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsLiveTransactionDetailAPIURL;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsLiveReceiptAPIURL;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsLiveSubstituteReceiptAPIURL;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsLiveDeviceRegistrationAPIURL;

FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsTestSimpleOrderAPIURL;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsTestTransactionSearchAPIURL;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsTestTransactionDetailAPIURL;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsTestReceiptAPIURL;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsTestSubstituteReceiptAPIURL;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsTestDeviceRegistrationAPIURL;

FOUNDATION_EXPORT NSString * __nonnull const CYBSMposSettingsDefaultSimpleOrderAPIVersion;

typedef NS_ENUM(NSUInteger, CYBSMposEnvironment) {
  /** CyberSource Live environment */
  CYBSMposEnvironmentLive,
  /** CyberSource Test environment */
  CYBSMposEnvironmentTest
};

@interface CYBSMposSettings : NSObject <NSCopying>

@property (nonatomic, assign) CYBSMposEnvironment environment;
@property (nonatomic, copy, nonnull) NSString *deviceID;
@property (nonatomic, copy, nullable) NSString *terminalID;
@property (nonatomic, copy, nullable) NSString *terminalIDAlternate;
@property (nonatomic, copy, nullable) NSString *mid;
@property (nonatomic, copy, nonnull) NSString *simpleOrderAPIVersion;

- (nonnull instancetype)initWithEnvironment:(CYBSMposEnvironment)environment deviceID:(nonnull NSString *)deviceID;
- (nonnull NSDictionary *)dictionary;
+ (nonnull NSString *)stringWithEnvironment:(CYBSMposEnvironment)environment;

@end

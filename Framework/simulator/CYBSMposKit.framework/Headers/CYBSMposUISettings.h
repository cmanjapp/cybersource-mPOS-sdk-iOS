//
//  CYBSMposUISettings.h
//  CYBSMposKit
//
//  Created by CyberSource on 9/22/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorBackground;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorTint;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorSpinner;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontButton;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposImageTop;

FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorKeyEntryAmountLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorKeyEntryInfoLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorKeyEntryTextLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorKeyEntryTextField;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorKeyEntryTextFieldPlaceholder;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontKeyEntryAmountLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontKeyEntryInfoLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontKeyEntryTextLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontKeyEntryTextField;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontKeyEntryTextFieldPlaceholder;

FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorCardReaderAmountLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorCardReaderInfoLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontCardReaderAmountLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontCardReaderInfoLabel;

FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorSignatureAmountLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorSignatureInfoLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorSignatureForeground;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorSignatureBackground;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontSignatureAmountLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontSignatureInfoLabel;

FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorConfirmationTitleLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorConfirmationAmountLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorConfirmationInfoLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorConfirmationTextLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposColorConfirmationDetailTextLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontConfirmationTitleLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontConfirmationAmountLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontConfirmationInfoLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontConfirmationTextLabel;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposFontConfirmationDetailTextLabel;

@interface CYBSMposUISettings : NSObject <NSCopying>

- (nullable UIColor *)color:(nonnull NSString *)uiSettingID;
- (nullable UIFont *)font:(nonnull NSString *)uiSettingID;
- (nullable UIImage *)image:(nonnull NSString *)uiSettingID;

@property (nonatomic, assign) BOOL skipSignature;
@property (nonatomic, assign) BOOL showReceiptView;
@property (nonatomic, strong, nullable) UIImage *topImage;
@property (nonatomic, strong, nullable) UIColor *backgroundColor;
@property (nonatomic, strong, nullable) UIColor *tintColor;
@property (nonatomic, strong, nullable) UIColor *spinnerColor;
@property (nonatomic, strong, nullable) UIColor *textLabelColor;
@property (nonatomic, strong, nullable) UIColor *detailTextLabelColor;
@property (nonatomic, strong, nullable) UIColor *textFieldColor;
@property (nonatomic, strong, nullable) UIColor *textFieldPlaceholderColor;
@property (nonatomic, strong, nullable) UIColor *signatureColor;
@property (nonatomic, strong, nullable) UIColor *signatureBackgroundColor;
@property (nonatomic, strong, nullable) NSString *ultraLightFontName;
@property (nonatomic, strong, nullable) NSString *thinFontName;
@property (nonatomic, strong, nullable) NSString *lightFontName;
@property (nonatomic, strong, nullable) NSString *regularFontName;
@property (nonatomic, strong, nullable) NSString *mediumFontName;
@property (nonatomic, strong, nullable) NSString *semiboldFontName;
@property (nonatomic, strong, nullable) NSString *boldFontName;
@property (nonatomic, strong, nullable) NSString *heavyFontName;
@property (nonatomic, strong, nullable) NSString *blackFontName;

@end

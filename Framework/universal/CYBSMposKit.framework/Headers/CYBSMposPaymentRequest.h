//
//  CYBSMposPaymentRequest.h
//  CYBSMposKit
//
//  Created by CyberSource on 5/22/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//


@class CYBSMposAddress;

typedef NS_ENUM(NSUInteger, CYBSMposPaymentRequestCommerceIndicator) {
    CYBSMposPaymentRequestCommerceIndicatorInternet = 0,
    CYBSMposPaymentRequestCommerceIndicatorRetail,
    CYBSMposPaymentRequestCommerceIndicatorRecurring,
    CYBSMposPaymentRequestCommerceIndicatorMoto
};

typedef NS_ENUM(NSUInteger, CYBSMposPaymentRequestEntryMode) {
    CYBSMposPaymentRequestEntryModeSwipe = 0, // MSR
    CYBSMposPaymentRequestEntryModeSwipeOrInsertOrTap, // EMV
    CYBSMposPaymentRequestEntryModeReaderKeyEntry, // Type on Reader
    CYBSMposPaymentRequestEntryModeAppKeyEntry // Type on App
};

typedef NS_ENUM(NSUInteger, CYBSMposPaymentRequestSupportedServices) {
    CYBSMposPaymentRequestTokenized = 1,
    CYBSMposPaymentRequestEndlessAisle = 2,
    CYBSMposPaymentRequestTokenizedEndlessAisle = 3,
    CYBSMposPaymentRequestRetail = 6,
    CYBSMposPaymentRequestTokenizedRetail = 7
};

typedef NS_ENUM(NSUInteger, CYBSMposPaymentRequestDecryptionServices) {
    CYBSMposPaymentRequestVISAHSM,
    CYBSMposPaymentRequestBluefin,
};

@class CYBSMposPurchaseDetails;
@class CYBSMposCardDataManual;

@interface CYBSMposPaymentRequestPurchaseTotal : NSObject

@property (nonatomic, strong, nonnull) NSString *currency;
@property (nonatomic, strong, nonnull) NSDecimalNumber *amount;

- (nonnull instancetype)initWithCurrency:(nonnull NSString *)currency amount:(nonnull NSDecimalNumber *)amount;
- (nonnull NSDictionary *)dictionary;

@end

@interface CYBSMposPaymentRequest : NSObject

@property (nonatomic, strong, nonnull) NSString *merchantID;
@property (nonatomic, strong, nonnull) NSString *accessToken;
@property (nonatomic, strong, nonnull) NSString *merchantReferenceCode;
@property (nonatomic, strong, nonnull) CYBSMposPaymentRequestPurchaseTotal *purchaseTotal;
@property (nonatomic, assign) CYBSMposPaymentRequestEntryMode entryMode;
@property (nonatomic, assign) CYBSMposPaymentRequestCommerceIndicator commerceIndicator;
@property (nonatomic, assign) CYBSMposPaymentRequestSupportedServices paymentService;
@property (nonatomic, assign) CYBSMposPaymentRequestDecryptionServices decryptionService;
@property (nonatomic, assign) BOOL skipSignature;
@property (nonatomic, assign) BOOL showReceiptView;
@property (nonatomic, assign) BOOL autoPrintReceipt;
@property (nonatomic, assign) BOOL partialIndicator;
@property (copy, nonatomic) NSArray * _Nullable merchantDefinedDataArray;
@property (copy, nonatomic) NSArray * _Nullable items;
@property (nonatomic, copy) NSString *_Nullable merchantTransactionIdentifier;
@property (nonatomic, strong) CYBSMposAddress* _Nullable shippingAddress;
@property (nonatomic, strong) CYBSMposAddress* _Nullable billingAddress;
@property (nonatomic, strong) CYBSMposPurchaseDetails * _Nullable purchaseDetails;
@property (nonatomic, strong) CYBSMposCardDataManual * _Nullable manualEntryCardData;

- (nonnull instancetype)initWithMerchantID:(nonnull NSString *)merchantID
                               accessToken:(nonnull NSString *)accessToken
                                    amount:(nonnull NSDecimalNumber *)amount
                                 entryMode:(CYBSMposPaymentRequestEntryMode)entryMode;

- (nonnull NSString *)getCommerceIndicatorString;

- (nonnull NSDictionary *)dictionary;

@end

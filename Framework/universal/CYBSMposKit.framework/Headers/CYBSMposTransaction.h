//
//  CYBSMposTransaction.h
//  CYBSMposKit
//
//  Created by CyberSource on 7/27/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CYBSMposTransactionType) {
  CYBSMposTransactionTypeUndefined = 0,
  CYBSMposTransactionTypeAuthorization,
  CYBSMposTransactionTypeCapture,
  CYBSMposTransactionTypeSale,
  CYBSMposTransactionTypeRefund,
  CYBSMposTransactionTypeReversal,
  CYBSMposTransactionTypeVoid,
  CYBSMposTransactionTypeMetadata
};

typedef NS_ENUM(NSUInteger, CYBSMposTransactionActionType) {
  CYBSMposTransactionActionTypeNone         = 0,
  CYBSMposTransactionActionTypeCapture      = 1 << 0,
  CYBSMposTransactionActionTypeRefund       = 1 << 1,
  CYBSMposTransactionActionTypeReverse      = 1 << 2,
  CYBSMposTransactionActionTypeVoid         = 1 << 3,
  CYBSMposTransactionActionTypeSendReceipt  = 1 << 4,
  CYBSMposTransactionActionTypePartialRefund = 1 << 5
};

@class CYBSMposTransactionPaymentInfo;

@interface CYBSMposTransaction : NSObject

@property (nonatomic, strong, nonnull) NSString *transactionID;
@property (nonatomic, strong, nonnull) NSDate *transactionDate;
@property (nonatomic, assign) CYBSMposTransactionType transactionType;
@property (nonatomic, assign) BOOL error;
@property (nonatomic, strong, nullable) NSString *currency;
@property (nonatomic, strong, nullable) NSDecimalNumber *amount;
@property (nonatomic, strong, nullable) NSString *merchantReferenceCode;
@property (nonatomic, strong, nullable) NSString *transRefNo;
@property (nonatomic, strong, nullable) NSString *authCode;
@property (nonatomic, assign) NSInteger reasonCode;
@property (nonatomic, strong, nullable) NSString *replyMessage;
@property (nonatomic, strong, nullable) NSString *requestToken;
@property (nonatomic, strong, nullable) NSString *status;
@property (nonatomic, strong, nullable) CYBSMposTransactionPaymentInfo *paymentInfo;
@property (nonatomic, assign) NSUInteger actions;
@property (nonatomic, strong, nullable) NSArray *events;
@property (nonatomic, strong, nullable) NSData *signatureData;

- (nonnull NSDictionary *)dictionary;

@end

@interface CYBSMposTransactionPaymentInfo : NSObject

@property (nonatomic, strong, nullable) NSString *paymentType;
@property (nonatomic, strong, nullable) NSString *fullName;
@property (nonatomic, strong, nullable) NSString *accountSuffix;
@property (nonatomic, strong, nullable) NSString *expirationMonth;
@property (nonatomic, strong, nullable) NSString *expirationYear;
@property (nonatomic, strong, nullable) NSString *cardType;
@property (nonatomic, strong, nullable) NSString *processor;

- (nonnull NSDictionary *)dictionary;

@end

//
//  CYBSMposPaymentResult.h
//  CYBSMposKit
//
//  Created by CyberSource on 5/23/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

/**
  This enumeration represents a type of the request status.
*/
typedef NS_ENUM(NSUInteger, CYBSMposPaymentResultDecision) {
  /// Decision is unknown
  CYBSMposPaymentResultDecisionUnknown = 0,
  /// Request was accepted
  CYBSMposPaymentResultDecisionAccept,
  /// There was a system error
  CYBSMposPaymentResultDecisionError,
  /// Request was declined
  CYBSMposPaymentResultDecisionReject,
  /// Decision Manager flagged the request for review
  CYBSMposPaymentResultDecisionReview,
  /// Request was failed
  CYBSMposPaymentResultDecisionFailed
};

@class CYBSMposPaymentResponseEmvReply;
@class CYBSMposPaymentResponseCard;
@class CYBSMposPaymentResponseAuthReply;
@class CYBSMposPaymentResponseSubscriptionCreateReply;
@class CYBSMposPaymentResponseCaptureReply;
@class CYBSMposPaymentResponseAuthReversalReply;
@class CYBSMposPaymentResponseVoidReply;
@class CYBSMposPaymentResponseRefundReply;
@class CYBSMposPaymentResponseICS_Message;

@interface CYBSMposPaymentResponse : NSObject

@property (nonatomic, strong, nullable) NSString *requestID;

@property (nonatomic, strong, nullable) NSString *subscriptionID;

@property (nonatomic, assign) CYBSMposPaymentResultDecision decision;

@property (nonatomic, strong, nullable) NSString *reasonCode;

@property (nonatomic, strong, nullable) NSString *requestToken;

@property (nonatomic, strong, nullable) NSString *authorizationCode;

@property (nonatomic, strong, nullable) NSDate *authorizedDateTime;

@property (nonatomic, strong, nullable) NSString *reconciliationID;

@property (nonatomic, strong, nullable) NSString *merchantReferenceCode;

@property (nonatomic, strong, nullable) CYBSMposPaymentResponseEmvReply *emvReply;

@property (nonatomic, strong, nullable) CYBSMposPaymentResponseCard *card;

@property (nonatomic, strong, nullable) NSString *authorizationMode;

@property (nonatomic, strong, nullable) NSString *entryMode;

@property (nonatomic, strong, nullable) CYBSMposPaymentResponseAuthReply * authReply;
@property (nonatomic, strong, nullable) CYBSMposPaymentResponseSubscriptionCreateReply * paySubscriptionCreateReply;
@property (nonatomic, strong, nullable) CYBSMposPaymentResponseCaptureReply * captureReply;
@property (nonatomic, strong, nullable) CYBSMposPaymentResponseAuthReversalReply * authReversalReply;
@property (nonatomic, strong, nullable) CYBSMposPaymentResponseVoidReply * voidReply;
@property (nonatomic, strong, nullable) CYBSMposPaymentResponseRefundReply * refundReply;
@property (nonatomic, strong, nullable) CYBSMposPaymentResponseICS_Message * ics_message;

@end

@interface CYBSMposPaymentResponseEmvReply : NSObject

@property (nonatomic, strong, nullable) NSMutableArray *emvTags;

+ (NSMutableArray *_Nonnull) buildEMVTags:(NSDictionary *_Nonnull)emvDict;

- (NSString *_Nonnull)tagValue:(NSString *_Nullable)iTagDescription;

@end

@interface CYBSMposPaymentResponseCard : NSObject

@property (nonatomic, strong, nullable) NSString *suffix;

@property(nonatomic, strong, nullable) NSString *registeredApplicationProviderId;

@property (nonatomic, strong, nullable) NSString *maskedPAN;

@property (nonatomic, strong, nullable) NSString *expiryDate;

@property (nonatomic, strong, nullable) NSString *cardHolderName;

@end

@interface CYBSMposPaymentResponseAuthReply : NSObject

@property (nonatomic, strong, nullable) NSString * accountBalance;
//! accountBalanceCurrency node
/*! Currency of the remaining balance on the prepaid card.
 */
@property (nonatomic, strong, nullable) NSString * accountBalanceCurrency;
//! accountBalanceSign node
@property (nonatomic, strong, nullable) NSString * accountBalanceSign;
//! amount node
/*! Amount that was authorized.
 */
@property (nonatomic, strong, nullable) NSString * amount;
//! authorizationCode node
@property (nonatomic, strong, nullable) NSString * authorizationCode;
//! authorizedDateTime node
@property (nonatomic, strong, nullable) NSString * authorizedDateTime;
//! avsCode node
/*! Address Verification System code
 */
@property (nonatomic, strong, nullable) NSString * avsCode;
//! avsCodeRaw node
/*! Address Verification System code sent directly from the processor.
 */
@property (nonatomic, strong, nullable) NSString * avsCodeRaw;
//! ownerMerchantID node
@property (nonatomic, strong, nullable) NSString * ownerMerchantID;
//! paymentNetworkTransactionID node
@property (nonatomic, strong, nullable) NSString * paymentNetworkTransactionID;
//! personalIDCode node
@property (nonatomic, strong, nullable) NSString * personalIDCode;
//! reasonCode node
@property (nonatomic, strong, nullable) NSString * reasonCode;
//! reconciliationID node
@property (nonatomic, strong, nullable) NSString * reconciliationID;
//! requestAmount node
/*! Amount you requested to be authorized. This value is returned for partial authorizations
 */
@property (nonatomic, strong, nullable) NSString * requestAmount;
//! requestCurrency node
@property (nonatomic, strong, nullable) NSString * requestCurrency;
//! transactionID node
@property (nonatomic, strong, nullable) NSString * transactionID;
//! processorResponse node
@property (nonatomic, strong, nullable) NSString * processorResponse;

@end


@interface CYBSMposPaymentResponseSubscriptionCreateReply : NSObject

//! reasonCode node
@property (nonatomic, strong, nullable) NSString * reasonCode;
//! subscriptionID node
@property (nonatomic, strong, nullable) NSString *subscriptionID;
//! instrumentIdentifierID node
@property (nonatomic, strong, nullable) NSString *instrumentIdentifierID;
//! instrumentIdentifierStatus node
@property (nonatomic, strong, nullable) NSString *instrumentIdentifierStatus;
//! instrumentIdentifierNew node
@property (nonatomic, strong, nullable) NSString * instrumentIdentifierNew;

@end


@interface CYBSMposPaymentResponseCaptureReply : NSObject

//! amount node
@property (nonatomic, strong, nullable) NSString * amount;
//! processorTransactionID node
@property (nonatomic, strong, nullable) NSString * processorTransactionID;
//! reasonCode node
@property (nonatomic, strong, nullable) NSString * reasonCode;
//! reconciliationID node
@property (nonatomic, strong, nullable) NSString * reconciliationID;
//! requestDateTime node
@property (nonatomic, strong, nullable) NSString * requestDateTime;

@end



@interface CYBSMposPaymentResponseAuthReversalReply : NSObject

//! amount node
@property (nonatomic, strong, nullable) NSString * amount;
//! authorizationCode node
@property (nonatomic, strong, nullable) NSString * authorizationCode;
//! amount forwardCode
@property (nonatomic, strong, nullable) NSString * forwardCode;
//! reasonCode node
@property (nonatomic, strong, nullable) NSString * reasonCode;
//! reconciliationID node
@property (nonatomic, strong, nullable) NSString * reconciliationID;
//! requestDateTime node
@property (nonatomic, strong, nullable) NSString * requestDateTime;
//! processorResponse node
@property (nonatomic, strong, nullable) NSString * processorResponse;

@end


@interface CYBSMposPaymentResponseVoidReply : NSObject

//! amount node
/*! Amount that was voided.
 */
@property (nonatomic, strong, nullable) NSString * amount;
//! currency node
@property (nonatomic, strong, nullable) NSString * currency;
//! reasonCode node
@property (nonatomic, strong, nullable) NSString * reasonCode;
//! requestDateTime node
@property (nonatomic, strong, nullable) NSString * requestDateTime;

@end


@interface CYBSMposPaymentResponseRefundReply : NSObject

//! amount node
@property (nonatomic, strong, nullable) NSString * amount;
//! forwardCode node
@property (nonatomic, strong, nullable) NSString * forwardCode;
//! reasonCode node
@property (nonatomic, strong, nullable) NSString * reasonCode;
//! reconciliationID node
@property (nonatomic, strong, nullable) NSString * reconciliationID;
//! requestDateTime node
@property (nonatomic, strong, nullable) NSString * requestDateTime;

@end


@interface CYBSMposPaymentResponseICS_Message : NSObject

//! auth_rmsg node
@property (nonatomic, strong, nullable) NSString * auth_rmsg;
//! auth_auth_amount node
@property (nonatomic, strong, nullable) NSString * auth_auth_amount;
//! auth_payment_network_transaction_id node
@property (nonatomic, strong, nullable) NSString * auth_payment_network_transaction_id;
//! auth_auth_avs node
@property (nonatomic, strong, nullable) NSString * auth_auth_avs;
//! bill_trans_ref_no node
@property (nonatomic, strong, nullable) NSString * bill_trans_ref_no;
//! bill_bill_trans_ref_no node
@property (nonatomic, strong, nullable) NSString * bill_bill_trans_ref_no;
//! ics_rflag node
@property (nonatomic, strong, nullable) NSString * ics_rflag;
//! terminal_id node
@property (nonatomic, strong, nullable) NSString * terminal_id;
//! auth_rcode node
@property (nonatomic, strong, nullable) NSString * auth_rcode;
//! bill_rflag node
@property (nonatomic, strong, nullable) NSString * bill_rflag;
//! ics_decision_reason_code node
@property (nonatomic, strong, nullable) NSString * ics_decision_reason_code;
//! bill_bill_request_time node
@property (nonatomic, strong, nullable) NSString * bill_bill_request_time;
//! ics_rmsg node
@property (nonatomic, strong, nullable) NSString * ics_rmsg;
//! bill_bill_amount node
@property (nonatomic, strong, nullable) NSString * bill_bill_amount;
//! merchant_ref_number node
@property (nonatomic, strong, nullable) NSString * merchant_ref_number;
//! bill_rmsg node
@property (nonatomic, strong, nullable) NSString * bill_rmsg;
//! bill_return_code node
@property (nonatomic, strong, nullable) NSString * bill_return_code;
//! request_token node
@property (nonatomic, strong, nullable) NSString * request_token;
//! acquirer_merchant_number node
@property (nonatomic, strong, nullable) NSString * acquirer_merchant_number;
//! auth_auth_time node
@property (nonatomic, strong, nullable) NSString * auth_auth_time;
//! ics_return_code node
@property (nonatomic, strong, nullable) NSString * ics_return_code;
//! auth_payment_service_data_2 node
@property (nonatomic, strong, nullable) NSString * auth_payment_service_data_2;
//! bill_rcode node
@property (nonatomic, strong, nullable) NSString * bill_rcode;
//! auth_rflag node
@property (nonatomic, strong, nullable) NSString * auth_rflag;
//! request_id node
@property (nonatomic, strong, nullable) NSString * request_id;
//! auth_trans_ref_no node
@property (nonatomic, strong, nullable) NSString * auth_trans_ref_no;
//! currency node
@property (nonatomic, strong, nullable) NSString * currency;
//! auth_auth_response node
@property (nonatomic, strong, nullable) NSString * auth_auth_response;
//! auth_return_code node
@property (nonatomic, strong, nullable) NSString * auth_return_code;
//! auth_auth_code node
@property (nonatomic, strong, nullable) NSString * auth_auth_code;

@end


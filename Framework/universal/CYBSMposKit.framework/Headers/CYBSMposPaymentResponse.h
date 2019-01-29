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

@end

@interface CYBSMposPaymentResponseEmvReply : NSObject

@property (nonatomic, strong, nullable) NSString *combinedTags;

@property (nonatomic, strong, nullable) NSString *decryptedRequestTags;

@property (nonatomic, strong, nullable) NSMutableArray *emvTags;

+ (NSMutableArray *_Nonnull) buildEMVTags:(NSDictionary *_Nonnull)emvDict;

- (NSString *_Nonnull)tagValue:(NSString *_Nullable)iTagDescription;

@end

@interface CYBSMposPaymentResponseCard : NSObject

@property (nonatomic, strong, nullable) NSString *suffix;

@property(nonatomic, strong, nullable) NSString* registeredApplicationProviderId;

@end

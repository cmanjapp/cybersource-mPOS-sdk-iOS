//
//  CYBSMposRefundRequest.h
//  CYBSMposKit
//
//  Created by CyberSource on 7/29/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYBSMposRefundRequest : NSObject

@property (nonatomic, strong, nonnull) NSString *merchantID;

@property (nonatomic, strong, nonnull) NSString *accessToken;

@property (nonatomic, strong, nonnull) NSString *merchantReferenceCode;

@property (nonatomic, strong, nonnull) NSString *transactionID;

@property (nonatomic, strong, nonnull) NSString *currency;

@property (nonatomic, strong, nonnull) NSDecimalNumber *amount;

- (nonnull instancetype)initWithMerchantID:(nonnull NSString *)merchantID
                               accessToken:(nonnull NSString *)accessToken
                     merchantReferenceCode:(nonnull NSString *)merchantReferenceCode
                             transactionID:(nonnull NSString *)transactionID
                                  currency:(nonnull NSString *)currency
                                    amount:(nonnull NSDecimalNumber *)amount;

@end

//
//  CYBSMposReceiptRequest.h
//  CYBSMposKit
//
//  Created by CyberSource on 7/16/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYBSMposReceiptRequest : NSObject

@property (nonatomic, strong, nullable) NSString *transactionID;

@property (nonatomic, strong, nonnull) NSString *toEmail;

@property (nonatomic, strong, nullable) NSString *fromEmail;

@property (nonatomic, strong, nullable) NSString *emailSubject;

@property (nonatomic, strong, nullable) NSString *merchantDescriptor;

@property (nonatomic, strong, nullable) NSString *merchantDescriptorStreet;

@property (nonatomic, strong, nullable) NSString *merchantDescriptorCity;

@property (nonatomic, strong, nullable) NSString *merchantDescriptorState;

@property (nonatomic, strong, nullable) NSString *merchantDescriptorPostalCode;

@property (nonatomic, strong, nullable) NSString *merchantDescriptorCountry;

@property (nonatomic, strong, nullable) NSString *merchantReferenceCode;

@property (nonatomic, strong, nullable) NSString *authCode;

@property (nonatomic, strong, nullable) NSString *shippingAmount;

@property (nonatomic, strong, nullable) NSString *taxAmount;

@property (nonatomic, strong, nullable) NSString *totalPurchaseAmount;

@property (nonatomic, strong, nullable) NSString *subscriptionID;

@property (nonatomic, strong, nullable) NSString *accessToken;

@property (nonatomic, strong, nullable) NSArray *items;

@property (nonatomic, strong, nullable) NSArray *emvTags;

@property (nonatomic, strong, nullable) NSString *paymentMode;

@property (nonatomic, strong, nullable) NSString *entryMode;

@property (nonatomic, strong, nullable) NSString *cardType;

@property (nonatomic, strong, nullable) NSString *suffix;


- (nonnull instancetype)initWithTransactionID:(nonnull NSString *)transactionID
                                      toEmail:(nonnull NSString *)toEmail
                                  accessToken:(nonnull NSString *)accessToken;

- (nonnull instancetype)initWithToEmail:(nonnull NSString *)toEmail
                              fromEmail:(nonnull NSString *)fromEmail
                           emailSubject:(nonnull NSString *)emailSubject
                     merchantDescriptor:(nonnull NSString *)merchantDescriptor
               merchantDescriptorStreet:(nonnull NSString *)merchantDescriptorStreet
                 merchantDescriptorCity:(nonnull NSString *)merchantDescriptorCity
                merchantDescriptorState:(nonnull NSString *)merchantDescriptorState
           merchantDescriptorPostalCode:(nonnull NSString *)merchantDescriptorPostalCode
              merchantDescriptorCountry:(nonnull NSString *)merchantDescriptorCountry
                  merchantReferenceCode:(nonnull NSString *)merchantReferenceCode
                               authCode:(nonnull NSString *)authCode
                         shippingAmount:(nonnull NSString *)shippingAmount
                              taxAmount:(nonnull NSString *)taxAmount
                    totalPurchaseAmount:(nonnull NSString *)totalPurchaseAmount
                         subscriptionID:(nonnull NSString *)subscriptionID
                            accessToken:(nonnull NSString *)accessToken;

@end

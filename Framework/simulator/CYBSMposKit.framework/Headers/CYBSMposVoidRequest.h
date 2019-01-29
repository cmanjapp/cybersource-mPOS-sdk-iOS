//
//  CYBSMposVoidRequest.h
//  CYBSMposKit
//
//  Created by CyberSource on 8/23/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYBSMposVoidRequest : NSObject

@property (nonatomic, strong, nonnull) NSString *merchantID;

@property (nonatomic, strong, nonnull) NSString *accessToken;

@property (nonatomic, strong, nonnull) NSString *merchantReferenceCode;

@property (nonatomic, strong, nonnull) NSString *transactionID;

- (nonnull instancetype)initWithMerchantID:(nonnull NSString *)merchantID
                               accessToken:(nonnull NSString *)accessToken
                     merchantReferenceCode:(nonnull NSString *)merchantReferenceCode
                             transactionID:(nonnull NSString *)transactionID;

@end

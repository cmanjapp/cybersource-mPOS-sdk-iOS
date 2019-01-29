//
//  CYBSMposTransactionSearchQuery.h
//  CYBSMposKit
//
//  Created by CyberSource on 7/26/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CYBSMposTransactionSearchQueryFilter) {
  CYBSMposTransactionSearchQueryFilterNone                  = 0,
  CYBSMposTransactionSearchQueryFilterAccountSuffix         = 1 << 0,
  CYBSMposTransactionSearchQueryFilterAccountPrefix         = 1 << 1,
  CYBSMposTransactionSearchQueryFilterLastName              = 1 << 2,
  CYBSMposTransactionSearchQueryFilterDeviceId              = 1 << 3,
  CYBSMposTransactionSearchQueryFilterMerchantReferenceCode = 1 << 4
};

@interface CYBSMposTransactionSearchQuery : NSObject

@property (nonatomic, assign) NSTimeInterval dateFrom;
@property (nonatomic, assign) NSTimeInterval dateTo;
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger filters;
@property (nonatomic, strong, nullable) NSString *accountSuffix;
@property (nonatomic, strong, nullable) NSString *accountPrefix;
@property (nonatomic, strong, nullable) NSString *lastName;
@property (nonatomic, strong, nullable) NSString *deviceId;
@property (nonatomic, strong, nullable) NSString *merchantReferenceCode;

@end

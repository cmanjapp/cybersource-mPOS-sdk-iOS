//
//  CYBSMposTransactionSearchResult.h
//  CYBSMposKit
//
//  Created by CyberSource on 7/27/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

@interface CYBSMposTransactionSearchResult : NSObject

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong, nullable) NSArray *transactions;

@end

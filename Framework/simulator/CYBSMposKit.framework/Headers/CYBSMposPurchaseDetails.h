//
//  CYBSMposPurchaseDetails.h
//  
//
//  Copyright (c) 2013 CyberSource Corporation. All rights reserved.
//


//! Purchase details object
/*! Contains the purchase details that are required for transactions
 */
@interface CYBSMposPurchaseDetails : NSObject <NSCopying>

//! Transaction currency name (3 letter)
@property (nonatomic, strong) NSString *currency;

//! Type of transaction. For a retail transaction, this value must be \c retail
/*! \c commerceIndicator is set to \c "retail" by default
 */
@property (nonatomic, strong) NSString *commerceIndicator;

//! Indicates partial authorization. For a partial authorization this value must be \c YES
/*! \c partialIndicator is set to \c YES by default
 */
@property (nonatomic) BOOL partialIndicator;

//! Transaction tax [%]
@property (nonatomic, strong) NSDecimalNumber *tax;

//! Transaction tip amount
@property (nonatomic, strong) NSDecimalNumber *tip;

//! The shipping cost
@property (nonatomic, strong) NSDecimalNumber *shippingAmount;

//! Total Tax amount
-(NSDecimalNumber *) getTotalTaxAmount:(NSDecimalNumber *)totalAmount;

@end

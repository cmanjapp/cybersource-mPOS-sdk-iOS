//
//  CYBSMposItem.h
//
//
//  Copyright (c) 2013 CyberSource Corporation. All rights reserved.
//

//! item object
/*! Contains the item's details, which are required for transactions.
 */
@interface CYBSMposItem : NSObject

//! item's name
@property (nonatomic, copy) NSString *name;
//! price for one unit 
@property (nonatomic, copy) NSDecimalNumber *price;
//! quantity of items
@property (nonatomic) NSInteger quantity;

//! price of individual tax for one item or -1 if individualTax is not defined
@property (nonatomic, copy) NSDecimalNumber *itemTaxAmount;

//! price including quantity (price * quantity)
- (NSDecimalNumber *) itemTotalPrice;

//! tax including quantity (individualTax * quantity)
- (NSDecimalNumber *) itemTotalTax;


//! validate if properties contains only allowed values
- (void) validateItemProperties;

@end

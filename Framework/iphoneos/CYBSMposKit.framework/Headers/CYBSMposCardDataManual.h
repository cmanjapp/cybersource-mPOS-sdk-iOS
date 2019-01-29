//
//  VMposCardDataManual.h
//  
//
//  Copyright (c) 2013 CyberSource Corporation. All rights reserved.
//

#import "VMposCardData.h"

//! VMposCardDataManual class
/*! This class represents data obtained manually.
 */
@interface CYBSMposCardDataManual : VMposCardData

//! A card's account number
@property (nonatomic, copy) NSString *accountNumber;
//! A card's expiration month
/*! The expiration month should have a format of MM. For example '02' for February
 */
@property (nonatomic, copy) NSString *expirationMonth;
//! A card's expiration year
/*! The expiration year should have a format of YYYY. For example '2013' for the year
 */
@property (nonatomic, copy) NSString *expirationYear;
//! A card verification number
@property (nonatomic, copy) NSString *cvNumber;
//! A card name
@property (nonatomic, copy) NSString *cardName;
//! zip code
@property (nonatomic, copy) NSString *zipCode;


//! Return VMposCardDataManual with card number initialized from @c paramAccount
+ (CYBSMposCardDataManual *) manualCardWithAccount:(NSString *)paramAccount;

//! Return VMposCardDataManual with card number initialized from @c paramAccount, @c paramMonth, @c paramYear
+ (CYBSMposCardDataManual *) manualCardWithAccount:(NSString *)paramAccount
                                          month:(NSString *)paramMonth
                                           year:(NSString *)paramYear;

@end

//
//  VMposAddress.h
//  
//
//  Copyright (c) 2013 CyberSource Corporation. All rights reserved.
//

#import <AddressBook/ABRecord.h>

//! Address object
/*! Contains the address details which are required for transactions
 */
@interface CYBSMposAddress : NSObject <NSCopying, NSCoding>

//! First name
@property (nonatomic, copy) NSString *firstName;
//! Last name
@property (nonatomic, copy) NSString *lastName;
//! Street name (with all required numbers)
@property (nonatomic, copy) NSString *street1;
//! Street name (with all required numbers)
@property (nonatomic, copy) NSString *street2;
//! City name
@property (nonatomic, copy) NSString *city;
//! State name
@property (nonatomic, copy) NSString *state;
//! Postal code
/*
 Postal code for the billing address. The postal code must consist of 5 to 9 digits.
 If the billing country is the U.S., the 9- digit postal code must follow this format: [5 digits][dash][4 digits] Example: 12345-6789
 If the billing country is Canada, the 6- digit postal code must follow this format: [alpha][numeric][alpha] [space][numeric][alpha] [numeric]
 Example: A1B 2C3
 */
@property (nonatomic, copy) NSString *postalCode;
//! Country
@property (nonatomic, copy) NSString *country;
//! E-mail address
@property (nonatomic, copy) NSString *email;
//! Phone number
@property (nonatomic, copy) NSString *phoneNumber;

@end

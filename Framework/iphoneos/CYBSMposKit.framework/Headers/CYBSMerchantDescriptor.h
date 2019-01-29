//
//  CYBSMerchantDescriptor.h
//
//  Created by CyberSource on 23/07/18.
//  Copyright © 2018 Rakesh Ramamurthy. All rights reserved.
//

#import <AddressBook/ABRecord.h>

//! Address object
/*! Contains the address details which are required for transactions
 */
@interface CYBSMerchantDescriptor : NSObject <NSCopying, NSCoding>

/*!
 Business name of merchant
 */
@property (nonatomic, copy) NSString *merchantDescriptorBusinessName;
//! Merchant name
@property (nonatomic, copy) NSString *merchantDescriptorName;
//! Street name (with all required numbers)
@property (nonatomic, copy) NSString *merchantDescriptorStreet;
//! City name
@property (nonatomic, copy) NSString *merchantDescriptorCity;
//! State name
@property (nonatomic, copy) NSString *merchantDescriptorState;
//! Postal code
/*
 Postal code for the billing address. The postal code must consist of 5 to 9 digits.
 If the billing country is the U.S., the 9- digit postal code must follow this format: [5 digits][dash][4 digits] Example: 12345-6789
 If the billing country is Canada, the 6- digit postal code must follow this format: [alpha][numeric][alpha] [space][numeric][alpha] [numeric]
 Example: A1B 2C3
 */
@property (nonatomic, copy) NSString *merchantDescriptorPostalCode;
//! Country
@property (nonatomic, copy) NSString *merchantDescriptorCountry;
//! E-mail address
@property (nonatomic, copy) NSString *merchantDescriptorEmail;
//! Phone number
@property (nonatomic, copy) NSString *merchantDescriptorPhoneNumber;

@property (nonatomic, strong) CYBSMerchantDescriptor *merchantDescriptorSettings;

//! Returns singleton CYBSMerchantDescriptor object
/*!
 Returns singleton CYBSMerchantDescriptor object
 Object is restored from keychain
 */
+ (CYBSMerchantDescriptor *) sharedInstance;
//! Save settings to keychain
/*!
 Save settings to keychain
 Return result of operation
 */
- (BOOL) saveSettings;
//! Remove settings from keychain
+ (void) removeSettings;

@end

//
//  VMposCardData.h
//  
//
//  Copyright (c) 2013 CyberSource Corporation. All rights reserved.
//


//!Representation of a type of the card used.
/*!
 This enumeration represents three different types of cards,
 that can be used with the card reader.
 EMV stands for Europay, MasterCard and Visa, a global standard for inter-operation of integrated circuit cards.
 */
typedef enum {
  VMPOS_CARD_TYPE_UNKNOWN = 0,  /*!< Unknown */
  VMPOS_CARD_TYPE_EMV,          /*!< EMV enabled card */
  VMPOS_CARD_TYPE_MAGNETIC,     /*!< Magnetic stripe card */
  VMPOS_CARD_TYPE_NFC,          /*!< NFC enabled card */
  VMPOS_CARD_TYPE_MANUAL        /*!< Maually collected card */
} VMposCardReadMode;

typedef enum {
    VMPOS_CARD_DATA_ENTRY_MODE_KEYED = 0,
    VMPOS_CARD_DATA_ENTRY_MODE_SWIPED,
    VMPOS_CARD_DATA_ENTRY_MODE_CONTACT,
    VMPOS_CARD_DATA_ENTRY_MODE_CONTACTLESS,
    VMPOS_CARD_DATA_ENTRY_MODE_MSD
} VMposCardDataEntryMode;

//! VMposCardData class
@interface VMposCardData : NSObject

//! Property cardReadMode represents the method card information is obtained [KeyedIn, Magnetic Reader, EMV and NFC]
@property (nonatomic, assign) VMposCardReadMode cardReadMode;

//! Property cardTypeName represents name of the card brand type.
@property (nonatomic, copy) NSString *cardTypeName;

//! Property card data entry mode
@property (nonatomic, readonly) VMposCardDataEntryMode entryMode;

//! validates \c VMposCardData object
/*!
 \return YES if all fields are updated, NO otherwise
 */
- (BOOL) validateCompletness;

//! returns last 4 digits from card number or nil if card number is incorrect
/*!
 \return last 4 digits from card number or nil if card number is incorrect
 */
- (NSString*) cardNumberLast4Digits;

//! returns Issuer identification number (IIN) or nil if card number is incorrect
/*!
 The first six digits of a card number (including the initial MII digit) are known as the issuer identification number (IIN).
 These identify the institution that issued the card to the card holder.
 \return Issuer identification number (IIN) or nil if card number is incorrect
 */
- (NSString*) cardIIN;

//! returns Masked PAN or nil if card number is incorrect
/*!
 Returns Masked PAN in format 123456......1234 (first 6 digits and last 4 digits are visible, rest of digits is replaced by '.')
 \return Masked PAN or nil if card number is incorrect
 */
- (NSString*) cardMaskedPAN;

//! return YES if cardType is EMV otherwise NO
- (BOOL) isEMV;
//! return YES if cardType is manual otherwise NO
- (BOOL) isManual;
//! return YES if cardType is magnetic otherwise NO
- (BOOL) isMagnetic;
//! return YES if cardType is NFC (Near Field Communication) otherwise NO
- (BOOL) isNFC;

@end

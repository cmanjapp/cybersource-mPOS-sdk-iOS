//
//  KeychainStore.h
//  CYBSMposKitDemo
//
//  Created by CyberSource on 5/21/15.
//  Copyright © 2015 CyberSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainStore : NSObject

//! Get a value from the keychain
/*!
 Returns a value from the keychain nil if key doesn't exist
 /param key key
 */
+ (NSData*) getSecureDataForKey:(NSString*)key;

//! Store a value in the keychain
/*!
 Returns a result of operation
 /param key key
 */
+ (BOOL) storeSecureData:(NSData *)data forKey:(NSString*)key;

//! Delete a value in the keychain
/*!
 /param identifier - key for value in chain
 */
+ (void) deleteKeychainValue:(NSString *)key;


@end

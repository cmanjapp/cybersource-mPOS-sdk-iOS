//
//  CYBSMposBluetoothDevice.h
//  CYBSMposKit
//
//  Created by CyberSource on 9/6/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYBSMposBluetoothDevice : NSObject
@property (nonatomic, copy, readonly) NSString* name;

- (id)initWithName:(NSString*) name;
@end

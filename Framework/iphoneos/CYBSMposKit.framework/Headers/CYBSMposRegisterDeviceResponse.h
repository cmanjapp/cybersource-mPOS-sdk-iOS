//
//  CYBSMposRegisterDeviceResponse.h
//  CYBSMposKit
//
//  Copyright © 2019 CyberSource. All rights reserved.
//

//! Register Device Response object
/*! Contains the register device response details.
 */

#import <Foundation/Foundation.h>

/**
 This enumeration represents a type of the device registration status.
 */
typedef NS_ENUM(NSUInteger, CYBSMposRegisterDeviceStatus) {
    /// Device registration unknown
    CYBSMposRegisterDeviceUnknown = 0,
    /// Device registration Pending
    CYBSMposRegisterDevicePending,
    /// Device registration completed and ready to use
    CYBSMposRegisterDeviceSetupReady,
    /// Device registration disabled by adminstrator
    CYBSMposRegisterDeviceDisabled,
    /// Device registration disabled by adminstrator
    CYBSMposRegisterDeviceFailed

};

@interface CYBSMposRegisterDeviceResponse : NSObject 

//! Bool value tells device registration successful or not
@property (nonatomic, assign) CYBSMposRegisterDeviceStatus status;

//! Provides device registration status for successful registration
@property (nonatomic, retain) NSString * _Nullable message;

//! Initializer method
- (nonnull instancetype)initWithData:(nonnull id)data;

@end

# CyberSource mobile point of sale
Ability to accept card payments via mobile platform across all channels ( Retail , Internet & MOTO) with BBPOS terminals. Our single universal SDK (iOS, Android) are designed to accept EMV - contact , Contactless , Swipe and Keyed-in transaction . Our solution is Integrated to Token management solution, to provide card data as tokens . The tokens can be used for follow-on, this provides ultimate security for merchants .Endless aisle use case provides easy access for customers to order products that are out of stock  or not sold in store and have them shipped to their homes.   Point to point encrypted PCI listed solution via Bluefin provides highest level of  security. White labelling of SDK provides rich customization to merchant’s app for branding . Payment search history , electronic signature storage and retrieval are additional value add provided by the SDK.

## Using the MPOS SDK
Refer here to get detailed implementation guide.
https://www.cybersource.com/developers/integration_methods/mpos/
1. Include *CYBSMposKit.framework* in the merchant's app. Select Target,
In Embedded Binaries, press the plus (+) and select the framework. Once
included, make sure in *Build Settings* tab, in section *Search Paths* the path
to these frameworks are added correctly.
2. If the application is developed in *Swift*, the application must
have a bridging header file created because the CYBSMposKit.framework is written
in *Objective-C*.
```
// Example: CybsMposDemo-Bridging-Header.h
#ifndef CYBSMposDemo_Bridging_Header_h
#define CYBSMposDemo_Bridging_Header_h
#import <CYBSMposKit/CYBSMposKit.h>
#endif
```
3. In your project Info.plist file, add property "Supported external accessory protocols", and add "com.bbpos.bt.wisepad" as one of the values.
4. For Bluetooth MFi device, connect your reader in Settings - Bluetooth before scanning available readers.

### Create and Submit an EMV transaction
1. Initialize the SDK with environment and device id
```
// Swift
let manager = CYBSMposManager.sharedInstance()
```
```
// Objective-C
CYBSMposManager *manager = [CYBSMposManager sharedInstance];
```


2. Connect to card reader
- Bluetooth
```
// Swift
// Scan devices, and check scan result in CYBSMposManagerDelegate callback method
manager.scanBTDevices(self)

// Scan callback method in CYBSMposManagerDelegate
func onBTReturnScanResults(_ devices:[CYBSMposBluetoothDevice]? {
    deviceList = devices
    //loop devices array list
    for device in deviceList {
        let name = device.name
    }
}

// Connect to a card reader
let selectedDevice = deviceList[0]
manager.connectBTDevice(selectedDevice)

// Connect callback method in CYBSMposManagerDelegate
func onBTConnected() {
    // Now you can get the card reader info
    manager.getDeviceInfo(self)
}
```

```
// Objective-C
// For devices with bluetooth MFi (wisepad2), connect from Settings - Bluetooth first. 
// Scan for available device
[manager scanBTDevices:self delegate:self];

// Wait for callback method deviceList in CYBSMposManagerDelegate
// Scan callback method in CYBSMposManagerDelegate
- (void)deviceList:(nullable NSArray *) deviceList {
    if (nil == devices) {
        return;
    }
    // Loop devices array list
    for (int i = 0; i < deviceList.count; ++i) {
        NSObject *deviceDict = [deviceList objectAtIndex:i];
        NSString *serial = [deviceDict valueForKey:@"serialNumber"];
        NSString *model = [deviceDict valueForKey:@"name"];
        NSString *version = [deviceDict valueForKey:@"firmwareRevision"];
    }
}

// Passing one of the object returned by above callback to connect to reader.
[manager connectBTDevice:device];

// Connect callback method in CYBSMposManagerDelegate
- (void)onBTConnected {
    // Now you can get the card reader info
    [manager getDeviceInfo:self];
}
```

- Audio Jack
```
// Swift
// Start audio
manager.startAudio(self)

// Audio callback methods in CYBSMposManagerDelegate
func onAudioDevicePlugged() {}
func onAudioInterrupted() {}
func onNoAudioDeviceDetected() {}
```

```
// Objective-C
// Start audio
[manager startAudio:self];

// Audio callback methods
- (void)onAudioDevicePlugged {}
- (void)onAudioInterrupted {}
- (void)onNoAudioDeviceDetected {}
```


3. Create the CYBSMposPaymentRequest. For more details, refer to CYBSMposPaymentRequest.h
```
// Swift
var amount:NSDecimalNumber = 10.0
let paymentRequest = CYBSMposPaymentRequest(
    merchantID: merchantID, 
    accessToken: accessToken, 
    amount: amount, 
    entryMode: .swipeOrInsertOrTap
)
```

```
// Objective-C
NSDecimalNumber* amount = [[NSDecimalNumber alloc] initWithString:@"10.0"];
CYBSMposPaymentRequest *paymentRequest = [[CYBSMposPaymentRequest alloc] initWithMerchantID: merchantID 
                                        accessToken:accessToken
                                        amount:amount
                                        entryMode:CYBSMposPaymentRequestEntryModeSwipeOrInsertOrTap];
```


4. Start Payment flow
With the initialized paymentRequest, you can start a payment and handle payment response(see step 5).
```
// Swift
manager.performPayment(paymentRequest, parentViewController: self, delegate: self)
```

```
// Objective-C
[manager performPayment:paymentRequest parentViewController:self delegate:self];
```


5. Handle Payment response. For more details, refer to CYBSMposPaymentResponse.h
```
// Swift
func performPaymentDidFinish(result: CYBSMposPaymentResponse?, error: NSError?) {
    if error != nil {
        // Error handling
    } else {
    }
}
```

```
// Objective-C
- (void) performPaymentDidFinish:(nullable CYBSMposPaymentResponse *)result error:(nullable NSError *)error {
    if (error != nil) {
        // Error handling
    } else {
    }
}
```

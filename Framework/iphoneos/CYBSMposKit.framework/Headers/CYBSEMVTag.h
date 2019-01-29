//
//  CYBSEMVTag.h
//
//  Created by CyberSource on 12/10/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYBSEMVTag : NSObject {
    
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *formatted;
@property (nonatomic, strong) NSString *tagDesciption;

+ (CYBSEMVTag *) tag;
+ (CYBSEMVTag *)buildTag:(NSString *)key withValue:(NSString *)value;
+ (NSString *)tagDescription:(NSString *)iTagName;

@end

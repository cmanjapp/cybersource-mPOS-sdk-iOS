//
//  ReceiptFormatter.m
//  CYBSMposKitDemo
//
//  Created by Rakesh Ramamurthy on 12/10/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReceiptFormatter.h"
#import "NSDate+Helper.h"
#import "CYBSMposKitDemo-Swift.h"

@interface ReceiptFormatter()

@end

@implementation ReceiptFormatter

- (UIImage *)getReceiptImageForRequest:(CYBSMposPaymentRequest *)request
                              response:(CYBSMposPaymentResponse *)response {
    
    //UIFont *menloRegular12 = [UIFont fontWithName:@"Menlo" size:12];
    UIFont *menloRegular14 = [UIFont fontWithName:@"Menlo" size:14];
    UIFont *menloBold20 = [UIFont fontWithName:@"Menlo-Bold" size:20];
    UIFont *arialBold28 = [UIFont fontWithName:@"Arial-BoldMT" size:28];
    UIFont *courier12 = [UIFont fontWithName:@"Courier" size:12];
    UIFont *courier14 = [UIFont fontWithName:@"Courier" size:14];

    NSMutableAttributedString *receiptString = [[NSMutableAttributedString alloc] init];
    
    //Merchant name
    NSString *merchantName = @"STARBUCKS";
    NSMutableAttributedString *nameName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n", merchantName]];
    [nameName addAttribute:NSFontAttributeName value:menloBold20 range:NSMakeRange(0, nameName.length)];
    [receiptString appendAttributedString:nameName];
    
    //Merchant address
    NSString *addressStr = @"Address";
    NSMutableAttributedString *address = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", addressStr]];
    [address addAttribute:NSFontAttributeName value:menloRegular14 range:NSMakeRange(0, address.length)];
    [receiptString appendAttributedString:address];
    
    //Merchant phone
    NSString *phoneStr = @"99889988899";
    NSMutableAttributedString *phone = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n", phoneStr]];
    [phone addAttribute:NSFontAttributeName value:menloRegular14 range:NSMakeRange(0, phone.length)];
    [receiptString appendAttributedString:phone];
    
    //transaction date
    NSString *weekday = [NSString stringWithFormat:@"%@", [NSDate stringFromDate:[NSDate date] withFormat:@"EEEE"]];
    NSString *dateStr = [NSString stringWithFormat:@"%@\n", [NSDate stringFromDate:[NSDate date] withFormat:@"MMM d, yyyy h:mm a"]];
    
    NSMutableAttributedString *date = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@, %@\n", weekday, dateStr]];
    [date addAttribute:NSFontAttributeName value:menloRegular14 range:NSMakeRange(0, date.length)];
    [receiptString appendAttributedString:date];
    
    //transaction Id
    NSMutableAttributedString *transactionID = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Transaction ID: %@\n", response.requestID]];
    [transactionID addAttribute:NSFontAttributeName value:menloRegular14 range:NSMakeRange(0, transactionID.length)];
    [receiptString appendAttributedString:transactionID];
    
    //line
    NSMutableAttributedString *lineStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"-----------------------------------------------------------------------------------------------\n\n"]];
    [receiptString appendAttributedString:lineStr];
    
    //PAID BY: card number
    NSString *accountNumber = response.card.suffix;
    NSMutableAttributedString *paidBy = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"PAID BY:           %@\n", accountNumber]];
    [paidBy addAttribute:NSFontAttributeName value:menloRegular14 range:NSMakeRange(0, paidBy.length)];
    [receiptString appendAttributedString:paidBy];
    
    //TRANSACTION TYPE
    NSMutableAttributedString *transType = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"TRANSACTION TYPE:  Purchase\n\n"]];
    [transType addAttribute:NSFontAttributeName value:menloRegular14 range:NSMakeRange(0, transType.length)];
    [receiptString appendAttributedString:transType];
    
    //Thank you
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    NSMutableAttributedString *thankyou = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Thank you for your business!\n\n"] attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    [thankyou addAttribute:NSFontAttributeName value:menloRegular14 range:NSMakeRange(0, thankyou.length)];
    [receiptString appendAttributedString:thankyou];

    //Total amount
    NSMutableAttributedString *totalAmt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@\n\n", request.purchaseDetails.totalAmount] attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    [totalAmt addAttribute:NSFontAttributeName value:arialBold28 range:NSMakeRange(0, totalAmt.length)];
    [receiptString appendAttributedString:totalAmt];

    //TODO: line items
    
    //line
    //[receiptString appendAttributedString:lineStr];
    
    //TODO: other costs like tax, shipping etc

    //Payment Information
    NSMutableAttributedString *pmtInfo = [[NSMutableAttributedString alloc] initWithString:@"\nPayment Information"];
    [pmtInfo addAttribute:NSFontAttributeName value:courier14 range:NSMakeRange(0, pmtInfo.length)];
    [receiptString appendAttributedString:pmtInfo];

    //emv tags
    NSMutableAttributedString *tagsStr = [[NSMutableAttributedString alloc] initWithString:[self formatEMVTagsForTransactionResponse:response]];
    [tagsStr addAttribute:NSFontAttributeName value:courier12 range:NSMakeRange(0, tagsStr.length)];
    [receiptString appendAttributedString:tagsStr];

//    TextFormatter *formatter = [[TextFormatter alloc] init];
//    NSMutableArray *emvTagsArr = [NSMutableArray array];
//
//    EMVTag *authCodeTag = [[EMVTag alloc] initWithDesc:@"Auth Code" val:response.authorizationCode];
//    [emvTagsArr addObject:authCodeTag];
//    EMVTag *authModeTag = [[EMVTag alloc] initWithDesc:@"Authorization Mode" val:response.authorizationMode];
//    [emvTagsArr addObject:authModeTag];
//    EMVTag *entryModeTag = [[EMVTag alloc] initWithDesc:@"Entry Mode" val:response.entryMode];
//    [emvTagsArr addObject:entryModeTag];
//
//    for (CYBSEMVTag *tag in response.emvReply.emvTags) {
//        if (tag.tagDesciption.length > 0) {
//            NSString *formattedDescr = [[NSString alloc] initWithString:tag.tagDesciption];
//            NSRange lastColen = [formattedDescr rangeOfString:@":" options:NSBackwardsSearch];
//
//            if(lastColen.location != NSNotFound) {
//                formattedDescr = [formattedDescr stringByReplacingCharactersInRange:lastColen
//                                                                         withString: @""];
//            }
//
//            EMVTag *newTag = [[EMVTag alloc] initWithDesc:formattedDescr val:tag.value];
//            [emvTagsArr addObject:newTag];
//        }
//    }
//    NSString *formattedTagsStr = [[NSString alloc] initWithString:[formatter getFormattedEMVTextWithEmvData:emvTagsArr]];
//    NSMutableAttributedString *tagsStr = [[NSMutableAttributedString alloc] initWithString:formattedTagsStr];
//    [tagsStr addAttribute:NSFontAttributeName value:menloRegular12 range:NSMakeRange(0, tagsStr.length)];
//    [receiptString appendAttributedString:tagsStr];

    //line
    [receiptString appendAttributedString:lineStr];

    //Signature
    Settings *settings = [Settings sharedInstance];
    if (request.purchaseDetails.totalAmount.intValue >= settings.signatureMinAmount) {
        NSMutableAttributedString *cross = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\nX\n"]];
        [cross addAttribute:NSFontAttributeName value:arialBold28 range:NSMakeRange(0, cross.length)];
        [receiptString appendAttributedString:cross];
        
        [receiptString appendAttributedString:lineStr];
        
        NSMutableAttributedString *iagree = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"I agree to pay the above total according to my card issuer agreement.\n"]];
        [iagree addAttribute:NSFontAttributeName value:courier12 range:NSMakeRange(0, iagree.length)];
        [receiptString appendAttributedString:iagree];
    }

    //TODO: Copy string
    
    return [self imageWithAttributedString:receiptString width:384];
    //return [self imageFromText:receiptString width:384];
}


- (NSString *)formatEMVTagsForTransactionResponse:(CYBSMposPaymentResponse *)response
{
    TextFormatter *formatter = [[TextFormatter alloc] init];
    NSMutableArray *emvTagsArr = [NSMutableArray array];
    
    EMVTag *authCodeTag = [[EMVTag alloc] initWithDesc:@"Auth Code" val:response.authorizationCode];
    [emvTagsArr addObject:authCodeTag];
    EMVTag *authModeTag = [[EMVTag alloc] initWithDesc:@"Authorization Mode" val:response.authorizationMode];
    [emvTagsArr addObject:authModeTag];
    EMVTag *entryModeTag = [[EMVTag alloc] initWithDesc:@"Entry Mode" val:response.entryMode];
    [emvTagsArr addObject:entryModeTag];
    
    for (CYBSEMVTag *tag in response.emvReply.emvTags) {
        if (tag.tagDesciption.length > 0) {
            NSString *formattedDescr = [[NSString alloc] initWithString:tag.tagDesciption];
            NSRange lastColen = [formattedDescr rangeOfString:@":" options:NSBackwardsSearch];
            
            if(lastColen.location != NSNotFound) {
                formattedDescr = [formattedDescr stringByReplacingCharactersInRange:lastColen
                                                                         withString: @""];
            }
            
            EMVTag *newTag = [[EMVTag alloc] initWithDesc:formattedDescr val:tag.value];
            [emvTagsArr addObject:newTag];
        }
    }
    NSString *formattedTagsStr = [[NSString alloc] initWithString:[formatter getFormattedEMVTextWithEmvData:emvTagsArr]];
    
    return formattedTagsStr;
}


- (UIImage *)imageWithAttributedString:(NSMutableAttributedString *)string width:(CGFloat)width {
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine context:nil].size;
    size.width = width;
    if ([UIScreen.mainScreen respondsToSelector:@selector(scale)]) {
        if (UIScreen.mainScreen.scale == 2.0) {
            UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    
    CGRect rect = CGRectMake(0, 0, width, size.height + 1);
    
    CGContextFillRect(context, rect);
    
    [string drawInRect:rect];
    
    UIImage *imageToPrint = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(imageToPrint, 1.0);
    
    UIImage *imageObj = [UIImage imageWithData:imageData];

    return imageObj;
}

@end

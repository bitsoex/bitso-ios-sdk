//
//  UserTransaction.m
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala Zavala on 5/26/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import "BTSUserTransactionModel.h"

@implementation BTSUserTransactionModel

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return dateFormatter;
}

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"type": @"type",
             @"datetime": @"datetime",
             @"method": @"method",
             @"oid": @"order_id",
             @"tid": @"id",
             @"_mxn": @"mxn",
             @"mxn": @"mxn",
             @"_btc": @"btc",
             @"btc": @"btc",
             @"_rate": @"rate",
             @"rate": @"rate"};
}



+ (NSValueTransformer *)rateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *ratestr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:ratestr];
    } reverseBlock:^(NSDecimalNumber *ratenum, BOOL *success, NSError **error) {
        return [ratenum stringValue];
    }];
}

+ (NSValueTransformer *)mxnJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *mxnstr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:mxnstr];
    } reverseBlock:^(NSDecimalNumber *mxnnum, BOOL *success, NSError **error) {
        return [mxnnum stringValue];
    }];
}

+ (NSValueTransformer *)btcJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *btcstr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:btcstr];
    } reverseBlock:^(NSDecimalNumber *btcnum, BOOL *success, NSError **error) {
        return [btcnum stringValue];
    }];
}

+ (NSValueTransformer *)datetimeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}



+ (NSValueTransformer *)typeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *typeNumber, BOOL *success, NSError *__autoreleasing *error) {
        NSString *typeText = nil;
        if ([typeNumber integerValue] == 0) {
            typeText = @"Deposit";
        } else if ([typeNumber integerValue] == 1) {
            typeText = @"Withdrawal";
        } else if ([typeNumber integerValue] == 2){
            typeText = @"Trade";
        }
        return typeText;
        
    } reverseBlock:^id(NSString *typeName, BOOL *success, NSError *__autoreleasing *error) {
        NSString *typeNum = nil;
        if ([typeName isEqualToString:@"Deposit"]) {
            typeNum = @"0";
        } else if ([typeName isEqualToString:@"Withdrawal"]) {
            typeNum = @"1";
        } else if ([typeName isEqualToString:@"Trade"]){
            typeNum = @"2";
        }
        return typeNum;
    }];
}



@end

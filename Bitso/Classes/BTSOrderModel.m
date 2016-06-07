//
//  LookupOrderModel.m
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala on 5/27/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import "BTSOrderModel.h"

@implementation BTSOrderModel

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //2015-10-10 16:19:33
    return dateFormatter;
}


#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    //NSLog(@"TransactionModel JSONKeyPathsByPropertyKey");
    //NSMutableDictionary *mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    //NSLog(@"mapping %@", mapping);
    
    return @{@"oid": @"id",
             @"type": @"type",
             @"status": @"status",
             @"created": @"created",
             @"updated": @"updated",
             @"_amount": @"amount",
             @"amount": @"amount",
             @"_price": @"price",
             @"price": @"price"};
}


+ (NSValueTransformer *)createdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}


- (NSDecimalNumber *)amount {
    return [NSDecimalNumber decimalNumberWithString:self._amount];
}

- (NSDecimalNumber *)price {
    return [NSDecimalNumber decimalNumberWithString:self._price];
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *typenum, BOOL *success, NSError *__autoreleasing *error) {
        if ([typenum isEqualToString:@"1"])
            return @"Sell";
        return @"Buy";
    } reverseBlock:^id(NSString *typestr, BOOL *success, NSError *__autoreleasing *error) {
        if ([typestr isEqualToString:@"Sell"])
            return @"1";
        return @"0";
    }];
}


+ (NSValueTransformer *)statusJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *statusNum, BOOL *success, NSError *__autoreleasing *error) {
        if ([statusNum isEqualToString:@"-1"]) {
            return @"Cancelled";
        } else if ([statusNum isEqualToString:@"0"]) {
            return @"Active";
        } else if ([statusNum isEqualToString:@"1"]) {
            return @"Partial";
        } else {
            return @"Complete";
        }
    } reverseBlock:^id(NSString *statusStr, BOOL *success, NSError *__autoreleasing *error) {
        if ([statusStr isEqualToString:@"Cancelled"]) {
            return @"-1";
        } else if ([statusStr isEqualToString:@"Active"]) {
            return @"0";
        } else if ([statusStr isEqualToString:@"Partial"]) {
            return @"1";
        } else {
            return @"2";
        }
    }];
}


+ (NSValueTransformer *)amountJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *amountstr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:amountstr];
    } reverseBlock:^(NSDecimalNumber *amount, BOOL *success, NSError **error) {
        return [amount stringValue];
    }];
}

+ (NSValueTransformer *)priceJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *pricestr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:pricestr];
    } reverseBlock:^(NSDecimalNumber *price, BOOL *success, NSError **error) {
        return [price stringValue];
    }];
}





@end

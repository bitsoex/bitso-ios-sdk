//
//  TransactionModel.m
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala on 5/16/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import "BTSTransactionModel.h"

//@class TransactionModel;

@implementation BTSTransactionModel



#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    //NSLog(@"TransactionModel JSONKeyPathsByPropertyKey");
    //NSMutableDictionary *mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    //NSLog(@"mapping %@", mapping);
    
    return @{
             @"_amount": @"amount",
             @"amount": @"amount",
             @"_price": @"price",
             @"price": @"price",
             @"side": @"side",
             @"tid": @"tid",
             @"date": @"date"
             };
}


+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSNumber *timestamp, BOOL *success, NSError **error){
        return [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    } reverseBlock:^(NSDate *date, BOOL *success, NSError **error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }];
}

- (NSDecimalNumber *)amount {
    return [NSDecimalNumber decimalNumberWithString:self._amount];
}

- (NSDecimalNumber *)price {
    return [NSDecimalNumber decimalNumberWithString:self._price];
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

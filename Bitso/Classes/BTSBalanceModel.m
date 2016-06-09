//
//  BalanceModel.m
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala Zavala on 5/26/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import "BTSBalanceModel.h"

@implementation BTSBalanceModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    //NSLog(@"TransactionModel JSONKeyPathsByPropertyKey");
    //NSMutableDictionary *mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    //NSLog(@"mapping %@", mapping);
    
    return @{
             @"_fee": @"fee",
             @"fee": @"fee",
             @"_btc_available": @"btc_available",
             @"btc_available": @"btc_available",
             @"_btc_reserved": @"btc_reserved",
             @"btc_reserved": @"btc_reserved",
             @"_btc_balance": @"btc_balance",
             @"btc_balance": @"btc_balance",
             @"_mxn_available": @"mxn_available",
             @"mxn_available": @"mxn_available",
             @"_mxn_reserved": @"mxn_reserved",
             @"mxn_reserved": @"mxn_reserved",
             @"_mxn_balance": @"mxn_balance",
             @"mxn_balance": @"mxn_balance"
             };
}


- (NSDecimalNumber *)fee {
    NSLog(@"fee: %@", self._fee);
    return [NSDecimalNumber decimalNumberWithString:self._fee];
}


- (NSDecimalNumber *)btc_available {
    return [NSDecimalNumber decimalNumberWithString:self._btc_available];
}

- (NSDecimalNumber *)btc_reserved {
    return [NSDecimalNumber decimalNumberWithString:self._btc_reserved];
}

- (NSDecimalNumber *)btc_balance {
    return [NSDecimalNumber decimalNumberWithString:self._btc_balance];
}

- (NSDecimalNumber *)mxn_available {
    return [NSDecimalNumber decimalNumberWithString:self._mxn_available];
}


- (NSDecimalNumber *)mxn_reserved {
    return [NSDecimalNumber decimalNumberWithString:self._mxn_reserved];
}

- (NSDecimalNumber *)mxn_balance {
    return [NSDecimalNumber decimalNumberWithString:self._mxn_balance];
}




+ (NSValueTransformer *)feeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *feestr, BOOL *success, NSError **error){
        NSLog(@"fee 2: %@", feestr);
        return [NSDecimalNumber decimalNumberWithString:feestr];
    } reverseBlock:^(NSDecimalNumber *fee, BOOL *success, NSError **error) {
        NSLog(@"fee 2b: %@", [fee stringValue]);
        return [fee stringValue];
    }];
}

+ (NSValueTransformer *)btc_availableJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *btc_availablestr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:btc_availablestr];
    } reverseBlock:^(NSDecimalNumber *btc_available, BOOL *success, NSError **error) {
        return [btc_available stringValue];
    }];
}

+ (NSValueTransformer *)btc_reservedJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *btc_reservedstr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:btc_reservedstr];
    } reverseBlock:^(NSDecimalNumber *btc_reserved, BOOL *success, NSError **error) {
        return [btc_reserved stringValue];
    }];
}
+ (NSValueTransformer *)btc_balanceJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *btc_balancestr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:btc_balancestr];
    } reverseBlock:^(NSDecimalNumber *btc_balance, BOOL *success, NSError **error) {
        return [btc_balance stringValue];
    }];
}

+ (NSValueTransformer *)mxn_availableJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *mxn_availablestr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:mxn_availablestr];
    } reverseBlock:^(NSDecimalNumber *mxn_available, BOOL *success, NSError **error) {
        return [mxn_available stringValue];
    }];
}

+ (NSValueTransformer *)mxn_reservedJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *mxn_reservedstr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:mxn_reservedstr];
    } reverseBlock:^(NSDecimalNumber *mxn_reserved, BOOL *success, NSError **error) {
        return [mxn_reserved stringValue];
    }];
}

+ (NSValueTransformer *)mxn_balanceJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *mxn_balancestr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:mxn_balancestr];
    } reverseBlock:^(NSDecimalNumber *mxn_balance, BOOL *success, NSError **error) {
        return [mxn_balance stringValue];
    }];
}

@end

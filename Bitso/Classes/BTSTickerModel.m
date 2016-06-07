//
//  TickerModel.m
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala on 5/25/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import "BTSTickerModel.h"

@implementation BTSTickerModel



#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    //NSLog(@"TransactionModel JSONKeyPathsByPropertyKey");
   // NSMutableDictionary *mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    //NSLog(@"mapping %@", mapping);
    
    return @{
             @"_volume": @"volume",
             @"volume": @"volume",
             @"_high": @"high",
             @"high": @"high",
             @"_low": @"low",
             @"low": @"low",
             @"_last": @"last",
             @"last": @"last",
             @"_ask": @"ask",
             @"ask": @"ask",
             @"_bid": @"bid",
             @"bid": @"bid",
             @"_vwap": @"vwap",
             @"vwap": @"vwap",
             @"date": @"timestamp"
             };
}


+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSNumber *timestamp, BOOL *success, NSError **error){
        return [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    } reverseBlock:^(NSDate *date, BOOL *success, NSError **error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }];
}

- (NSDecimalNumber *)volume {
    return [NSDecimalNumber decimalNumberWithString:self._volume];
}

- (NSDecimalNumber *)high {
    return [NSDecimalNumber decimalNumberWithString:self._high];
}

- (NSDecimalNumber *)low {
    return [NSDecimalNumber decimalNumberWithString:self._low];
}

- (NSDecimalNumber *)last {
    return [NSDecimalNumber decimalNumberWithString:self._last];
}

- (NSDecimalNumber *)ask {
    return [NSDecimalNumber decimalNumberWithString:self._ask];
}

- (NSDecimalNumber *)bid {
    return [NSDecimalNumber decimalNumberWithString:self._bid];
}

- (NSDecimalNumber *)vwap {
    return [NSDecimalNumber decimalNumberWithString:self._vwap];
}




+ (NSValueTransformer *)volumeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *volumestr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:volumestr];
    } reverseBlock:^(NSDecimalNumber *volume, BOOL *success, NSError **error) {
        return [volume stringValue];
    }];
}


+ (NSValueTransformer *)highJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *highstr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:highstr];
    } reverseBlock:^(NSDecimalNumber *high, BOOL *success, NSError **error) {
        return [high stringValue];
    }];
}

+ (NSValueTransformer *)lowJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *lowstr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:lowstr];
    } reverseBlock:^(NSDecimalNumber *low, BOOL *success, NSError **error) {
        return [low stringValue];
    }];
}

+ (NSValueTransformer *)lastJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *laststr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:laststr];
    } reverseBlock:^(NSDecimalNumber *last, BOOL *success, NSError **error) {
        return [last stringValue];
    }];
}

+ (NSValueTransformer *)askJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *askstr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:askstr];
    } reverseBlock:^(NSDecimalNumber *ask, BOOL *success, NSError **error) {
        return [ask stringValue];
    }];
}

+ (NSValueTransformer *)bidJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *bidstr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:bidstr];
    } reverseBlock:^(NSDecimalNumber *bid, BOOL *success, NSError **error) {
        return [bid stringValue];
    }];
}

+ (NSValueTransformer *)vwapJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *vwapstr, BOOL *success, NSError **error){
        return [NSDecimalNumber decimalNumberWithString:vwapstr];
    } reverseBlock:^(NSDecimalNumber *vwap, BOOL *success, NSError **error) {
        return [vwap stringValue];
    }];
}





@end

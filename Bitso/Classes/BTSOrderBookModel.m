//
//  OrderBook.m
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala on 5/26/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import "BTSOrderBookModel.h"
//#import "BTSPublicOrderModel.h"
@implementation BTSOrderBookModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"asks": @"asks",
             @"bids": @"bids",
             @"date": @"timestamp"
             };
}


+ (NSValueTransformer *)asksJSONTransformer {
    NSLog(@"asks transformer");
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *asksArray = [NSMutableArray array];
        for (NSMutableArray *order in value) {
            NSMutableArray *numbersArray = [NSMutableArray array];
            for (NSString *strNumber in order) {
                [numbersArray addObject:[NSDecimalNumber decimalNumberWithString:strNumber]];
            }
            [asksArray addObject:numbersArray];
        }
        return asksArray;
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray * asksArray = [NSMutableArray array];
        for (NSMutableArray *order in value) {
            NSMutableArray *numbersArray = [NSMutableArray array];
            for (NSDecimalNumber *number in order) {
                [numbersArray addObject:[value stringValue]];
                
            }
            [asksArray addObject:numbersArray];
        }
        return asksArray;
    }];
}



+ (NSValueTransformer *)bidsJSONTransformer {
    NSLog(@"bids transformer");
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *bidsArray = [NSMutableArray array];
        for (NSMutableArray *order in value) {
            NSMutableArray *numbersArray = [NSMutableArray array];
            for (NSString *strNumber in order) {
                [numbersArray addObject:[NSDecimalNumber decimalNumberWithString:strNumber]];
            }
            [bidsArray addObject:numbersArray];
        }
        return bidsArray;
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *bidsArray = [NSMutableArray array];
        for (NSMutableArray *order in value) {
            NSMutableArray *numbersArray = [NSMutableArray array];
            for (NSDecimalNumber *number in order) {
                [numbersArray addObject:[value stringValue]];
                
            }
            [bidsArray addObject:numbersArray];
        }
        return bidsArray;
    }];
}

 

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSNumber *timestamp, BOOL *success, NSError **error){
        return [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    } reverseBlock:^(NSDate *date, BOOL *success, NSError **error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }];
}


@end

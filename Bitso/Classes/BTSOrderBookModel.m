//
//  OrderBook.m
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala on 5/26/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import "BTSOrderBookModel.h"

@implementation BTSOrderBookModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"asks": @"asks",
             @"bids": @"bids",
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


@end

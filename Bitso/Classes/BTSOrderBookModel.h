//
//  OrderBook.h
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala Zavala on 5/26/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BTSOrderBookModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *asks;
@property (nonatomic, copy) NSArray *bids;
@property (nonatomic, copy) NSDate *date;


@end

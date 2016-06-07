//
//  TickerModel.h
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala on 5/25/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface BTSTickerModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *_volume;
@property (nonatomic, copy) NSDecimalNumber *volume;

@property (nonatomic, copy) NSString *_last;
@property (nonatomic, copy) NSDecimalNumber *last;

@property (nonatomic, copy) NSString *_high;
@property (nonatomic, copy) NSDecimalNumber *high;

@property (nonatomic, copy) NSString *_low;
@property (nonatomic, copy) NSDecimalNumber *low;

@property (nonatomic, copy) NSString *_ask;
@property (nonatomic, copy) NSDecimalNumber *ask;

@property (nonatomic, copy) NSString *_bid;
@property (nonatomic, copy) NSDecimalNumber *bid;

@property (nonatomic, copy) NSString *_vwap;
@property (nonatomic, copy) NSDecimalNumber *vwap;

@property (nonatomic, copy) NSDate *date;

@end

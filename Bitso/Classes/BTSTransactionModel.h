//
//  TransactionModel.h
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala on 5/16/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//


#import <Mantle/MTLModel.h>
#import <Mantle/Mantle.h>


@interface BTSTransactionModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *_amount;
@property (nonatomic, copy) NSDecimalNumber *amount;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *side;
@property (nonatomic, copy) NSNumber *tid;

@end

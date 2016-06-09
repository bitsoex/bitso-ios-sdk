//
//  LookupOrderModel.h
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala Zavala on 5/27/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BTSOrderModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *oid;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *_amount;
@property (nonatomic, copy) NSDecimalNumber *amount;

@property (nonatomic, copy) NSString *_price;
@property (nonatomic, copy) NSDecimalNumber *price;

@property (nonatomic, copy) NSDate *created;
@property (nonatomic, copy) NSDate *updated;
@property (nonatomic, copy) NSDate *datetime;



@end

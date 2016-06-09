//
//  UserTransaction.h
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala Zavala on 5/26/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import <Mantle/Mantle.h>

@interface BTSUserTransactionModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSDate *datetime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *oid;
@property (nonatomic, copy) NSNumber *tid;

@property (nonatomic, copy) NSString *_rate;
@property (nonatomic, copy) NSDecimalNumber *rate;

@property (nonatomic, copy) NSString *_mxn;
@property (nonatomic, copy) NSDecimalNumber *mxn;

@property (nonatomic, copy) NSString *_btc;
@property (nonatomic, copy) NSDecimalNumber *btc;

@end

//
//  BalanceModel.h
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala on 5/26/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface BTSBalanceModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *_btc_available;
@property (nonatomic, copy) NSDecimalNumber *btc_available;

@property (nonatomic, copy) NSString *_fee;
@property (nonatomic, copy) NSDecimalNumber *fee;

@property (nonatomic, copy) NSString *_mxn_available;
@property (nonatomic, copy) NSDecimalNumber *mxn_available;

@property (nonatomic, copy) NSString *_btc_balance;
@property (nonatomic, copy) NSDecimalNumber *btc_balance;

@property (nonatomic, copy) NSString *_mxn_reserved;
@property (nonatomic, copy) NSDecimalNumber *mxn_reserved;

@property (nonatomic, copy) NSString *_mxn_balance;
@property (nonatomic, copy) NSDecimalNumber *mxn_balance;

@property (nonatomic, copy) NSString *_btc_reserved;
@property (nonatomic, copy) NSDecimalNumber *btc_reserved;

@end

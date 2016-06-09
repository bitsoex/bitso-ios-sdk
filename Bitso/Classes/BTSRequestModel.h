//
//  RequestModel.h
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala Zavala on 5/16/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <Mantle/MTLModel.h>



@interface BTSRequestModel : MTLModel <MTLJSONSerializing>


@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *nonce;
@property (nonatomic, copy) NSString *signature;


+ (BTSRequestModel *)requestModelWithClientID:(NSString *)_clientID APIKey:(NSString *)_APIKey APISecret:(NSString *)_APISecret;

@end

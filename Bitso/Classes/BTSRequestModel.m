//
//  RequestModel.m
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala on 5/16/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import "BTSRequestModel.h"
#import <CommonCrypto/CommonHMAC.h>

static NSString *nonce;
static NSString *clientID;
static NSString *APIKey;
static NSString *APISecret;

@implementation BTSRequestModel

+ (BTSRequestModel *)requestModelWithClientID:(NSString *)_clientID APIKey:(NSString *)_APIKey APISecret:(NSString *)_APISecret {
    static BTSRequestModel *requestModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestModel = [[self alloc] init];
    });
    
    clientID = _clientID;
    APIKey = _APIKey;
    APISecret = _APISecret;
    return requestModel;
}



#pragma mark - Mantle JSONKeyPathsByPropertyKey

NSString *hmacSHA256(NSString *key, NSString *data)
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < sizeof cHMAC; i++)
    {
        [result appendFormat:@"%02hhx", cHMAC[i]];
    }

    return result;
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
    NSInteger roundedSeconds = round(timeInSeconds);
    nonce = [NSString stringWithFormat:@"%ld", (long)roundedSeconds];
    return @{@"key": @"key",
             @"nonce": @"nonce",
             @"signature": @"signature"};
}


+ (NSValueTransformer *)keyJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *keyString, BOOL *success, NSError *__autoreleasing *error) {
        return keyString;
    } reverseBlock:^id(NSString *keyString, BOOL *success, NSError *__autoreleasing *error) {
        return APIKey;
        
    }];
}

+ (NSValueTransformer *)nonceJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *nonceString, BOOL *success, NSError *__autoreleasing *error) {
        return nonceString;
    } reverseBlock:^id(NSString *nonceString, BOOL *success, NSError *__autoreleasing *error) {
        return nonce;
    }];
}


+ (NSValueTransformer *)signatureJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *sigString, BOOL *success, NSError *__autoreleasing *error) {
        return sigString;
    } reverseBlock:^id(NSString *sigString, BOOL *success, NSError *__autoreleasing *error) {
        NSString *msgConcat = [NSString stringWithFormat:@"%@%@%@", nonce,clientID,APIKey];
        NSString *stringHash = hmacSHA256(APISecret, msgConcat);
        return stringHash;
    }];
}

@end

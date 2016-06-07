//
//  APIManager.h
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala on 5/16/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//


#import <AFNetworking/AFNetworking.h>
#import "BTSTransactionModel.h"
#import "BTSTickerModel.h"
#import "BTSOrderBookModel.h"
#import "BTSBalanceModel.h"
#import "BTSUserTransactionModel.h"
#import "BTSOrderModel.h"
#import "BTSRequestModel.h"


@interface BitsoAPI : AFHTTPSessionManager


@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *APIKey;
@property (nonatomic, copy) NSString *APISecret;


+ (BitsoAPI *)APIWithClientID:(NSString *)_clientID APIKey:(NSString *)_APIKey APISecret:(NSString *)_APISecret;

// Public API Methods

- (NSURLSessionDataTask *)getTickerForBook:(NSString *)book successBlock:(void (^)(BTSTickerModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getOrderBook:(NSString *)book withGrouping:(BOOL)grouping successBlock:(void (^)(BTSOrderBookModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)getTransactionsFromBook:(NSString *)book forTimeRange:(NSString *)time successBlock:(void (^)(NSArray *responseModel))success failureBlock:(void (^)(NSError *error))failure;

// Private API Methods

- (NSURLSessionDataTask *)getBalanceWithSuccessBlock:(void (^)(BTSBalanceModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)getUserTransactionsFromBook:(NSString *)book offset:offset limit:limit sort:sort successBlock:(void (^)(NSArray *responseModel))success failureBlock:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)getOpenOrdersFromBook:(NSString *)book successBlock:(void (^)(NSArray *responseModel))success failureBlock:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)lookupOrderWithOrderID:(NSString *)orderID successBlock:(void (^)(BTSOrderModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)cancelOrderWithOrderID:(NSString *)orderID successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)placeSellOrderInBook:(NSString *)book amount:(NSString *)amount price:(NSString *)price successBlock:(void (^)(BTSOrderModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)placeBuyOrderInBook:(NSString *)book amount:(NSString *)amount price:(NSString *)price successBlock:(void (^)(BTSOrderModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)getBitcoinDepositAddressWithSuccessBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)bitcoinWithdrawalToAddress:(NSString *)address amount:(NSString *)amount successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)rippleWithdrawalOfCurrency:(NSString *)currency toAddress:(NSString *)address amount:(NSString *)amount successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)bankWithdrawalForAmount:(NSString *)amount recipientGivenNames:(NSString *)givenNames familyNames:(NSString *)familyNames clabe:(NSString *)clabe notesRef:(NSString *)notesRef numericRef:(NSString *)numericRef successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure;


@end
//
//  APIManager.h
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala Zavala on 5/16/16.
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

/**
 
 API Usage Example
 
 ## Initialization
 BitsoAPI *bitsoAPI = [BitsoAPI APIWithClientID:CLIENT_ID APIKey:API_KEY APISecret:API_SECRET];
 
 ## Get "btc_mxn" ticker
 
 [bitsoAPI getTickerForBook:@"btc_mxn" successBlock:^(BTSTickerModel *ticker) {
    NSLog(@"Last Price:%@", [ticker.last stringValue])
 } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
 }];
 
 */


@interface BitsoAPI : AFHTTPSessionManager


@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *APIKey;
@property (nonatomic, copy) NSString *APISecret;

/**
 Create a BitsoAPI object for a Client ID, API key, and secret.
*/
+ (BitsoAPI *)APIWithClientID:(NSString *)_clientID APIKey:(NSString *)_APIKey APISecret:(NSString *)_APISecret;

///---------------------
/// Public API Methods
///---------------------

/**
 Get a Bitso price ticker.

 @param book Specifies which order book to use
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a BTSTickerModel as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)getTickerForBook:(NSString *)book successBlock:(void (^)(BTSTickerModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;

/**
 Get a public Bitso order book with a list of all open orders in the specified book
 
 @param book Specifies which order book to use
 @param grouping Specifies if orders with the same price should be grouped
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a BTSOrderBookModel as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)getOrderBook:(NSString *)book withGrouping:(BOOL)grouping successBlock:(void (^)(BTSOrderBookModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;

/**
 Get a list of recent trades from the specified book
 
 @param book Specifies which order book to use
 @param time Time frame for transaction export (“minute” - 1 minute, “hour” - 1 hour)
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a NSArray of BTSTransactionModel objects as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)getTransactionsFromBook:(NSString *)book forTimeRange:(NSString *)time successBlock:(void (^)(NSArray *responseModel))success failureBlock:(void (^)(NSError *error))failure;


///---------------------
/// Private API Methods
///---------------------

/**
 Get a user's balance.
 
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a BTSBalanceModel object as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)getBalanceWithSuccessBlock:(void (^)(BTSBalanceModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;

/**
 Get a list of the user's transactions (deposits, withdrawals, grades)
 
 @param book Specifies which order book to use
 @param offset Skip that many transactions before beginning to return results.
 @param limit Limit result to that many transactions.
 @param sort Sorting by datetime: 'asc', 'desc'
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a NSArray of BTSUserTransactionModel objects as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)getUserTransactionsFromBook:(NSString *)book offset:offset limit:limit sort:sort successBlock:(void (^)(NSArray *responseModel))success failureBlock:(void (^)(NSError *error))failure;


/**
 Get a list of the user's open orders
 
 @param book Specifies which order book to use
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a NSArray of BTSOrderModel objects as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)getOpenOrdersFromBook:(NSString *)book successBlock:(void (^)(NSArray *responseModel))success failureBlock:(void (^)(NSError *error))failure;

/**
 Get details for an order with orderID
 
 @param orderID A Bitso Order ID
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a BTSOrderModel object as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
 */
- (NSURLSessionDataTask *)lookupOrderWithOrderID:(NSString *)orderID successBlock:(void (^)(BTSOrderModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;

/**
 Cancels an open order
 
 @param orderID A Bitso Order ID
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a NSString object as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)cancelOrderWithOrderID:(NSString *)orderID successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure;

/**
 Places a sell order (both limit and market orders are available)
 
 @param book Specifies which order book to use
 @param amount Amount of major currency to buy.
 @param price If supplied, this will place a limit order to sell at the specified price. If not supplied (nil), this will place a market order to sell the amount of major currency specified in amount at the market rate
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a BTSOrderModel object as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)placeSellOrderInBook:(NSString *)book amount:(NSString *)amount price:(NSString *)price successBlock:(void (^)(BTSOrderModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;

/**
 Places a buy order (both limit and market orders are available)
 
 @param book Specifies which order book to use
 @param amount Amount of major currency to buy.
 @param price If supplied, this will place a limit order to buy at the specified price. If not supplied, this will place a market order and spend the amount of minor currency specified in amount to buy major currency at the market rate.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a BTSOrderModel object as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)placeBuyOrderInBook:(NSString *)book amount:(NSString *)amount price:(NSString *)price successBlock:(void (^)(BTSOrderModel *responseModel))success failureBlock:(void (^)(NSError *error))failure;

/**
 Gets a Bitcoin deposit address to fund the user's account
 
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a NSString object (the btc address) as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)getBitcoinDepositAddressWithSuccessBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure;

/**
 Triggers a bitcoin withdrawal from the user's account
 
 @param address The Bitcoin address to send the amount to
 @param amount The amount of BTC to withdraw from the user's account
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a NSString object as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)bitcoinWithdrawalToAddress:(NSString *)address amount:(NSString *)amount successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure;

/**
 Triggers a ripple withdrawal from the user's account
 
 @param currency The ripple currency to withdraw
 @param address The Bitcoin address to send the amount to
 @param amount The amount of BTC to withdraw from the user's account
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a NSString object as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)rippleWithdrawalOfCurrency:(NSString *)currency toAddress:(NSString *)address amount:(NSString *)amount successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure;

/**
 Triggers a SPEI withdrawal from your account. These withdrawals are immediate during banking hours (M-F 9:00AM - 5:00PM Mexico City Time).
 
 @param amount The amount of MXN to withdraw from the user's account
 @param givenNames The recipient's given name(s)
 @param familyNames The recipient's family names
 @param clabe The CLABE number of the bak account where the funds will be sent to
 @param notesRef The alpha-numeric reference number for this SPEI
 @param numericRef The numeric reference for this SPEI
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a NSString object as its arguemt
 @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no terutn value and takes the network or parsing error as its argument
*/
- (NSURLSessionDataTask *)bankWithdrawalForAmount:(NSString *)amount recipientGivenNames:(NSString *)givenNames familyNames:(NSString *)familyNames clabe:(NSString *)clabe notesRef:(NSString *)notesRef numericRef:(NSString *)numericRef successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure;


@end
//
//  APIManager.m
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala Zavala on 5/16/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import "BitsoAPI.h"
#import "Mantle.h"

static NSString *const kBaseURL = @"https://api.bitso.com";

// public endpoints
static NSString *const kTickerPath = @"/v2/ticker";
static NSString *const kTransactionPath = @"/v2/transactions";
static NSString *const kOrderBookPath = @"/v2/order_book";

// private endpoints
static NSString *const kBalancePath = @"/v2/balance";
static NSString *const kUserTransactionPath = @"/v2/user_transactions";
static NSString *const kOpenOrdersPath = @"/v2/open_orders";
static NSString *const kBTCDepositAddressPath = @"/v2/bitcoin_deposit_address";
static NSString *const kLookupOrderPath = @"/v2/lookup_order";
static NSString *const kCancelOrderPath = @"/v2/cancel_order";
static NSString *const kPlaceSellOrderPath = @"/v2/sell";
static NSString *const kPlaceBuyOrderPath = @"/v2/buy";
static NSString *const kBTCWithdrawalPath = @"/v2/bitcoin_withdrawal";
static NSString *const kRippleWithdrawalPath = @"/v2/ripple_withdrawal";
static NSString *const kBankWithdrawalPath = @"/v2/spei_withdrawal";



@implementation BitsoAPI

@synthesize clientID;

- (id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    if(!self) return nil;
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    self.responseSerializer = responseSerializer;
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

+ (BitsoAPI *)APIWithClientID:(NSString *)_clientID APIKey:(NSString *)_APIKey APISecret:(NSString *)_APISecret {

    static BitsoAPI *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[self alloc] init];
    });

    api.clientID = _clientID;    
    api.APIKey = _APIKey;
    api.APISecret = _APISecret;
    return api;

}


- (NSURLSessionDataTask *)getTickerForBook:(NSString *)book successBlock:(void (^)(BTSTickerModel *responseModel))success failureBlock:(void (^)(NSError *error))failure {
    
    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];

    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:book forKey:@"book"];
    return [self GET:kTickerPath parameters:parametersWithKey progress:nil
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                 NSError *error;
                 BTSTickerModel *model = [MTLJSONAdapter modelOfClass:BTSTickerModel.class fromJSONDictionary:responseDictionary error:&error];
                 success(model);
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 failure(error);
             }];
}



- (NSURLSessionDataTask *)getOrderBook:(NSString *)book withGrouping:(BOOL)grouping successBlock:(void (^)(BTSOrderBookModel *responseModel))success failureBlock:(void (^)(NSError *error))failure{
    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];

    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:book forKey:@"book"];
    
    if (grouping) {
        [parametersWithKey setValue:@"1" forKey:@"group"];
    } else {
        [parametersWithKey setValue:@"0" forKey:@"group"];
    }
    return [self GET:kOrderBookPath parameters:parametersWithKey progress:nil
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 
                 NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                 NSError *error;
                 
                 BTSOrderBookModel *model = [MTLJSONAdapter modelOfClass:BTSOrderBookModel.class fromJSONDictionary:responseDictionary error:&error];
                 success(model);
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 failure(error);
             }];
    
}




- (NSURLSessionDataTask *)getTransactionsFromBook:(NSString *)book forTimeRange:(NSString *)time successBlock:(void (^)(NSArray *responseModel))success failureBlock:(void (^)(NSError *error))failure{

    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:book forKey:@"book"];
    [parametersWithKey setValue:time forKey:@"time"];
    return [self GET:kTransactionPath parameters:parametersWithKey progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray *responseArray = (NSArray *)responseObject;
        NSError *error;
        NSArray *list = [MTLJSONAdapter modelsOfClass:BTSTransactionModel.class fromJSONArray:responseArray error:&error];
        success(list);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];
}
    



- (NSURLSessionDataTask *)getBalanceWithSuccessBlock:(void (^)(BTSBalanceModel *responseModel))success failureBlock:(void (^)(NSError *error))failure{
    
    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];

    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    return [self POST:kBalancePath parameters:parametersWithKey progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  
                  NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                  NSLog(@"response dict: %@", responseObject);
                  NSError *error;
                  
                  BTSBalanceModel *model = [MTLJSONAdapter modelOfClass:BTSBalanceModel.class fromJSONDictionary:responseDictionary error:&error];
                  success(model);
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  failure(error);
              }];
    
}



- (NSURLSessionDataTask *)getUserTransactionsFromBook:(NSString *)book offset:offset limit:limit sort:sort successBlock:(void (^)(NSArray *responseModel))success failureBlock:(void (^)(NSError *error))failure{
    
    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:offset forKey:@"offset"];
    [parametersWithKey setValue:limit forKey:@"limit"];
    [parametersWithKey setValue:sort forKey:@"sort"];
    return [self POST:kUserTransactionPath parameters:parametersWithKey progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSArray *responseArray = (NSArray *)responseObject;
                  NSError *error;
                  NSArray *list = [MTLJSONAdapter modelsOfClass:BTSUserTransactionModel.class fromJSONArray:responseArray error:&error];
                  success(list);
                  
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  failure(error);
              }];
}




- (NSURLSessionDataTask *)getOpenOrdersFromBook:(NSString *)book successBlock:(void (^)(NSArray *responseModel))success failureBlock:(void (^)(NSError *error))failure{
    
    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];

    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:book forKey:@"book"];
    return [self POST:kOpenOrdersPath parameters:parametersWithKey progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSArray *responseArray = (NSArray *)responseObject;
                  NSError *error;
                  NSArray *list = [MTLJSONAdapter modelsOfClass:BTSOrderModel.class fromJSONArray:responseArray error:&error];
                  success(list);
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  failure(error);
              }];
}

- (NSURLSessionDataTask *)lookupOrderWithOrderID:(NSString *)orderID successBlock:(void (^)(BTSOrderModel *responseModel))success failureBlock:(void (^)(NSError *error))failure{
    
  
    
    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];

    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:orderID forKey:@"id"];
    return [self POST:kLookupOrderPath parameters:parametersWithKey progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSArray *responseArray = (NSArray *)responseObject;
                  NSError *error;
                  
                  BTSOrderModel *model = [MTLJSONAdapter modelOfClass:BTSOrderModel.class fromJSONDictionary:[responseArray objectAtIndex:0] error:&error];
                  success(model);
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  failure(error);
              }];
}



- (NSURLSessionDataTask *)cancelOrderWithOrderID:(NSString *)orderID successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure{
    


    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];

    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:orderID forKey:@"id"];
    return [self POST:kCancelOrderPath parameters:parametersWithKey progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSString *successmsg = responseObject;
                  success(successmsg);
                  
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"btc deposit error here");
                  failure(error);
              }];
}


- (NSURLSessionDataTask *)placeSellOrderInBook:(NSString *)book amount:(NSString *)amount price:(NSString *)price successBlock:(void (^)(BTSOrderModel *responseModel))success failureBlock:(void (^)(NSError *error))failure{
    
    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];

    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:book forKey:@"book"];
    [parametersWithKey setValue:price forKey:@"price"];
    [parametersWithKey setValue:amount forKey:@"amount"];
    return [self POST:kPlaceSellOrderPath parameters:parametersWithKey progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                  NSError *error;
                  
                  BTSOrderModel *model = [MTLJSONAdapter modelOfClass:BTSOrderModel.class fromJSONDictionary:responseDictionary error:&error];
                  success(model);
                  
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  failure(error);
              }];
    
    
    
}

- (NSURLSessionDataTask *)placeBuyOrderInBook:(NSString *)book amount:(NSString *)amount price:(NSString *)price successBlock:(void (^)(BTSOrderModel *responseModel))success failureBlock:(void (^)(NSError *error))failure{
    
    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];

    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:book forKey:@"book"];
    [parametersWithKey setValue:price forKey:@"price"];
    [parametersWithKey setValue:amount forKey:@"amount"];
    return [self POST:kPlaceBuyOrderPath parameters:parametersWithKey progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                  NSError *error;
                  
                  BTSOrderModel *model = [MTLJSONAdapter modelOfClass:BTSOrderModel.class fromJSONDictionary:responseDictionary error:&error];
                  success(model);
                  
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  failure(error);
              }];
    
}

- (NSURLSessionDataTask *)getBitcoinDepositAddressWithSuccessBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure{

    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];
    
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    return [self POST:kBTCDepositAddressPath parameters:parametersWithKey progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSString *btcaddress = responseObject;
                  success(btcaddress);
                  
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"BitcoinDeposit error: %@", error);
                  failure(error);
              }];
}


- (NSURLSessionDataTask *)rippleWithdrawalOfCurrency:(NSString *)currency toAddress:(NSString *)address amount:(NSString *)amount successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure{

    
    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];

    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:currency forKey:@"currency"];
    [parametersWithKey setValue:address forKey:@"address"];
    [parametersWithKey setValue:amount forKey:@"amount"];
    return [self POST:kRippleWithdrawalPath parameters:parametersWithKey progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSString *successmsg = responseObject;
                  success(successmsg);
                  
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  failure(error);
              }];
}




- (NSURLSessionDataTask *)bitcoinWithdrawalToAddress:(NSString *)address amount:(NSString *)amount successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure{


    
    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];

    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:address forKey:@"address"];
    [parametersWithKey setValue:amount forKey:@"amount"];
    return [self POST:kBTCWithdrawalPath parameters:parametersWithKey progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSString *successmsg = responseObject;
                  success(successmsg);
                  
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  failure(error);
              }];
}





- (NSURLSessionDataTask *)bankWithdrawalForAmount:(NSString *)amount recipientGivenNames:(NSString *)givenNames familyNames:(NSString *)familyNames clabe:(NSString *)clabe notesRef:(NSString *)notesRef numericRef:(NSString *)numericRef successBlock:(void (^)(NSString *responseModel))success failureBlock:(void (^)(NSError *error))failure{
    

    BTSRequestModel *requestModel = [BTSRequestModel requestModelWithClientID:self.clientID APIKey:self.APIKey APISecret:self.APISecret];

    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametersWithKey setValue:amount forKey:@"amount"];
    [parametersWithKey setValue:givenNames forKey:@"recipient_given_names"];
    [parametersWithKey setValue:familyNames forKey:@"recipient_family_names"];
    [parametersWithKey setValue:clabe forKey:@"clabe"];
    [parametersWithKey setValue:notesRef forKey:@"notes_ref"];
    [parametersWithKey setValue:numericRef forKey:@"numeric_ref"];
    return [self POST:kBankWithdrawalPath parameters:parametersWithKey progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSString *successmsg = responseObject;
                  success(successmsg);
                  
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  failure(error);
              }];

    
    
}



@end
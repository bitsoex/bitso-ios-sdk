//
//  BitsoTests.m
//  BitsoTests
//
//  Created by Mario Romero Zavala on 06/07/2016.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

// https://github.com/Specta/Specta


SpecBegin(InitialSpecs)

NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
NSString *kClientID = [info objectForKey:@"CLIENT_ID"];
NSString *kApiKey = [info objectForKey:@"API_KEY"];
NSString *kApiSecret = [info objectForKey:@"API_SECRET"];

describe(@"public API tests", ^{
    BitsoAPI *bitsoAPI = [BitsoAPI APIWithClientID:@"" APIKey:@"" APISecret:@""];
    
    beforeAll(^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.path isEqualToString:@"/v2/ticker"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"ticker.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];

        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.path isEqualToString:@"/v2/order_book"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"orderbook.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.path isEqualToString:@"/v2/transactions"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"transactions.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];

    });
    
    it(@"will get ticker", ^{
        waitUntil(^(DoneCallback done) {
            [bitsoAPI getTickerForBook:@"btc_mxn" successBlock:^(BTSTickerModel *ticker) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    expect(ticker.volume).to.beInstanceOf([NSDecimalNumber class]);
                    expect(ticker.volume).to.equal(22.31349615);
                    expect(ticker.high).to.equal(5750.00);
                    expect(ticker.last).to.equal(5633.98);
                    expect(ticker.low).to.equal(5450.00);
                    expect(ticker.vwap).to.equal(5393.45);
                    expect(ticker.ask).to.equal(5632.24);
                    expect(ticker.bid).to.equal(5520.01);
                    expect(ticker.date).to.beKindOf([NSDate class]);
                    done();
                });
            } failureBlock:^(NSError *error) {
                failure(@"Ticker Error");
            }];
        });
    });
    
    
    it(@"will get order book", ^{
        waitUntil(^(DoneCallback done) {
            [bitsoAPI getOrderBook:@"btc_mxn" withGrouping:YES successBlock:^(BTSOrderBookModel *orderbook) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    expect(orderbook.asks[0][0]).to.beKindOf([NSDecimalNumber class]);
                    expect(orderbook.asks[0][0]).to.equal(@5632.24);
                    expect(orderbook.asks[0][1]).to.equal(@1.34491802);
                    expect(orderbook.asks[1][0]).to.equal(@5632.25);
                    expect(orderbook.asks[1][1]).to.equal(@1.00000000);
                    done();
                });
            } failureBlock:^(NSError *error) {
                failure(@"Orderbook Error");
            }];
            
        });
    });
    
    
    it(@"will get transactions", ^{
        waitUntil(^(DoneCallback done) {
            [bitsoAPI getTransactionsFromBook:@"btc_mxn" forTimeRange:@"hour" successBlock:^(NSArray *trades) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    expect(trades[0]).to.beKindOf([BTSTransactionModel class]);
                    BTSTransactionModel *trade = trades[0];
                    expect(trade.amount).to.beKindOf([NSDecimalNumber class]);
                    expect(trade.amount).to.equal(0.02000000);
                    expect(trade.date).to.beKindOf([NSDate class]);
                    expect(trade.tid).to.equal(55845);
                    expect(trade.price).to.equal(5545.01);
                    done();
                });
            } failureBlock:^(NSError *error) {
                failure(@"Transactions Error");
            }];
            
        });
    });
    afterAll(^{
        [OHHTTPStubs removeAllStubs];
    });
    
});

describe(@"private API tests", ^{
    
    BitsoAPI *bitsoAPI = [BitsoAPI APIWithClientID:kClientID APIKey:kApiKey APISecret:kApiSecret];
    
    beforeAll(^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.path isEqualToString:@"/v2/balance"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"balance.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];

        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.path isEqualToString:@"/v2/user_transactions"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"usertransactions.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];

        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.path isEqualToString:@"/v2/open_orders"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"openorders.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];

        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.path isEqualToString:@"/v2/lookup_order"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"lookuporder.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        
    });
    
    it(@"will get balance", ^{
        waitUntil(^(DoneCallback done) {
            [bitsoAPI getBalanceWithSuccessBlock:^(BTSBalanceModel *balance) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    expect(balance.btc_balance).to.beInstanceOf([NSDecimalNumber class]);
                    expect(balance.btc_balance).to.equal(46.67902107);
                    expect(balance.btc_available).to.equal(46.67902107);
                    expect(balance.btc_reserved).to.equal(0.00);
                    expect(balance.mxn_balance).to.equal(26864.57);
                    expect(balance.mxn_available).to.equal(26864.57);
                    expect(balance.mxn_reserved).to.equal(0.00);
                    expect(balance.fee).to.equal(1.0000);
                    done();
                });
            } failureBlock:^(NSError *error) {
                failure(@"Balance Error");
            }];
        });
    });

    it(@"will get user transactions", ^{
        waitUntil(^(DoneCallback done) {
            [bitsoAPI getUserTransactionsFromBook:@"btc_mxn" offset:nil limit:nil sort:nil successBlock:^(NSArray *utxs) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    expect(utxs[0]).to.beKindOf([BTSUserTransactionModel class]);
                    BTSUserTransactionModel *btcDeposit = utxs[0];
                    expect(btcDeposit.btc).to.beKindOf([NSDecimalNumber class]);
                    expect(btcDeposit.btc).to.equal(0.48650929);
                    expect(btcDeposit.method).to.equal(@"Bitcoin");
                    expect(btcDeposit.type).to.equal(@"Deposit");
                    expect(btcDeposit.datetime).to.beKindOf([NSDate class]);
                    
                    BTSUserTransactionModel *mxnWithdrawal = utxs[1];
                    expect(mxnWithdrawal.mxn).to.beKindOf([NSDecimalNumber class]);
                    expect(mxnWithdrawal.mxn).to.equal(-1800.15);
                    expect(mxnWithdrawal.method).to.equal(@"SPEI Transfer");
                    expect(mxnWithdrawal.type).to.equal(@"Withdrawal");
                    expect(mxnWithdrawal.datetime).to.beKindOf([NSDate class]);
                    
                    BTSUserTransactionModel *trade = utxs[2];
                    expect(trade.mxn).to.beKindOf([NSDecimalNumber class]);
                    expect(trade.mxn).to.equal(1023.77);
                    expect(trade.btc).to.beKindOf([NSDecimalNumber class]);
                    expect(trade.btc).to.equal(-0.25232073);
                    expect(trade.rate).to.beKindOf([NSDecimalNumber class]);
                    expect(trade.rate).to.equal(4057.45);
                    expect(trade.tid).to.equal(51756);
                    expect(trade.type).to.equal(@"Trade");
                    expect(trade.datetime).to.beKindOf([NSDate class]);
                    
                    done();
                });
            } failureBlock:^(NSError *error) {
                failure(@"User Transactions Error");
            }];
        });
    });
    
    it(@"will get open orders", ^{
        waitUntil(^(DoneCallback done) {
            [bitsoAPI getOpenOrdersFromBook:@"btc_mxn" successBlock:^(NSArray *orders) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    expect(orders[0]).to.beKindOf([BTSOrderModel class]);
                    BTSOrderModel *order = orders[0];
                    expect(order.oid).to.equal(@"543cr2v32a1h684430tvcqx1b0vkr93wd694957cg8umhyrlzkgbaedmf976ia3v");
                    expect(order.amount).to.beKindOf([NSDecimalNumber class]);
                    expect(order.amount).to.equal(0.01000000);
                    expect(order.datetime).to.beKindOf([NSDate class]);
                    expect(order.price).to.equal(5600.00);
                    done();
                });
            } failureBlock:^(NSError *error) {
                failure(@"Open Orders Error");
            }];
            
        });
    });

    
    it(@"will get lookup order", ^{
        waitUntil(^(DoneCallback done) {
            [bitsoAPI lookupOrderWithOrderID:@"123" successBlock:^(BTSOrderModel *order) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    expect(order.oid).to.equal(@"543cr2v32a1h684430tvcqx1b0vkr93wd694957cg8umhyrlzkgbaedmf976ia3v");
                    expect(order.amount).to.beKindOf([NSDecimalNumber class]);
                    expect(order.amount).to.equal(0.01000000);
                    expect(order.created).to.beKindOf([NSDate class]);
                    expect(order.price).to.equal(5600.00);
                    done();
                });
            } failureBlock:^(NSError *error) {
                failure(@"Lookup Order Error");
                
            }];
            
        });
    });
    
        
    
    afterAll(^{
        [OHHTTPStubs removeAllStubs];
    });
    
});





SpecEnd


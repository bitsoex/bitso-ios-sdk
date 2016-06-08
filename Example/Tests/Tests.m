//
//  BitsoTests.m
//  BitsoTests
//
//  Created by Mario Romero on 06/07/2016.
//  Copyright (c) 2016 Mario Romero. All rights reserved.
//

// https://github.com/Specta/Specta

//#import "BitsoAPI.h"




SpecBegin(InitialSpecs)


describe(@"public API tests", ^{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *kClientID = [info objectForKey:@"CLIENT_ID"];
    NSString *kApiKey = [info objectForKey:@"API_KEY"];
    NSString *kApiSecret = [info objectForKey:@"API_SECRET"];
    BitsoAPI *bitsoAPI = [BitsoAPI APIWithClientID:kClientID APIKey:kApiKey APISecret:kApiSecret];
    
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
                    expect(orderbook.asks[0][0]).to.beKindOf([NSString class]);
                    expect(orderbook.asks[0][0]).to.equal(@"5632.24"); // FIX: should be a nsdecimalnumber
                    expect(orderbook.asks[0][1]).to.equal(@"1.34491802"); // FIX: should be a nsdecimalnumber
                    expect(orderbook.asks[1][0]).to.equal(@"5632.25"); // FIX: should be a nsdecimalnumber
                    expect(orderbook.asks[1][1]).to.equal(@"1.00000000"); // FIX: should be a nsdecimalnumber
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
                failure(@"Transactinos Error");
            }];
            
        });
    });
    
    afterAll(^{
        [OHHTTPStubs removeAllStubs];
    });
    
});

describe(@"these will pass", ^{
    
    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });
    
    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
    
    it(@"will wait and succeed", ^{
        waitUntil(^(DoneCallback done) {
            done();
        });
    });
});

SpecEnd


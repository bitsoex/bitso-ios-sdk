# Bitso - *ARCHIVED*

This repository is no longer being maintained.

***


[![Version](https://img.shields.io/cocoapods/v/Bitso.svg?style=flat)](http://cocoapods.org/pods/Bitso)
[![License](https://img.shields.io/cocoapods/l/Bitso.svg?style=flat)](http://cocoapods.org/pods/Bitso)
[![Platform](https://img.shields.io/cocoapods/p/Bitso.svg?style=flat)](http://cocoapods.org/pods/Bitso)

## Bitso Credentials
From a terminal:
  - cd directory
  - Pod install
  - export CLIENT_ID=YOUR_CLIENT_ID
  - export API_KEY=YOUR_API_KEY
  - export API_SECRET=YOUR_API_SECRET
  - open -a xcode
  - From Xcode, open Bitso.xcworkspace
  


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Bitso is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Bitso"
```

## API Usage
```objective-c
BitsoAPI *bitsoAPI = [BitsoAPI APIWithClientID:CLIENT_ID APIKey:API_KEY APISecret:API_SECRET];
```

### Public Endpoints

#### Ticker
```objective-c
[bitsoAPI getTickerForBook:@"btc_mxn" successBlock:^(BTSTickerModel *ticker) {
    NSLog(@"Last Price:%@", [ticker.last stringValue])
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```
#### Transactions
```objective-c
[bitsoAPI getTransactionsFromBook:@"btc_mxn" forTimeRange:@"hour" successBlock:^(NSArray *trades) {
    for (BitsoTrade* trade in trades) {
      NSLog(@"amount:%@, side:%@, price:%@", [trade.amount stringValue], trade.side, [trade.price stringValue]);
    }
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Order Book

```objective-c
[bitsoAPI getOrderBook:@"btc_mxn" withGrouping:YES successBlock:^(BTSOrderBookModel *orderbook) {
    for (NSArray *ask in orderbook.asks) {
      NSLog(@"%@ @ %@", [ask[1] stringValue], [ask[0] stringValue]);
    }
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

### Private Endpoints

#### Balance
```objective-c
[bitsoAPI getBalanceWithSuccessBlock:^(BTSBalanceModel *balance) {
    NSLog(@"BTC balance:%@", [balance.btc_balance stringValue]);
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### User Transactions
```objective-c
[bitsoAPI getUserTransactionsFromBook:@"btc_mxn" offset:nil limit:nil sort:nil successBlock:^(NSArray *utxs) {
    for (BitsoUserTransaction* transaction in utxs) {
      NSLog(@"datetime:%@", [transaction.datetime stringValue]);
    }
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Open Orders
```objective-c
[bitsoAPI getOpenOrdersFromBook:@"btc_mxn" successBlock:^(NSArray *orders) {
    for (BTSOrderModel *order in orders) {
      NSLog(@"oid:%@", transaction.oid);
    }
  } failureBlock:^(NSError *error) {
      NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Lookup Order
```objective-c
[bitsoAPI lookupOrderWithOrderID:ORDER_ID successBlock:^(BTSOrderModel *order) {
    NSLog(@"price:%@, amount:%@", [order.price stringValue], [order.amount stringValue]);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Cancel Order
```objective-c
[bitsoAPI  cancelOrderWithOrderID:ORDER_ID successBlock:^(NSString *response) {
    NSLog(@"%@", response);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Place Buy Order
```objective-c
[bitsoAPI  placeBuyOrderInBook:BOOK
                        amount:AMOUNT
                         price:PRICE
                  successBlock:^(BTSOrderModel *order) {
      NSLog(@"price:%@, amount:%@", [order.price stringValue], [order.amount stringValue]);
} failureBlock:^(NSError *error) {
      NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Place Sell Order
```objective-c
[bitsoAPI  placeSellOrderInBook:BOOK
                         amount:AMOUNT
                          price:PRICE
                   successBlock:^(BTSOrderModel *order) {
      NSLog(@"price:%@, amount:%@", [order.price stringValue], [order.amount stringValue]);
} failureBlock:^(NSError *error) {
      NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Get Bitcoin deposit address
```objective-c
[bitsoAPI getBitcoinDepositAddressWithSuccessBlock:^(NSString *response) {
    NSLog("%@", response);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Bitcoin withdrawal
```objective-c
[bitsoAPI bitcoinWithdrawalToAddress:ADDRESS amount:AMOUNT successBlock:^(NSString *response) {
    NSLog("%@", response);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Ripple withdrawal
```objective-c
[bitsoAPI rippleWithdrawalOfCurrency:CURRENCY toAddress:ADDRESS amount:AMOUNT successBlock:^(NSString *response) {
    NSLog("%@", response);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Bank withdrawal
```objective-c
[bitsoAPI bankWithdrawalForAmount:AMOUNT recipientGivenNames:GIVEN_NAMES familyNames:FAMILY_NAMES clabe:CLABE_SPEI notesRef:@"" numericRef:@"" successBlock:^(NSString *response) {
    NSLog("%@", response);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```


# Models #

The SDK uses the following models to represent data structures returned by the Bitso API. 

### BTSTickerModel
Atribute | Type | Description | Units
------------ | ------------- | ------------- | -------------
ask | NSDecimalNumber | Lowest sell order | Minor/Major
bid | NSDecimalNumber | Highest buy order | Minor/Major
last | NSDecimalNumber | Last traded price | Minor/Major
high | NSDecimalNumber | Last 24 hours price high | Minor/Major
low | NSDecimalNumber | Last 24 hours price low | Minor/Major
vwap | NSDecimalNumber | Last 24 hours price high | Minor/Major
volume | NSDecimalNumber | Last 24 hours volume | Major
date | NSDate | Ticker current datetime | 


### BTSOrderBookModel
Atribute | Type | Description | Units
------------ | ------------- | ------------- | -------------
asks | NSArray | Array of open asks | Minor/Major
bids | NSArray | Array of open bids | Minor/Major
date | NSDate | OrderBook current datetime | 


### BTSBalanceModel
Atribute | Type | Description | Units
------------ | ------------- | ------------- | -------------
btc_balance | NSDecimalNumber | BTC balance | BTC
btc_available | NSDecimalNumber | BTC available for trading (balance - reserved) | BTC
btc_reserved | NSDecimalNumber | BTC locked in open orders | BTC
mxn_balance | NSDecimalNumber | MXN balance | MXN
mxn_available | NSDecimalNumber | MXN available for trading (balance - reserved) | MXN
mxn_reserved | NSDecimalNumber | MXN locked in open orders | MXN
fee | NSDecimalNumber | NSDecimalNumber trading fee as a percentage | 


### BTSTransactionModel
Atribute | Type | Description | Units
------------ | ------------- | ------------- | -------------
tid | NSNumber | Transaction ID | 
amount | NSDecimalNumber | Major amount transacted | Major
price | NSDecimalNumber | Price per unit of major | Minor
side | NSString | Indicates the maker order side (maker order is the order that was open on the order book) | 
date | NSDate | Date/Time for this trade


### BTSUserTransactionModel
Atribute | Type | Description | Units
------------ | ------------- | ------------- | -------------
tid | NSNumber | Unique identifier (only for trades) | 
method | NSString | Transaction type ('deposit', 'withdrawal', 'trade') |
oid | NSString | A 64 character long hexadecimal string representing the order that was fully or partially filled (only for trades) | 
rate | NSDecimalNumber | Price per minor (only for trades) | Minor
datetime | NSDate | Date and time | 
(minor currency code) | NSDecimalNumber | The minor currency amount | Minor
(major currency code) | NSDecimalNumber | The major currency amount | Major 


### BTSOrderModel

Atribute | Type | Description | Units
------------ | ------------- | ------------- | -------------
oid | NSString | The Order ID | 
type | NSString | Order Type ('buy','sell') | 
book | NSString | Which orderbook the order belongs to (not shown when status = 0) | 
amount | NSDecimalNumber | The order’s major currency amounts | Major
price | NSDecimalNumber | The order’s price | Minor
status | NSString | The order’s status ('cancelled', 'active','partially filled', 'complete') | 
datetime | NSDate | The date the order was created | 
updated | NSDate | The date the order was last updated (not shown when status = 0) | 


## Author

Mario Romero, mario@bitso.com

Copyright © 2016 Bitso SAPI de CV. All rights reserved.

## License

Bitso is available under the MIT license. See the LICENSE file for more info.

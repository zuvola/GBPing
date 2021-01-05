//
//  GBPingTests.m
//  GBPingTests
//
//  Created by LinJiang on 7/29/15.
//  Copyright (c) 2015 Goonbee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GBPing.h"

@interface GBPingTests : XCTestCase <GBPingDelegate>

@property (nonatomic, strong) GBPing *ping;

@end

@implementation GBPingTests

- (void)setUp {
    [super setUp];

    self.ping = [[GBPing alloc] init];
    self.ping.host = @"google.com";
    self.ping.delegate = self;
    self.ping.timeout = 1.0;
    self.ping.pingPeriod = 0.9;
    //self.ping.useIpv6 = NO;
}

- (void)tearDown {
    [super tearDown];
    
    self.ping.delegate = nil;
    self.ping = nil;
}

- (void)testPing {
    XCTestExpectation *exp = [self expectationWithDescription:@"ping Async timeout. "];
    
    [self.ping setupWithBlock:^(BOOL success, NSError *error) { //necessary to resolve hostname
        if (success) {
            //start pinging
            [self.ping startPinging];
            
            //stop it after 5 seconds
            NSTimeInterval stopSecond = 5.f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(stopSecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"Stop ping .");
                [self.ping stop];
                self.ping = nil;
                
                [exp fulfill];
            });
            
        }
        else {
            NSLog(@"failed to start");
        }
    }];
    
    NSTimeInterval waitTimeoutSecond = 10.f;
    [self waitForExpectationsWithTimeout:waitTimeoutSecond handler:^(NSError *error) {
        if (!error) {
            NSLog(@"********* Test Succeed .");
        } else {
            NSLog(@"********* Test Error : %@", error);
        }
    }];
}

- (void)ping:(GBPing *)pinger didFailWithError:(NSError *)error {
    NSLog(@"********* didFailWithError : %@", error);
}

- (void)ping:(GBPing *)pinger didSendPingWithSummary:(GBPingSummary *)summary {
    NSLog(@"********* didSendPingWithSummary : %@", summary);
}

- (void)ping:(GBPing *)pinger didFailToSendPingWithSummary:(GBPingSummary *)summary error:(NSError *)error {
    NSLog(@"********* didFailToSendPingWithSummary : %@", error);
}

- (void)ping:(GBPing *)pinger didTimeoutWithSummary:(GBPingSummary *)summary {
    NSLog(@"********* didTimeoutWithSummary : %@", summary);
}

- (void)ping:(GBPing *)pinger didReceiveReplyWithSummary:(GBPingSummary *)summary {
    
    NSLog(@"********* didReceiveReplyWithSummary : %@", summary);
}

- (void)ping:(GBPing *)pinger didReceiveUnexpectedReplyWithSummary:(GBPingSummary *)summary {
    NSLog(@"********* didReceiveUnexpectedReplyWithSummary : %@", summary);
    
}

@end

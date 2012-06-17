//
//  PCCommandStation.h
//  ITCommandStationTests
//
//  Created by Patrick Perini on 6/16/12.
//  Copyright (c) 2012 Inspyre Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PCCommandStation;

#pragma mark - Delegate
@protocol PCCommandStationDelegate <NSObject>

@required
- (void)commandStation:(PCCommandStation *)commandStation changedUserToActiveState:(BOOL)userIsActive;

@end

@interface PCCommandStation : NSObject

#pragma mark - Properties
@property NSTimeInterval maximumIdleDuration;
@property NSTimeInterval intervalBetweenIdleChecks;
@property id<PCCommandStationDelegate> delegate;
@property (copy) void(^callbackBlock)(BOOL userIsActive);

#pragma mark - Initializers
- (id)initWithCallbackBlock:(void (^)(BOOL))aBlock;
- (id)initWithCallbackBlock:(void (^)(BOOL))aBlock maximumIdleDuration:(NSTimeInterval)idleDuration;
- (id)initWithCallbackBlock:(void (^)(BOOL))aBlock maximumIdleDuration:(NSTimeInterval)idleDuration intervalBetweenIdleChecks:(NSTimeInterval)interval;

- (id)initWithDelegate:(id<PCCommandStationDelegate>)aDelegate;
- (id)initWithDelegate:(id<PCCommandStationDelegate>)aDelegate maximumIdleDuration:(NSTimeInterval)idleDuration;
- (id)initWithDelegate:(id<PCCommandStationDelegate>)aDelegate maximumIdleDuration:(NSTimeInterval)idleDuration intervalBetweenIdleChecks:(NSTimeInterval)interval;

#pragma mark - Accessors and Mutators
- (BOOL)isEnabled;
- (void)setEnabled:(BOOL)enabled;

@end

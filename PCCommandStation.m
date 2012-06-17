//
//  PCCommandStation.m
//  ITCommandStationTests
//
//  Created by Patrick Perini on 6/16/12.
//  Copyright (c) 2012 Inspyre Technologies. All rights reserved.
//

#import "PCCommandStation.h"

#pragma mark - Internal Constants
NSString *const PCCommandStationEnabledKey = @"PCCommandStationEnabled";

NSTimeInterval const PCCommandStationDefaultMaximumIdleDuration = (5 * 60);
NSTimeInterval const PCCommandStationDefaultIntervalBetweenIdleChecks = 10;

@interface PCCommandStation ()

#pragma mark - Internal Responders
- (void)workspaceWillChangeSleepState:(NSNotification *)notification;
- (void)userWillChangeActiveState:(BOOL)newState;

#pragma mark - Internal Activators
- (void)startWatchingActivity;

@end

@implementation PCCommandStation

#pragma mark - Properties
@synthesize maximumIdleDuration;
@synthesize intervalBetweenIdleChecks;
@synthesize delegate;
@synthesize callbackBlock;

#pragma mark - Initializers
- (id)initWithCallbackBlock:(void (^)(BOOL))aBlock
{
    return [self initWithCallbackBlock: aBlock
                   maximumIdleDuration: PCCommandStationDefaultMaximumIdleDuration
             intervalBetweenIdleChecks: PCCommandStationDefaultIntervalBetweenIdleChecks];
}

- (id)initWithCallbackBlock:(void (^)(BOOL))aBlock maximumIdleDuration:(NSTimeInterval)idleDuration
{
    return [self initWithCallbackBlock: aBlock
                   maximumIdleDuration: idleDuration
             intervalBetweenIdleChecks: PCCommandStationDefaultIntervalBetweenIdleChecks];
}

- (id)initWithCallbackBlock:(void (^)(BOOL))aBlock maximumIdleDuration:(NSTimeInterval)idleDuration intervalBetweenIdleChecks:(NSTimeInterval)interval
{
    self = [self init];
    if (!self)
        return nil;
    
    callbackBlock = aBlock;
    maximumIdleDuration = idleDuration;
    intervalBetweenIdleChecks = interval;
    delegate = nil;
    
    [self startWatchingActivity];
    
    return self;
}

- (id)initWithDelegate:(id<PCCommandStationDelegate>)aDelegate
{
    return [self initWithDelegate: aDelegate
              maximumIdleDuration: PCCommandStationDefaultMaximumIdleDuration
        intervalBetweenIdleChecks: PCCommandStationDefaultIntervalBetweenIdleChecks];
}

- (id)initWithDelegate:(id<PCCommandStationDelegate>)aDelegate maximumIdleDuration:(NSTimeInterval)idleDuration
{
    return [self initWithDelegate: aDelegate
              maximumIdleDuration: idleDuration
        intervalBetweenIdleChecks: PCCommandStationDefaultIntervalBetweenIdleChecks];
}

- (id)initWithDelegate:(id<PCCommandStationDelegate>)aDelegate maximumIdleDuration:(NSTimeInterval)idleDuration intervalBetweenIdleChecks:(NSTimeInterval)interval
{
    self = [self init];
    if (!self)
        return nil;
    
    callbackBlock = nil;
    maximumIdleDuration = idleDuration;
    intervalBetweenIdleChecks = interval;
    delegate = aDelegate;
    
    [self startWatchingActivity];
    
    return self;
}

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    [self setEnabled: YES];
    
    return self;
}

#pragma mark - Deallocators
- (void)dealloc
{
    [self setEnabled: NO];
}

#pragma mark - Accessors and Mutators
- (BOOL)isEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey: PCCommandStationEnabledKey];
}

- (void)setEnabled:(BOOL)enabled
{
    if (enabled != [self isEnabled])
    {
        [[NSUserDefaults standardUserDefaults] setBool: enabled
                                                forKey: PCCommandStationEnabledKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (enabled)
    {
        // Application Idle Events
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(workspaceWillChangeSleepState:)
                                                     name: NSApplicationWillTerminateNotification
                                                   object: nil];
        
        // Workspace Idle Events
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                               selector: @selector(workspaceWillChangeSleepState:)
                                                                   name: NSWorkspaceWillSleepNotification 
                                                                 object: nil];
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                               selector: @selector(workspaceWillChangeSleepState:)
                                                                   name: NSWorkspaceWillPowerOffNotification
                                                                 object: nil];
        
        // Screen Idle Events
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                               selector: @selector(workspaceWillChangeSleepState:)
                                                                   name: NSWorkspaceScreensDidSleepNotification
                                                                 object: nil];
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                               selector: @selector(workspaceWillChangeSleepState:)
                                                                   name: NSWorkspaceScreensDidWakeNotification
                                                                 object: nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver: self];
        [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver: self];
    }
}

#pragma mark - Responders
- (void)workspaceWillChangeSleepState:(NSNotification *)notification
{
    if (![self isEnabled])
        return;
    
    NSArray *sleepNotifications = [NSArray arrayWithObjects:
        NSApplicationWillTerminateNotification,
        NSWorkspaceWillSleepNotification,
        NSWorkspaceWillPowerOffNotification,
        NSWorkspaceScreensDidSleepNotification,
        nil
    ];
    
    BOOL userIsActive = [sleepNotifications containsObject: notification.name];
    [self userWillChangeActiveState: userIsActive];
}

- (void)userWillChangeActiveState:(BOOL)newState
{
    if (!delegate && !callbackBlock)
    {
        @throw [NSException exceptionWithName: NSInvalidArgumentException
                                       reason: @"PCCommandStation: Either delegate or callbackBlock must not be nil."
                                     userInfo: nil];
    }
    
    if (delegate)
    {
        [delegate commandStation: self
        changedUserToActiveState: newState];
    }
    
    if (callbackBlock)
    {
        callbackBlock(newState);
    }
}

#pragma mark - Activators
- (void)startWatchingActivity
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^()
    {
        while (YES)
        {
            CFTimeInterval secondsSinceLastUserInteraction = CGEventSourceSecondsSinceLastEventType(kCGEventSourceStateHIDSystemState, kCGAnyInputEventType);
            
            dispatch_async(dispatch_get_main_queue(), ^()
            {
                BOOL userIsActive = secondsSinceLastUserInteraction >= maximumIdleDuration;
                [self userWillChangeActiveState: userIsActive];
            });
            
            sleep(intervalBetweenIdleChecks);
        }
    });
}

@end

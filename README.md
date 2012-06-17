#PCCommandStation#

Declared In:      PCCommandStation.h


##Overview##

`PCCommandStation` allows OS X apps to monitor whether or not users are actively using the device, and establish responders for when users are no longer actively engaged with the system. This concept is best understood through the example of its intended use: notifications. If the user is currently using their laptop, notifications come through to their laptop, but not their iPhone. If they are _not_ using their laptop, notifications push through to their iPhone. 

##Tasks##

###Creating Command Stations###
    - initWithCallbackBlock:
    - initWithCallbackBlock:maximumIdleDuration:
    - initWithCallbackBlock:maximumIdleDuration:intervalBetweenIdleChecks:
    - initWithDelegate:
    - initWithDelegate:maximumIdleDuration:
    - initWithDelegate:maximumIdleDuration:intervalBetweenIdleChecks:

###Enabling Command Stations###
    - isEnabled
    - setEnabled:
    
###Accessing Command Station Properties###
    maximumIdleDuration (property)
    intervalBetweenIdleChecks (property)
    delegate (property)
    callbackBlock (property)

##Properties##

**maximumIdleDuration**

>The amount of a time a user can be idle before being considered inactive.

    NSTimeInterval maximumIdleDuration

>*Discussion:*

>> Defaults to a 5 minute interval.

**intervalBetweenIdleChecks**

>The amount of a time to wait before checking the user's activity state again.

    NSTimeInterval intervalBetweenIdleChecks

>*Discussion:*

>Defaults to a 10 second interval.

**delegate**

>Delegate object called when a user's activity state changes.

    id<PCCommandStationDelegate> delegate
    
**callbackBlock**

>A block to be invoked when a user's activity state changes.

    void(^callbackBlock)(BOOL userIsActive)

##Instance Methods##

**initWithCallbackBlock:**

**initWithCallbackBlock:maximumIdleDuration:**

**initWithCallbackBlock:maximumIdleDuration:intervalBetweenIdleChecks**

>Initializes a `PCCommandStation` object.

    - (id)initWithCallbackBlock:(void (^)(BOOL))aBlock maximumIdleDuration:(NSTimeInterval)idleDuration intervalBetweenIdleChecks:(NSTimeInterval)interval;

>*Parameters:*

>`aBlock`

>>A block to be invoked when a user's activity state changes.

>`idleDuration`

>>The amount of a time a user can be idle before being considered inactive.

>`interval`

>>The amount of a time to wait before checking the user's activity state again.

>*Returns:*

>An initialized `PCCommandStation` object or `nil`.

**initWithDelegate:**

**initWithDelegate:maximumIdleDuration:**

**initWithDelegate:maximumIdleDuration:intervalBetweenIdleChecks**

>Initializes a `PCCommandStation` object.

    - (id)initWithDelegate:(id<PCCommandStationDelegate>)aDelegate maximumIdleDuration:(NSTimeInterval)idleDuration intervalBetweenIdleChecks:(NSTimeInterval)interval;

>*Parameters:*

>`aDelegate`

>>Delegate object called when a user's activity state changes.

>`idleDuration`

>>The amount of a time a user can be idle before being considered inactive.

>`interval`

>>The amount of a time to wait before checking the user's activity state again.

>*Returns:*

>An initialized `PCCommandStation` object or `nil`.

**isEnabled**

>Returns whether or not the `PCCommandStation` is monitoring the user's activity state.

    - (BOOL)isEnabled

>*Returns:*

>`YES` if the `PCCommandStation` is currently monitoring the user's activity state, or `NO` otherwise.

**setEnabled:**

>Sets whether or not the `PCCommandStation` should monitor the user's activity state.

    - (void)setEnabled:(BOOL)enabled
    
>*Parameters:*

>`enabled`

>>`YES` if the `PCCommandStation` should monitor the user's activity state, or `NO` otherwise.


#PCCommandStationDelegate#

Inherits From:    NSObject

Declared In:      PCCommandStation.h


##Overview##

The `PCCommandStation` protocol allows objects to receive calls when a `PCCommandStation` detects a change in a user's activity state.

##Tasks##

###Respond to Activity State Changes###
    - commandStation:changedUserToActiveState:

##Instance Methods##

**commandStation:changedUserToActiveState:**

>Allows the delegate to respond to a user's change in activity state.

    - (void)commandStation:(PCCommandStation *)commandStation changedUserToActiveState:(BOOL)userIsActive;

>*Parameters:*

>`commandStation`

>>The `PCCommandStation` handling the observation of the user's activity state.

>`userIsActive`

>>Whether or not the user is currently active.

#License#

License Agreement for Source Code provided by Patrick Perini

This software is supplied to you by Patrick Perini in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

In consideration of your agreement to abide by the following terms, and subject to these terms, Patrick Perini grants you a personal, non-exclusive license, to use, reproduce, modify and redistribute the software, with or without modifications, in source and/or binary forms; provided that if you redistribute the software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the software, and that in all cases attribution of Patrick Perini as the original author of the source code shall be included in all such resulting software products or distributions. Neither the name, trademarks, service marks or logos of Patrick Perini may be used to endorse or promote products derived from the software without specific prior written permission from Patrick Perini. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Patrick Perini herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the software may be incorporated.

The software is provided by Patrick Perini on an "AS IS" basis. Patrick Perini MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR PCS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL Patrick Perini BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF Patrick Perini HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
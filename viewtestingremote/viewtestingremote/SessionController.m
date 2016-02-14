//
//  SessionController.m
//  playLoteria
//
//  Created by App Development on 1/3/16.
//  Copyright © 2016 App Development. All rights reserved.
//

#import "SessionController.h"

static SessionController *_sharedSessionController;

@implementation SessionController

static NSString * const sessionServiceType = @"evt";

#pragma mark - Initializing Session Controller

+(SessionController *)sharedSessionController {
    return _sharedSessionController;
}

+(void)initialize {
    if ([SessionController class] == self)
    {
        _sharedSessionController = [self new];
    }
}

+(id)allocWithZone:(struct _NSZone *)zone {
    if (_sharedSessionController && [SessionController class] == self)
    {
        [NSException raise:NSGenericException format:@"May not create more than one instance of a singleton class!"];
    }
    return [super allocWithZone:zone];
}

#pragma mark - Setting up Peer

- (void)setupPeerWithDisplayName:(NSString *)displayName {
    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
}

#pragma mark - Session

- (void)setupSession {
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}

- (void)destroySession {
    self.session = nil;
    self.session.delegate = nil;
}

#pragma mark - Browser

- (void)setupBrowser {
    self.foundPeersOrderedSet = [[NSMutableOrderedSet alloc] init];
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID
                                              serviceType:sessionServiceType];
    self.browser.delegate = self;
}

- (void)startBrowsing {
    [self.browser startBrowsingForPeers];
}

- (void)stopBrowsing {
    [self.browser stopBrowsingForPeers];
}

#pragma mark - Advertiser

- (void)advertiseSelf:(BOOL)advertise {
    if (advertise) {
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:sessionServiceType discoveryInfo:nil session:self.session];
        [self.advertiser start];
        
    } else {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}

- (BOOL)isAdvertising {
    if (self.advertiser){
        return true;}
    return false;
}

#pragma mark - Found Peers and Connected Devices

- (NSArray *)foundPeersArray {
    return [self.foundPeersOrderedSet array];
}

-(NSArray * )connectedPeersArray {
    return [NSArray arrayWithArray:self.session.connectedPeers];
}

#pragma mark - Session Delegate methods

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSDictionary *userInfo = @{ @"peerID": peerID,
                                @"state" : @(state) };
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didChangeStateNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSDictionary *userInfo = @{ @"data": data,
                                @"peerID": peerID };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Loteria_DidReceiveDataNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
    
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}


#pragma mark - MCNearbyServiceBrowserDelegate protocol conformance

// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    NSDictionary *userInfo = @{@"peerID": peerID };
    
    [self.foundPeersOrderedSet addObject:peerID];
    
    //Set up a notification when a new Peer is found so that the table view controller can be updated.
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"foundPeerNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
}

-(void)sendInvitationToPeer:(MCPeerID *)peerID {
    if ([[self connectedPeersArray] count] == 0 || [[self connectedPeersArray] objectAtIndex:0] != peerID)
    {
        //NSLog
        NSString *remotePeerName = peerID.displayName;
        NSLog(@"Browser found %@", remotePeerName);
        
        // this will have to be moved out to a separate method that invites another peer.
        MCPeerID *myPeerID = self.session.myPeerID;
        
        BOOL shouldInvite = ([myPeerID.displayName compare:remotePeerName] == NSOrderedDescending);
        
        if (shouldInvite)
        {
            NSLog(@"Inviting %@", remotePeerName);
            [self.browser invitePeer:peerID toSession:self.session withContext:nil timeout:30.0];
        }
        else
        {
            NSLog(@"Not inviting %@", remotePeerName);
        }
    }
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    //If a peer is lost just remove it from the list of foundPeers
    NSLog(@"lostPeer %@", peerID.displayName);
    
    NSDictionary *userInfo = @{ @"peerID": peerID };
    
    [self.foundPeersOrderedSet removeObject:peerID];
    
    //Set up a notification when a Peer is lost.
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lostPeerNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    NSLog(@"didNotStartBrowsingForPeers: %@", error);
}


@end

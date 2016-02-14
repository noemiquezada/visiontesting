//
//  SessionController.h
//  playLoteria
//
//  Created by App Development on 1/3/16.
//  Copyright © 2016 App Development. All rights reserved.
//
@protocol SessionControllerDelegate;

@interface SessionController : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) NSMutableOrderedSet *foundPeersOrderedSet;
@property (nonatomic, readonly) NSArray *connectedPeersArray;
@property (nonatomic, readonly) NSArray *foundPeersArray;

+(SessionController *)sharedSessionController;
- (void)setupPeerWithDisplayName:(NSString *)displayName;
- (void)sendInvitationToPeer:(MCPeerID *)peerID;
- (void)setupSession;
- (void)destroySession; 
- (void)setupBrowser;
- (void)startBrowsing;
- (void)stopBrowsing;
- (void)advertiseSelf:(BOOL)advertise;
- (BOOL)isAdvertising;
- (void)startAdvertising;
- (void)stopAdvertising;
- (void)setupAdvertising;

@end


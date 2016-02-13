//
//  SessionController.h
//  playLoteria
//
//  Created by App Development on 1/3/16.
//  Copyright © 2016 App Development. All rights reserved.
//

@interface SessionController : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
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




@end

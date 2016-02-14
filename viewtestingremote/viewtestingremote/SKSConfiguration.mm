//
//  SKSConfiguration.mm
//  SpeechKitSample
//
//  All Nuance Developers configuration parameters can be set here.
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

#import "SKSConfiguration.h"

// All fields are required.
// Your credentials can be found in your Nuance Developers portal, under "Manage My Apps".
NSString* SKSAppKey = @"6586f95fb46ee7d2f84b456a01f1e7d3bf8c3a0d5e8e0b9e0081319d123dcd77c3c6d67734bd492d088f9709807edd3f0b174c69a55807a5d93842eb760f6239";
NSString* SKSAppId = @"NMDPTRIAL_noemi01_csu_fullerton_edu20160214075755";
NSString* SKSServerHost = @"sslsandbox.nmdp.nuancemobility.net";
NSString* SKSServerPort = @"443";



NSString* SKSServerUrl = [NSString stringWithFormat:@"nmsps://%@@%@:%@", SKSAppId, SKSServerHost, SKSServerPort];

// Only needed if using NLU/Bolt
NSString* SKSNLUContextTag = @"!NLU_CONTEXT_TAG!";



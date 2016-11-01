//
//  WindowSizeAppDelegate.h
//  WindowSize
//
//  Created by Stefan Hochuli Paychère on 02.05.10.
//  Copyright 2010 Pistache Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import <Sparkle/Sparkle.h>

@class PreferenceController;

@interface WindowSizeApp : NSObject <NSApplicationDelegate> {
//	SUUpdater *updater;
	NSStatusItem *statusItem;
	NSImage *menuIcon;
	PreferenceController *prefs;
}
@property (retain, readonly) PreferenceController *prefs;
- (NSMenu *)createMenu;
- (void)setSizeTo720p:(id)sender;
- (void)setSizeTo1080p:(id)sender;
- (void)setSizeTo1080i:(id)sender;
- (void)setSizeToCustom:(id)sender;
- (void)setSizeToCustom2:(id)sender;
- (void)shutdown:(id)sender;
- (void)showPreferences:(id)sender;
- (void)checkForUpdates:(id)sender;
- (void)about:(id)sender;
// protected
- (void)setSizeAndPositionTo:(NSRect)rect;
+ (BOOL)screensCanDisplay:(NSRect)rect;
@end

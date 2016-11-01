//
//  WindowSizeAppDelegate.m
//  WindowSize
//
//  Created by Stefan Hochuli Paychère on 02.05.10.
//  Copyright 2010 Pistache Software. All rights reserved.
//

#import "WindowSizeApp.h"
#import <ScriptingBridge/ScriptingBridge.h>
#import "PreferenceController.h"

#define TAG_720P 1
#define TAG_1080P 2
#define TAG_1080I 3
#define TAG_CUSTOM 4
#define TAG_ABOUT 5
#define TAG_PREFERENCES 6
#define TAG_UPDATE 7
#define TAG_QUIT 8
#define TAG_CUSTOM2 9

#define ORIGIN_X 0
#define ORIGIN_Y 20

#define WIDTH_720P 1280
#define HEIGHT_720P 720

#define HEIGHT_1080 1080

#define WIDTH_1080P 1920
#define HEIGHT_1080P HEIGHT_1080

#define WIDTH_1080I 1440
#define HEIGHT_1080I HEIGHT_1080

int main(void) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[NSApplication sharedApplication];
	
	WindowSizeApp *windowSizeApp = [[[WindowSizeApp alloc]init]autorelease];
	[NSApp setDelegate:windowSizeApp];
	[NSApp run];
	
	// dead code
	[pool release];
	
	return 0;
}

@implementation WindowSizeApp

@synthesize prefs;

- (id)init{
	if (self = [super init]){
//		updater = [[[SUUpdater alloc]init]retain];
		prefs = [[[PreferenceController alloc]init]retain];
		[NSBundle loadNibNamed:@"Preferences" owner:prefs];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	//NSLog(@"%@", @"applicationDidFinishLaunching");
	
	NSMenu *m = [self createMenu];
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	
	[statusItem setMenu:m];
	[statusItem setToolTip:@"WindowSize"];
	[statusItem setHighlightMode:YES];

	menuIcon = [[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"resizeWindow_18x18-GREY" ofType:@"png"]]retain];
	[statusItem setImage:menuIcon];

}

- (void)checkForUpdates:(id)sender{
    /*
	if(updater != nil){
		[[NSApplication sharedApplication] unhide:self];
		[updater checkForUpdates:sender];
	}
     */
}

- (void) applicationWillTerminate:(NSNotification *)aNotification {
	[self release];
}

- (void)shutdown:(id)sender {
	[NSApp terminate:sender];
}

- (void) dealloc {
//	[updater release];
	[statusItem release];
	[menuIcon release];
	[prefs release];
	[super dealloc];
}

- (void)about:(id)sender{
	[[NSApplication sharedApplication] unhide:self];
	[[NSApplication sharedApplication]orderFrontStandardAboutPanel:sender];
}

- (void)showPreferences:(id)sender{
	if(prefs != nil){
		[prefs showWindow:sender];
	}
}


- (NSMenu *)createMenu {
	NSZone *menuZone = [NSMenu menuZone];
	NSMenu *m = [[NSMenu allocWithZone:menuZone] init];
	[m setAutoenablesItems:NO];

	NSMenuItem *tempMenuItem;
	
	// 720p
	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:NSLocalizedStringWithDefaultValue(@"MENU_720P", 
																					   @"WindowSize", 
																					   [NSBundle mainBundle], 
																					   @"Set window size to 1280 x 720 (720p)", 
																					   @"720p menu entry")
											  action:@selector(setSizeTo720p:) 
									   keyEquivalent:@""];
	[tempMenuItem setTarget:self];
	[tempMenuItem setTag:TAG_720P];
	[tempMenuItem setEnabled:[WindowSizeApp screensCanDisplay:NSMakeRect(ORIGIN_X, ORIGIN_Y, WIDTH_720P, HEIGHT_720P)]];

	// 1080p
	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:NSLocalizedStringWithDefaultValue(@"MENU_1080P", 
																					   @"WindowSize", 
																					   [NSBundle mainBundle], 
																					   @"Set window size to 1920 x 1080 (1080p)", 
																					   @"1080p menu entry")
											  action:@selector(setSizeTo1080p:) 
									   keyEquivalent:@""];
	[tempMenuItem setTarget:self];
	[tempMenuItem setTag:TAG_1080P];
	[tempMenuItem setEnabled:[WindowSizeApp screensCanDisplay:NSMakeRect(ORIGIN_X, ORIGIN_Y, WIDTH_1080P, HEIGHT_1080P)]];
	
	// 1080i
	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:NSLocalizedStringWithDefaultValue(@"MENU_1080I", 
																					   @"WindowSize", 
																					   [NSBundle mainBundle], 
																					   @"Set window size to 1440 x 1080 (1080i anamorphic 4:3 pixel)", 
																					   @"1080i menu entry")
											  action:@selector(setSizeTo1080i:) 
									   keyEquivalent:@""];
	[tempMenuItem setTarget:self];
	[tempMenuItem setTag:TAG_1080I];
	[tempMenuItem setEnabled:[WindowSizeApp screensCanDisplay:NSMakeRect(ORIGIN_X, ORIGIN_Y, WIDTH_1080I, HEIGHT_1080I)]];
	
	// Custom menus
	if(prefs != nil){
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSString* title = [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"MENU_CUSTOM", 
																					   @"WindowSize", 
																					   [NSBundle mainBundle], 
																					   @"Set window size to %i x %i (custom)", 
																					   @"Custom menu entry"),
						   [defaults integerForKey:@"customWidth"], 
						   [defaults integerForKey:@"customHeight"]];
		tempMenuItem = (NSMenuItem *)[m addItemWithTitle:title
												  action:@selector(setSizeToCustom:) 
										   keyEquivalent:@""];
		[tempMenuItem setTarget:self];
		[tempMenuItem setTag:TAG_CUSTOM];
		[tempMenuItem setEnabled:[WindowSizeApp screensCanDisplay:[prefs customRect]]];
        
        title = [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"MENU_CUSTOM2", 
                                                                             @"WindowSize", 
                                                                             [NSBundle mainBundle], 
                                                                             @"Set window size to %i x %i (custom 2)", 
                                                                             @"Custom menu entry"),
                 [defaults integerForKey:@"custom2Width"], 
                 [defaults integerForKey:@"custom2Height"]];
		tempMenuItem = (NSMenuItem *)[m addItemWithTitle:title
												  action:@selector(setSizeToCustom2:) 
										   keyEquivalent:@""];
		[tempMenuItem setTarget:self];
		[tempMenuItem setTag:TAG_CUSTOM2];
		[tempMenuItem setEnabled:[WindowSizeApp screensCanDisplay:[prefs customRect]]];

		[prefs setCustomSizeMenuItem:tempMenuItem];
	}
	
	// ------
	[m addItem:[NSMenuItem separatorItem]];

	// About...
	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:NSLocalizedStringWithDefaultValue(@"MENU_ABOUT", 
																					   @"WindowSize", 
																					   [NSBundle mainBundle], 
																					   @"About WindowSize...", 
																					   @"About menu entry")
											  action:@selector(about:)
									   keyEquivalent:@""];
	[tempMenuItem setTag:TAG_ABOUT];
	[tempMenuItem setTarget:self];
	
	// Preferences...
	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:NSLocalizedStringWithDefaultValue(@"MENU_PREFERENCES", 
																					   @"WindowSize", 
																					   [NSBundle mainBundle], 
																					   @"Preferences...", 
																					   @"Preferences menu entry")
											  action:@selector(showPreferences:)
									   keyEquivalent:@""];
	[tempMenuItem setTag:TAG_PREFERENCES];
	[tempMenuItem setTarget:self];
	
	// Check for updates...
	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:NSLocalizedStringWithDefaultValue(@"MENU_UPDATE", 
																					   @"WindowSize", 
																					   [NSBundle mainBundle], 
																					   @"Check for updates...", 
																					   @"Update menu entry")
											  action:@selector(checkForUpdates:)
									   keyEquivalent:@""];
	[tempMenuItem setTag:TAG_UPDATE];
	[tempMenuItem setTarget:self];
	
	
	// ------
	[m addItem:[NSMenuItem separatorItem]];
	
	// Quit
	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:NSLocalizedStringWithDefaultValue(@"MENU_QUIT", 
																					   @"WindowSize", 
																					   [NSBundle mainBundle], 
																					   @"Quit", 
																					   @"Quit menu entry")
											  action:@selector(shutdown:)
									   keyEquivalent:@""];
	[tempMenuItem setTag:TAG_QUIT];
	[tempMenuItem setTarget:self];
	//[tempMenuItem setToolTip:@"Quit"];
	
	return [m autorelease];	
}

- (void)setSizeTo720p:(id)sender{
	//NSLog(@"%@", @"setSizeTo720p...");
	[self setSizeAndPositionTo:NSMakeRect(ORIGIN_X, ORIGIN_Y, WIDTH_720P, HEIGHT_720P)];
}

- (void)setSizeTo1080p:(id)sender{
	//NSLog(@"%@", @"setSizeTo1080p...");
	[self setSizeAndPositionTo:NSMakeRect(ORIGIN_X, ORIGIN_Y, WIDTH_1080P, HEIGHT_1080P)];
}

- (void)setSizeTo1080i:(id)sender{
	//NSLog(@"%@", @"setSizeTo1080i...");
	[self setSizeAndPositionTo:NSMakeRect(ORIGIN_X, ORIGIN_Y, WIDTH_1080I, HEIGHT_1080I)];
}

- (void)setSizeToCustom:(id)sender{
	if(prefs != nil){
		[self setSizeAndPositionTo:[prefs customRect]];
	}
}

- (void)setSizeToCustom2:(id)sender{
	if(prefs != nil){
		[self setSizeAndPositionTo:[prefs customRect2]];
	}
}

- (void)setSizeAndPositionTo:(NSRect)rect{
	NSArray *apps = [[NSWorkspace sharedWorkspace] runningApplications];
	for(NSRunningApplication *app in apps){
		if([app isActive]){
			//NSLog(@"Active App: %@", [app bundleIdentifier] );
			id theApp = [SBApplication applicationWithBundleIdentifier:[app bundleIdentifier]];
			//NSLog(@"%@", theApp);
			if([theApp respondsToSelector:@selector(windows)]){
				SBElementArray *windows = [theApp performSelector:@selector(windows)];
				
				// Try to find main window
				NSInteger index = NSIntegerMax;
				NSInteger tmpIndex;
				SBObject *theWindow;
				for(SBObject *obj in windows){
					if([obj respondsToSelector:@selector(index)]){
						tmpIndex = (NSInteger)[obj performSelector:@selector(index)];
						if(tmpIndex < index){
							index = tmpIndex;
							theWindow = obj;
						}
					}
				}
				
				// apply resize
				if(index < NSIntegerMax){ // found a front window
					if([theWindow respondsToSelector:@selector(setBounds:)]){
						[theWindow setBounds:rect];
					}
				} else { // resize all
					for(SBObject *obj in windows){
						if([obj respondsToSelector:@selector(setBounds:)]){
							[obj setBounds:rect];
						}
					}
				}
			}
			
		}
	}
	/*
	 NSArray *windows = [NSWindow windowNumbersWithOptions: NSWindowNumberListAllApplications ||	NSWindowNumberListAllSpaces];
	 //NSLog(@"%@", windows);
	 for(NSNumber *number in windows){
	 NSLog(@"Window number: %@", number);
	 NSWindow *window = [[NSApplication sharedApplication] windowWithWindowNumber:[number intValue]];
	 NSLog(@"Window: %@", window);
	 }
	 */
}

+ (BOOL)screensCanDisplay:(NSRect)rect{
	for(NSScreen *screen in [NSScreen screens]){
		NSRect visible = [screen visibleFrame];
		if((visible.size.width >= rect.size.width) && (visible.size.height >= rect.size.height)){
			return YES; // This screen can show the rect entirely
		}
	}
	return NO;
}

@end

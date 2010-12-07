//
//  PreferenceController.h
//  WindowSize
//
//  Created by Stefan Hochuli Paychère on 04.05.10.
//  Copyright 2010 Pistache Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferenceController : NSObject {
	IBOutlet NSWindow *window;
	NSMenuItem *customSizeMenuItem;
	
	IBOutlet NSTextField *tfX;
	IBOutlet NSTextField *tfY;
	IBOutlet NSTextField *tfW;
	IBOutlet NSTextField *tfH;
}
@property (retain) NSMenuItem *customSizeMenuItem;
- (IBAction)updateMenu:(id)sender;
- (void)editingDidEnd:(NSNotification *)notification;
- (NSRect)customRect;
- (IBAction)showWindow:(id)sender;
@end

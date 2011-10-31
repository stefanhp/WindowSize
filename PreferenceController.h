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
	NSMenuItem *customSizeMenuItem2;
	
	IBOutlet NSTextField *tfX;
	IBOutlet NSTextField *tfY;
	IBOutlet NSTextField *tfW;
	IBOutlet NSTextField *tfH;

	IBOutlet NSTextField *tfX2;
	IBOutlet NSTextField *tfY2;
	IBOutlet NSTextField *tfW2;
	IBOutlet NSTextField *tfH2;
}
@property (retain) NSMenuItem *customSizeMenuItem;
- (IBAction)updateMenu:(id)sender;
- (void)editingDidEnd:(NSNotification *)notification;
- (NSRect)customRect;
- (NSRect)customRect2;
- (IBAction)showWindow:(id)sender;
@end

//
//  PreferenceController.m
//  WindowSize
//
//  Created by Stefan Hochuli Paychère on 04.05.10.
//  Copyright 2010 Pistache Software. All rights reserved.
//

#import "PreferenceController.h"
#import "WindowSizeApp.h"


@implementation PreferenceController
@synthesize customSizeMenuItem;

- (id)init{
    self = [super init];
    if (self) {
		// Set defaults
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray *keys = [NSArray arrayWithObjects:@"customX", @"customY", @"customWidth", @"customHeight",
                         @"custom2X", @"custom2Y", @"custom2Width", @"custom2Height",
                         nil];
		NSArray *objects = [NSArray arrayWithObjects:@"0", @"20", @"1024", @"768",
                            @"0", @"20", @"1280", @"450",
                            nil];
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
		[defaults registerDefaults:appDefaults];
		
		// register notification for text field
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:) name:NSControlTextDidEndEditingNotification
												   object:tfX];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:) name:NSControlTextDidEndEditingNotification
												   object:tfY];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:) name:NSControlTextDidEndEditingNotification
												   object:tfW];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:) name:NSControlTextDidEndEditingNotification
												   object:tfH];
        
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:) name:NSControlTextDidEndEditingNotification
												   object:tfX2];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:) name:NSControlTextDidEndEditingNotification
												   object:tfY2];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:) name:NSControlTextDidEndEditingNotification
												   object:tfW2];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:) name:NSControlTextDidEndEditingNotification
												   object:tfH2];

    }
    return self;
}

- (void)editingDidEnd:(NSNotification *)notification{
	[self updateMenu:self];
}

- (IBAction)updateMenu:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if(customSizeMenuItem != nil){
		NSString* title = [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"MENU_CUSTOM", 
																					   @"WindowSize", 
																					   [NSBundle mainBundle], 
																					   @"Set window size to %i x %i (custom)", 
																					   @"Custom menu entry"),
						   [defaults integerForKey:@"customWidth"], 
						   [defaults integerForKey:@"customHeight"]];
		[customSizeMenuItem setTitle:title];
		[customSizeMenuItem setEnabled:[WindowSizeApp screensCanDisplay:[self customRect]]];
	}
	if(customSizeMenuItem2 != nil){
		NSString* title = [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"MENU_CUSTOM2", 
																					   @"WindowSize", 
																					   [NSBundle mainBundle], 
																					   @"Set window size to %i x %i (custom 2)", 
																					   @"Custom menu entry"),
						   [defaults integerForKey:@"custom2Width"], 
						   [defaults integerForKey:@"custom2Height"]];
		[customSizeMenuItem setTitle:title];
		[customSizeMenuItem setEnabled:[WindowSizeApp screensCanDisplay:[self customRect]]];
	}
}


- (NSRect)customRect{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return NSMakeRect([defaults integerForKey:@"customX"], 
					  [defaults integerForKey:@"customY"], 
					  [defaults integerForKey:@"customWidth"], 
					  [defaults integerForKey:@"customHeight"]);
}

- (NSRect)customRect2{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return NSMakeRect([defaults integerForKey:@"custom2X"], 
					  [defaults integerForKey:@"custom2Y"], 
					  [defaults integerForKey:@"custom2Width"], 
					  [defaults integerForKey:@"custom2Height"]);
}

- (IBAction)showWindow:(id)sender{
	[window makeKeyAndOrderFront:sender];
}

@end

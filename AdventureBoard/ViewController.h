//
//  ViewController.h
//  AdventureBoard
//
//  Created by Brian Jordan on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *someLabel; // Then synthesize in .m
@property (nonatomic, strong) IBOutlet UILabel *volume;
@property (nonatomic, strong) IBOutlet UIImageView *finn;
@property (strong) NSMutableDictionary *_soundPlayers; // Title to player

-(IBAction)sliderChanged:(id)sender;
-(IBAction)playAudioForTitle:(id)sender;
-(IBAction)buttonTriggered:(id)sender;
-(IBAction)aboutThisApp:(id)sender;

@end

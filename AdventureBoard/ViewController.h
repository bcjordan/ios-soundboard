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
@property (nonatomic, strong) IBOutlet UIImageView *_sliderImage;
@property (nonatomic, strong) IBOutlet UIImageView *_headerImage;
@property (nonatomic, strong) IBOutlet UISlider *_slider;
@property (strong) NSMutableDictionary *_soundPlayers; // Title to player
@property (strong) NSMutableArray *_pictures;

-(IBAction)sliderChanged:(id)sender;
-(IBAction)playAudioForTitle:(id)sender;
-(IBAction)buttonTriggered:(id)sender;
-(IBAction)aboutThisApp:(id)sender;
-(IBAction)launchVideo:(id)sender;
-(void)constructButtonsAndPlayersFromClips:(NSArray*)clips;

-(UIColor *) randomColor;

@end

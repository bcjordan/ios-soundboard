//
//  ViewController.m
//  AdventureBoard
//
//  Created by Brian Jordan on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  Dedicated to the Apple App Store Reviewer currently reading this -
//  one of the unsung heroes of the finger-swiping revolution. Hats off to you, my hardworking,
//  kind, generous and George-Takei-soundboard-app-approving friend. If you read this, give me a sign -- any sign.
//
//  I just want to know that you exist and truly care about my beautiful, leak-free code.
//
//                   I want to believe.
//

#import "ViewController.h"

@implementation ViewController

@synthesize someLabel, volume, _sliderImage, _soundPlayers, _pictures, _headerImage, _slider;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray* soundClips = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:nil];
    NSLog(@"%@", soundClips);

    _soundPlayers = [NSMutableDictionary dictionaryWithCapacity:[soundClips count]];
    [self constructButtonsAndPlayersFromClips:soundClips];

    NSArray *picturePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil];

    _pictures = [[NSMutableArray alloc] init];
    
    for (NSString * path in picturePaths) {
        [_pictures addObject:[UIImage imageWithContentsOfFile:path]];
        NSLog(@"Adding image with path %@ count %i", path, [_pictures count]);
    }
}

- (void)constructButtonsAndPlayersFromClips:(NSArray*)soundClips
{
    NSError *error;
    
    const float INIT_X = 20.0;
    const float INIT_Y = 200.0;
    const float BUTTON_WIDTH = 140.0;
    const float BUTTON_HEIGHT = 40.0;
    const float COL_MARGIN = 10.0;
    const float ROW_MARGIN = 10.0;
    const int BUTTONS_PER_ROW = 5;
    const float BUTTON_FONT_SIZE = 30.0;

    int row = 0;
    int col = 0;

    for (NSString *clipPath in soundClips) {
        NSURL *urlPathOfAudio = [NSURL fileURLWithPath:clipPath];

        // Grab title from clip path (e.g., |/path/to/hello.mp3| will be titled |hello|)
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(^.+[*/])|(.mp3)"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSString *title = [regex stringByReplacingMatchesInString:clipPath options:0 range:NSMakeRange(0, [clipPath length]) withTemplate:@""];

        // Construct |AVAudioPlayer| with sound file
        NSLog(@"%@", title);

        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlPathOfAudio error:&error];
        [player prepareToPlay];
        [_soundPlayers setValue:player forKey:title];
        [player setVolume:0.5];
        NSLog(@"Loaded %@ with description %@", clipPath, title);

        // Construct titled button, given current row and col
        UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

        newButton.frame = CGRectMake(
                INIT_X + col * (COL_MARGIN + BUTTON_WIDTH),
                INIT_Y + row * (ROW_MARGIN + BUTTON_HEIGHT),
                BUTTON_WIDTH,
                BUTTON_HEIGHT);
        [newButton setTitle:title forState:UIControlStateNormal];
        newButton.titleLabel.font = [UIFont systemFontOfSize:BUTTON_FONT_SIZE];
        newButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [newButton addTarget:self action:@selector(playAudioForTitle:) forControlEvents:UIControlEventTouchUpInside];

        [newButton.titleLabel setLineBreakMode:UILineBreakModeTailTruncation];
        [newButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [newButton.titleLabel setTextAlignment:UITextAlignmentCenter];

        newButton.alpha = 0.97;

        [self.view addSubview:newButton];
        [self.view sendSubviewToBack:newButton];

        // Calculate next row/col
        if(col >= (BUTTONS_PER_ROW - 1)){
            row++;
            col = 0;
        } else {
            col++;
        }

        NSLog(@"Constructed button %@ at col %i row %i", title, col, row);
    }
}

- (IBAction)playAudioForTitle:(id)sender;
{
    UIButton *button = (UIButton *)sender;
    NSString *title = button.currentTitle;
    AVAudioPlayer *player = [_soundPlayers valueForKey:title];
    if (player != nil) {
        [player play];
    } else {
        NSLog(@"Could not play audio for button %@", title);
    }
    NSLog(@"Playing audio for button %@", title);

    [someLabel setText:title];

    int i = arc4random() % [_pictures count];
    [_headerImage setImage:[_pictures objectAtIndex:i]];
    NSLog(@"%@",[_pictures objectAtIndex:1]);
    [someLabel setShadowColor:[self randomColor]];
}

-(IBAction)sliderChanged:(id)sender
{
    UISlider *slider = (UISlider *) sender;
    int sliderValue = [[NSNumber numberWithFloat: slider.value*10] intValue];

    NSLog(@"Volume changed to %f (displaying as %d)", slider.value, sliderValue);

    for (AVAudioPlayer *player in _soundPlayers.allValues) {
        [player setVolume:slider.value];
    }

    [volume setText: [NSString stringWithFormat:@"%d", sliderValue]];
    CGPoint sliderImageCenter = slider.center;
    
    const float INIT_Y = 860.0;
    
    sliderImageCenter.x = sliderImageCenter.x + slider.value * 350 - 170;
    sliderImageCenter.y = INIT_Y + (slider.value - .5) * (slider.value - .5) * (slider.value - .5) * -800;
    [_sliderImage setCenter:sliderImageCenter];
    _sliderImage.alpha = 1 - (slider.value - .5) * (slider.value - .5) * 4;
    NSLog(@"%f", _sliderImage.alpha);
    [someLabel setText:[NSString stringWithFormat:@"Volume %d? Oh my!", sliderValue]];
    [someLabel setShadowColor:[[self randomColor] colorWithAlphaComponent:slider.value]];
}

-(IBAction)aboutThisApp:(id)sender
{
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"Takei Board Version 1"
                                                  message:@"Email me your suggestions, or record your "
                                                           "Takei call and send it in!\ntakeiboard@gmail.com\n"
                                                           "\n<3 Brian Jordan"
                                                 delegate:self
                                        cancelButtonTitle:@"Oh my!"
                                        otherButtonTitles:nil, nil];
    [view show];
}

-(IBAction)launchVideo:(id)sender
{
    UIApplication *thisApp = [UIApplication sharedApplication];
    NSString *videoPath = @"http://www.youtube.com/watch?v=dRkIWB3HIEs";
    NSURL *videoURL = [NSURL URLWithString:videoPath];
    [thisApp openURL:videoURL];
}

-(UIColor *) randomColor
{
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:_slider.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end

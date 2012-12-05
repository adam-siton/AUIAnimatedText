//
//  RootViewController.m
//  AUIAnimatedText
//
//  Created by Adam Siton on 9/21/11.
//  Copyright 2011 Adam Siton. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController
@synthesize animatableLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        colorToAnimate = [[NSArray alloc] initWithObjects:
                          [UIColor redColor],
                          [UIColor blueColor],
                          [UIColor greenColor],
                          [UIColor yellowColor],
                          [UIColor blackColor], nil];
        
        textToAnimate = [[NSArray alloc] initWithObjects:
                         [NSString stringWithFormat:@"Seamless animation"],
                         [NSString stringWithFormat:@"Simple implementation"],
                         [NSString stringWithFormat:@"Plain awsome!"],
                         nil];
        
        fontsToAnimate = [[NSArray alloc] initWithObjects:
                          [UIFont fontWithName:@"STHeitiSC-Medium" size:17.0],
                          [UIFont fontWithName:@"Georgia-Italic" size:17.0],
                          [UIFont fontWithName:@"Helvetica" size:17.0],nil];
        
        sizesToAnimate = [[NSArray alloc] initWithObjects:
                          [NSNumber numberWithFloat:21.0],
                          [NSNumber numberWithFloat:32.0],
                          [NSNumber numberWithFloat:10.0],
                          [NSNumber numberWithFloat:17.0], nil];
                          
                                                        
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setAnimatableLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

-(IBAction) animateTextColor
{
    static int colorIndex;
    
    if (colorIndex == colorToAnimate.count)
        colorIndex = 0;
    
    UIColor *newColor = [colorToAnimate objectAtIndex:colorIndex++];
    [UIView animateWithDuration:1.0 animations:^{
        self.animatableLabel.textColor = newColor;
    }];
}

-(IBAction) animateText
{
    static int textIndex;
    
    if (textIndex == textToAnimate.count)
        textIndex = 0;
    
    NSString *newText = [textToAnimate objectAtIndex:textIndex++];
    [UIView animateWithDuration:1.0 animations:^{
        self.animatableLabel.text = newText;
    }];
}

-(IBAction) animateFont
{
    static int fontIndex;
    
    if (fontIndex == fontsToAnimate.count)
        fontIndex = 0;
    
    UIFont *newFont = [fontsToAnimate objectAtIndex:fontIndex++];
    [UIView animateWithDuration:1.0 animations:^{
        self.animatableLabel.font = newFont;
    }];
}

-(IBAction) animateSize
{
    static int sizeIndex;
    
    if (sizeIndex == sizesToAnimate.count)
        sizeIndex = 0;
    
    float newSize = [[sizesToAnimate objectAtIndex:sizeIndex++] floatValue];
    [UIView animateWithDuration:1.0 animations:^{
        UIFont *font = self.animatableLabel.font;
        UIFont *newFont = [UIFont fontWithName:font.fontName size:newSize];
        self.animatableLabel.font = newFont;
    }];
}

@end

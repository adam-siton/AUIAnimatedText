//
//  RootViewController.h
//  AUIAnimatedText
//
//  Created by Adam Siton on 9/21/11.
//  Copyright 2011 Adam Siton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIAnimatableLabel.h"

@interface RootViewController : UIViewController {
    NSArray *colorToAnimate;
    NSArray *textToAnimate;
    NSArray *fontsToAnimate;
    NSArray *sizesToAnimate;
    
    AUIAnimatableLabel *animatableLabel;
}
@property (nonatomic, strong) IBOutlet AUIAnimatableLabel *animatableLabel;

@end

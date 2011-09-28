//
//  AnimatableTextField.h
//  AnyDo
//
//  Created by Adam Siton on 8/29/11.
//  Copyright 2011 Any.do. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CATextLayer;

@interface AnimatableTextField : UITextField {
    CATextLayer *textLayer;
}

// TODO: Need to register as delegate because for example, shouldChangeChars.. Does not set the text value.

@property (readonly) CATextLayer *textLayer;

@end

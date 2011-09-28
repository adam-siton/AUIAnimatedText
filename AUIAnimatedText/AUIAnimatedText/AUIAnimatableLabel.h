//
//  AnimatableLabel.h
//  AnyDo
//
//  Created by Adam Siton on 8/29/11.
//  Copyright 2011 Any.do. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CATextLayer;

@interface AUIAnimatableLabel : UILabel
{
    CATextLayer *textLayer;
}

@property (readonly) CATextLayer *textLayer;

@end

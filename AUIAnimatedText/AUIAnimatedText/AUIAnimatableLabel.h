//
//  AnimatableLabel.h
//  AnyDo
//
//  Created by Adam Siton on 8/29/11.
//  Copyright 2011 Any.do. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CATextLayer;

typedef enum {
    AUITextVerticalAlignmentCenter = 0,
    AUITextVerticalAlignmentTop = 1,
    AUITextVerticalAlignmentBottom = 2
} AUITextVerticalAlignment;

@interface AUIAnimatableLabel : UILabel
{
    CATextLayer *textLayer;
}

@property (nonatomic) AUITextVerticalAlignment verticalTextAlignment;
@property (readonly) CATextLayer *textLayer;


@end

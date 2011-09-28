//
//  AnimatableTextField.m
//  AnyDo
//
//  Created by Adam Siton on 8/29/11.
//  Copyright 2011 Any.do. All rights reserved.
//

#import "AnimatableTextField.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "UIFont+CoreTextExtensions.h"

@interface AnimatableTextField()

-(void) _initializeTextLayer;

@end

@implementation AnimatableTextField

@synthesize textLayer;

-(id) init
{
    self = [super init];
    if (self)
    {
        [self _initializeTextLayer];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _initializeTextLayer];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _initializeTextLayer];
    }
    return self;
}

-(void) dealloc
{
    [textLayer release];
    [self removeObserver:self forKeyPath:@"text"];
    [super dealloc];
}

-(UIColor *)textColor
{
    return [UIColor colorWithCGColor:textLayer.foregroundColor];
}

-(void) setTextColor:(UIColor *)textColor
{
    textLayer.foregroundColor = textColor.CGColor;
}

-(NSString *)text
{
    return textLayer.string;
}

-(void) setText:(NSString *)text
{
    textLayer.string = text;
}

-(UIFont *) font
{
    return [UIFont fontWithCTFont:textLayer.font];
}

-(void) setFont:(UIFont *)font
{
    CTFontRef fontRef = font.CTFont;
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CFRelease(fontRef);
}

-(void) setFrame:(CGRect)frame
{
    textLayer.frame = frame;
    [super setFrame:frame];
}

// TODO: implement all the following relevant properties

/*
@property(nonatomic,copy)   NSString               *text;                 // default is nil
@property(nonatomic,retain) UIColor                *textColor;            // default is nil. use opaque black
@property(nonatomic,retain) UIFont                 *font;                 // default is nil. use system font 12 pt
@property(nonatomic)        UITextAlignment         textAlignment;        // default is UITextAlignmentLeft
@property(nonatomic)        UITextBorderStyle       borderStyle;          // default is UITextBorderStyleNone. If set to UITextBorderStyleRoundedRect, custom background images are ignored.
@property(nonatomic,copy)   NSString               *placeholder;          // default is nil. string is drawn 70% gray
@property(nonatomic)        BOOL                    clearsOnBeginEditing; // default is NO which moves cursor to location clicked. if YES, all text cleared
@property(nonatomic)        BOOL                    adjustsFontSizeToFitWidth; // default is NO. if YES, text will shrink to minFontSize along baseline
@property(nonatomic)        CGFloat                 minimumFontSize;      // default is 0.0. actual min may be pinned to something readable. used if adjustsFontSizeToFitWidth is YES
@property(nonatomic,assign) id<UITextFieldDelegate> delegate;             // default is nil. weak reference
@property(nonatomic,retain) UIImage                *background;           // default is nil. draw in border rect. image should be stretchable
@property(nonatomic,retain) UIImage                *disabledBackground;   // default is nil. ignored if background not set. image should be stretchable
*/

-(void) _initializeTextLayer
{
    textLayer = [[CATextLayer alloc] init];
    [textLayer setFrame:self.frame];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [self.layer addSublayer:textLayer];
}



@end

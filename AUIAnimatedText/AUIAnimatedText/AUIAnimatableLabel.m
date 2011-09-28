//
//  AnimatableLabel.m
//  AnyDo
//
//  Created by Adam Siton on 8/29/11.
//  Copyright 2011 Any.do. All rights reserved.
//

#import "AUIAnimatableLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+CoreTextExtensions.h"

#pragma mark - private methods declaration

@interface AUIAnimatableLabel()

-(void) _initializeTextLayer;

@end

#pragma mark - AnimatableLabel implementation

@implementation AUIAnimatableLabel

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
    [super dealloc];
}

-(UIColor *)textColor
{
    return [UIColor colorWithCGColor:textLayer.foregroundColor];
}

-(void) setTextColor:(UIColor *)textColor
{
    textLayer.foregroundColor = textColor.CGColor;
    [self setNeedsDisplay];
}

-(NSString *)text
{
    return textLayer.string;
}

-(void) setText:(NSString *)text
{
    textLayer.string = text;
    [self setNeedsDisplay];
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
    [self setNeedsDisplay];
}

-(void) setFrame:(CGRect)frame
{
    textLayer.frame = frame;
    [super setFrame:frame];
    [self setNeedsDisplay];
}

-(UIColor *) shadowColor
{
    return [UIColor colorWithCGColor:textLayer.shadowColor];
}

-(void) setShadowColor:(UIColor *)shadowColor
{
    textLayer.shadowColor = shadowColor.CGColor;
    [self setNeedsDisplay];
}

-(CGSize) shadowOffset
{
    return textLayer.shadowOffset;
}

-(void) setShadowOffset:(CGSize)shadowOffset
{
    textLayer.shadowOffset = shadowOffset;
    [self setNeedsDisplay];
}

-(UITextAlignment) textAlignment
{
    UITextAlignment labelAlignment = UITextAlignmentLeft;
    NSString *layerAlignmentMode = textLayer.alignmentMode;
    if ([layerAlignmentMode isEqualToString:kCAAlignmentLeft])
        labelAlignment = UITextAlignmentLeft;
    else if ([layerAlignmentMode isEqualToString:kCAAlignmentRight])
        labelAlignment = UITextAlignmentRight;
    else if ([layerAlignmentMode isEqualToString:kCAAlignmentCenter])
        labelAlignment = UITextAlignmentCenter;
    
    return labelAlignment;
}

-(void) setTextAlignment:(UITextAlignment)textAlignment
{
    switch (textAlignment) {
        case UITextAlignmentLeft:
            textLayer.alignmentMode = kCAAlignmentLeft;
            break;
        case UITextAlignmentRight:
            textLayer.alignmentMode = kCAAlignmentRight;
        case UITextAlignmentCenter:
            textLayer.alignmentMode = kCAAlignmentCenter;
            break;
        default:
            textLayer.alignmentMode = kCAAlignmentNatural;
            break;
    }
    [self setNeedsDisplay];
}

-(UILineBreakMode) lineBreakMode
{
    return [super lineBreakMode];
}

-(void) setLineBreakMode:(UILineBreakMode)lineBreakMode
{
    switch (lineBreakMode) {
        case UILineBreakModeWordWrap:
            textLayer.wrapped = YES;
            break;
        case UILineBreakModeClip:
            textLayer.wrapped = NO;
            break;
        case UILineBreakModeHeadTruncation:
            textLayer.truncationMode = kCATruncationStart;  
            break;
        case UILineBreakModeTailTruncation:
            textLayer.truncationMode = kCATruncationEnd;
            break;
        case UILineBreakModeMiddleTruncation:
            textLayer.truncationMode = kCATruncationMiddle;
            break;
        default:
            break;
    }
    [self setNeedsDisplay];
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    // Resize the text so that the text will be vertically aligned to the center
    // TODO: Add vertical alignment property
    CGSize maximumSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    CGSize stringSize = [self.text sizeWithFont:self.font 
                              constrainedToSize:maximumSize 
                                  lineBreakMode:self.lineBreakMode];
    
    CGRect newLayerFrame = self.layer.bounds;
    newLayerFrame.size.height = stringSize.height;
    newLayerFrame.origin.y = (self.bounds.size.height - stringSize.height) / 2;
    textLayer.frame = newLayerFrame;
    
    if (self.adjustsFontSizeToFitWidth)
    {
        // TODO: Calculate the size of the textLayer
        // minimumFontSize
    }
    
    // TODO: Handle numberOfLines and  minimumFontSize and baselineAdjustment
    
    [self setNeedsDisplay];
}

/*
// this determines the number of lines to draw and what to do when sizeToFit is called. default value is 1 (single line). A value of 0 means no limit
// if the height of the text reaches the # of lines or the height of the view is less than the # of lines allowed, the text will be
// truncated using the line break mode.

@property(nonatomic) NSInteger numberOfLines;

// these next 3 property allow the label to be autosized to fit a certain width by shrinking the font size to a minimum font size
// and to specify how the text baseline moves when it needs to shrink the font. this only affects single line text (lineCount == 1)

@property(nonatomic) CGFloat minimumFontSize;                 // default is 0.0
@property(nonatomic) UIBaselineAdjustment baselineAdjustment; // default is UIBaselineAdjustmentAlignBaselines

*/

#pragma mark - private methods

-(void) _initializeTextLayer
{    
    textLayer = [[CATextLayer alloc] init];
    [textLayer setFrame:self.bounds];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Initialize the default.
    self.textColor = [super textColor];
    self.font = [super font];
    self.backgroundColor = [super backgroundColor];
    self.text = [super text];
    self.textAlignment = [super textAlignment];
    
    [super setText:nil];
    
    [self.layer addSublayer:textLayer];
}

@end

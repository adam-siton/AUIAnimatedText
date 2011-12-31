//
//  AnimatableLabel.m
//  AUIAnimatedText
//
//  Created by Adam Siton on 8/29/11.
//  Copyright 2011 Adam Siton. All rights reserved.
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

@synthesize textLayer, verticalTextAlignment;

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
            break;
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

-(void) setVerticalTextAlignment:(AUITextVerticalAlignment)newVerticalTextAlignment
{
    verticalTextAlignment = newVerticalTextAlignment;
    [self setNeedsLayout];
}

-(void) layoutSubviews
{
    [super layoutSubviews];
        
    if (self.adjustsFontSizeToFitWidth)
    {
        // Calculate the new font size:
        CGFloat newFontSize;
        [textLayer.string sizeWithFont:self.font minFontSize:self.minimumFontSize actualFontSize:&newFontSize forWidth:self.bounds.size.width lineBreakMode:self.lineBreakMode];
        self.font = [UIFont fontWithName:self.font.fontName size:newFontSize];
    }
    
    // Resize the text so that the text will be vertically aligned according to the set alignment
    CGSize stringSize = [self.text sizeWithFont:self.font 
                              constrainedToSize:self.bounds.size 
                                  lineBreakMode:self.lineBreakMode];
    
    CGRect newLayerFrame = self.layer.bounds;
    newLayerFrame.size.height = stringSize.height;
    switch (self.verticalTextAlignment) {
        case AUITextVerticalAlignmentCenter:
                newLayerFrame.origin.y = (self.bounds.size.height - stringSize.height) / 2;        
            break;
        case AUITextVerticalAlignmentTop:
            newLayerFrame.origin.y = 0;
            break;
        case AUITextVerticalAlignmentBottom:
            newLayerFrame.origin.y = (self.bounds.size.height - stringSize.height);
            break;
        default:
            break;
    }
    textLayer.frame = newLayerFrame;

    // TODO: Handle numberOfLines
    
    [self setNeedsDisplay];
}

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
    self.lineBreakMode = [super lineBreakMode];
    // TODO: Get the value from the contentMode property so that the vertical alignment could be set via interface builder
    self.verticalTextAlignment = AUITextVerticalAlignmentCenter;
    [super setText:nil];
    [self.layer addSublayer:textLayer];
}

@end

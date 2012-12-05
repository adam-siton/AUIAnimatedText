//
//  AnimatableLabel.m
//  AUIAnimatedText
//
//  Created by Adam Siton on 8/29/11.
//  Copyright 2011 Adam Siton. All rights reserved.
//
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

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

-(NSTextAlignment) textAlignment
{
    NSTextAlignment labelAlignment = NSTextAlignmentLeft;
    NSString *layerAlignmentMode = textLayer.alignmentMode;
    if ([layerAlignmentMode isEqualToString:kCAAlignmentLeft])
        labelAlignment = NSTextAlignmentLeft;
    else if ([layerAlignmentMode isEqualToString:kCAAlignmentRight])
        labelAlignment = NSTextAlignmentRight;
    else if ([layerAlignmentMode isEqualToString:kCAAlignmentCenter])
        labelAlignment = NSTextAlignmentCenter;
    
    return labelAlignment;
}

-(void) setTextAlignment:(NSTextAlignment)textAlignment
{
    switch (textAlignment) {
        case NSTextAlignmentLeft:
            textLayer.alignmentMode = kCAAlignmentLeft;
            break;
        case NSTextAlignmentRight:
            textLayer.alignmentMode = kCAAlignmentRight;
            break;
        case NSTextAlignmentCenter:
            textLayer.alignmentMode = kCAAlignmentCenter;
            break;
        default:
            textLayer.alignmentMode = kCAAlignmentNatural;
            break;
    }
    [self setNeedsDisplay];
}

-(NSLineBreakMode) lineBreakMode
{
    return [super lineBreakMode];
}

-(void) setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    switch (lineBreakMode) {
        case NSLineBreakByWordWrapping:
            textLayer.wrapped = YES;
            break;
        case NSLineBreakByClipping:
            textLayer.wrapped = NO;
            break;
        case NSLineBreakByTruncatingHead:
            textLayer.truncationMode = kCATruncationStart;
            break;
        case NSLineBreakByTruncatingTail:
            textLayer.truncationMode = kCATruncationEnd;
            break;
        case NSLineBreakByTruncatingMiddle:
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
        float minimumFontSize;
        if ([self respondsToSelector:@selector(minimumScaleFactor)]) {
            minimumFontSize = self.minimumScaleFactor;
        }
        else {
            minimumFontSize = self.minimumFontSize;
        }
        [textLayer.string sizeWithFont:self.font minFontSize:minimumFontSize actualFontSize:&newFontSize forWidth:self.bounds.size.width lineBreakMode:self.lineBreakMode];
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

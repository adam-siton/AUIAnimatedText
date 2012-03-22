//
//  UIFont+CoreTextExtensions.h
//  CoreTextWrapper
//
//  Created by Adrian on 4/24/10.
//  Copyright 2010 akosma software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIFont (CoreTextExtensions)

@property (nonatomic, readonly) CTFontRef CTFont;

+ (UIFont *) fontWithCTFont:(CTFontRef) CTFont;

+ (CTFontRef)bundledFontNamed:(NSString *)name size:(CGFloat)size;

@end

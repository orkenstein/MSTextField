//
//  ThirstieTextField.m
//  Thirstie
//
//  Created by Mason Silber on 8/14/13.
//  Copyright (c) 2013 Digital-Liquor-Delivery. All rights reserved.
//

#import "MSTextField.h"
#import <QuartzCore/QuartzCore.h>

@interface MSTextField  ()

@property (nonatomic) UIImageView *checkMark;
+(UIView *)paddingView;

@end

@implementation MSTextField

+(UIView *)paddingView
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    return paddingView;
}

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(10, frame.origin.y, 300, 50);
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:UIColorFromRGB(0xdedede)];
        [self setTextColor:[UIColor blackColor]];
        [self setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]];
        [self setClearButtonMode:UITextFieldViewModeWhileEditing];
        [[self layer] setCornerRadius:3.5f];
        [self setLeftView:[MSTextField paddingView]];
        [self setLeftViewMode:UITextFieldViewModeAlways];
        [self setTextAlignment:NSTextAlignmentLeft];
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.isValid = YES;
    }
    return self;
}

-(void)drawPlaceholderInRect:(CGRect)rect
{
    if (IS_IOS7) {
        CGSize placeHolderSize = [self.placeholder boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0f]} context:nil].size;
        rect.origin.y = (self.frame.size.height - placeHolderSize.height)/2;
        rect.size.height = placeHolderSize.height;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    [self.placeholder drawInRect:rect withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0f], NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: UIColorFromRGB(0x787878)}];
}

- (void)setInputState:(InputState)inputState
{
    if (self.inputState == inputState) {
        return;
    }
    _inputState = inputState;
    if (_inputState == ThirstieTextFieldInvalidInput) {
        self.layer.borderWidth = 2.0f;
        self.checkMark.hidden = YES;
    } else {
        self.layer.borderWidth = 0.0f;
        if (_inputState == ThirstieTextFieldValidInput) {
            self.checkMark.hidden = NO;
        } else {
            self.checkMark.hidden = YES;
        }
    }
}

- (void)setIsValid:(BOOL)isValid
{
    _isValid = isValid;
    if (isValid) {
        self.layer.borderWidth = 0.0f;
    } else {
        self.layer.borderWidth = 2.0f;
    }
}

- (BOOL)becomeFirstResponder
{
    self.isValid = YES;
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if (self.verificationBlock) {
        if (self.verificationBlock()) {
            self.inputState = ThirstieTextFieldValidInput;
        } else {
            self.inputState = ThirstieTextFieldInvalidInput;
        }
    }
    return [super resignFirstResponder];
}

@end
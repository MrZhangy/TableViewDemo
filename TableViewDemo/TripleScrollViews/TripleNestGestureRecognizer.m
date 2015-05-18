//
//  TripleNestGestureRecognizer.m
//  TripleExample
//
//  Created by Andrei Stanescu on 7/24/13.
//  Copyright (c) 2013 Mind Treat Studios. All rights reserved.
//

#import "TripleNestGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


#define EDGE_THRESHOLD 10

@implementation TripleNestGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self)
    {
        [self customInit];
    }
    return self;
}


- (void)awakeFromNib
{
    [self customInit];
}

- (void)customInit
{
    //当一个手势被识别，是否交付给这个View
    self.cancelsTouchesInView = FALSE;
    self.delaysTouchesBegan = TRUE;
    
    //手势识别还没有识别他是什么手势，但可以评估触摸事件。这是默认状态。
    self.state = UIGestureRecognizerStatePossible;
}
//当一个手势识别尝试完成,调用重置内部状态
//runtime是在 gesture-recognizer state被设置为UIGestureRecognizerStateEnded, UIGestureRecognizerStateRecognized, UIGestureRecognizerStateCancelled, or UIGestureRecognizerStateFailed时调用这个方法，换句话说,任何终端状态的手势识别。子类应该重置任何内部状态,准备一个新的手势识别的尝试。调用此方法后,触摸手势识别器收到触摸事件没有进一步更新（已经开始,但还没有结束）。
- (void)reset
{
    self.state = UIGestureRecognizerStatePossible;
}

- (void)setState:(UIGestureRecognizerState)state
{
    [super setState:state];
    
    //在一个连续的手势取消后手势识别器接收到结果。他会发送一个消息（在runloop的下次循环）并且重置他的状态为UIGestureRecognizerStatePossible
    if (state == UIGestureRecognizerStateCancelled)
        [self setEnableOtherGestureRecognizers:FALSE];
    else
        [self setEnableOtherGestureRecognizers:TRUE];
}

- (void)setEnableOtherGestureRecognizers:(BOOL)enabled
{
    if (self.view == nil)
        return;
    
    for (UIGestureRecognizer* recognizer in self.view.gestureRecognizers)
    {
        if (recognizer == self)
            continue;
        
        //关闭或开启手势
        recognizer.enabled = enabled;
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.state = UIGestureRecognizerStatePossible;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateFailed;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateFailed;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    //
    
    if ([self.view isKindOfClass:[UIScrollView class]] == FALSE)
        return ;

    if (self.state != UIGestureRecognizerStatePossible)
        return ;

    UITouch* touch = [touches anyObject];
    if (touch == nil)
        return ;

    CGPoint location = [touch locationInView:self.view];
    CGPoint prevlocation = [touch previousLocationInView:self.view];
    
    UIGestureRecognizerState newstate = UIGestureRecognizerStateFailed;
    UIScrollView* scroll = (UIScrollView*)self.view;

    // Compute the real content rectangle
    float minX = -scroll.contentInset.left;
    float minY = -scroll.contentInset.top;
    float maxX = scroll.contentSize.width - scroll.contentInset.right;
    float maxY = scroll.contentSize.height - scroll.contentInset.bottom;
    
    // TOP EDGE
    if (scroll.contentOffset.y <= minY + EDGE_THRESHOLD)
    {
        if (location.y > prevlocation.y && fabsf(location.x - prevlocation.x) < 8)
        {
            newstate = UIGestureRecognizerStateCancelled;
        }
    }
    
    // BOTTOM EDGE
    if (scroll.contentOffset.y + scroll.bounds.size.height >= maxY - EDGE_THRESHOLD)
    {
        if (location.y < prevlocation.y && fabsf(location.x - prevlocation.x) < 8)
        {
            newstate = UIGestureRecognizerStateCancelled;
        }
    }
    
    
    self.state = newstate;
}


@end

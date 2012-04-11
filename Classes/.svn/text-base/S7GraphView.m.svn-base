//
//  S7GraphView.m
//  S7Touch
//
//  Created by Aleks Nesterow on 9/27/09.
//  aleks.nesterow@gmail.com
//  
//  Thanks to http://snobit.habrahabr.ru/ for releasing sources for his
//  Cocoa component named GraphView.
//  
//  Copyright © 2009, 7touchGroup, Inc.
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of the 7touchGroup, Inc. nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY 7touchGroup, Inc. "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL 7touchGroup, Inc. BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//  

#import "S7GraphView.h"

@interface S7GraphView (PrivateMethods)

- (void)initializeComponent;

@end

@implementation S7GraphView

- (UIColor *)colorByIndex:(NSInteger)index {
	UIColor *color;
	
	if(_info == @"1"){
		color = RGB(255, 0, 0);
	}
	else if(_info == @"2"){
		color = RGB(0, 255, 0);
	}
	else if(_info == @"3"){
		color = RGB(0, 0, 255);
	}
	
	return color;
}

@synthesize dataSource = _dataSource, xValuesFormatter = _xValuesFormatter, yValuesFormatter = _yValuesFormatter;
@synthesize drawAxisX = _drawAxisX, drawAxisY = _drawAxisY, drawGridX = _drawGridX, drawGridY = _drawGridY;
@synthesize xValuesColor = _xValuesColor, yValuesColor = _yValuesColor, gridXColor = _gridXColor, gridYColor = _gridYColor;
@synthesize drawInfo = _drawInfo, info = _info, infoColor = _infoColor;

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		[self initializeComponent];
    }
	
	UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]; ;
	//tap.minimumPressDuration = 1;
	tap.numberOfTapsRequired = 2;
	[self addGestureRecognizer:tap];

    return self;
}

- (void)tap:(UITapGestureRecognizer *)gesture{
	UAV *uav = [UAV sharedInstance];
	if (uav.graphIsZoomed) {
		uav.graphIsZoomed = NO;
	} else {
		uav.graphIsZoomed = YES;

	}

}
	
- (id)initWithCoder:(NSCoder *)decoder {
	
	if (self = [super initWithCoder:decoder]) {
		[self initializeComponent];
	}
	UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]; ;
	//tap.minimumPressDuration = 1;
	tap.numberOfTapsRequired = 2;
	[self addGestureRecognizer:tap];
	
	
	return self;
}

- (void)dealloc {
	
	[_xValuesFormatter release];
	[_yValuesFormatter release];
	
	[_xValuesColor release];
	[_yValuesColor release];
	
	[_gridXColor release];
	[_gridYColor release];
	
	[_info release];
	[_infoColor release];
	
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();

	if (![UAV sharedInstance].graphIsZoomed) {
		CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
	} else {
		CGContextSetFillColorWithColor(c, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);

	}

	CGContextFillRect(c, rect);
	
	NSUInteger numberOfPlots = [self.dataSource graphViewNumberOfPlots:self];
	
	if (!numberOfPlots) {
		return;
	}
	
	CGFloat offsetX = _drawAxisY ? 60.0f : 10.0f;
	CGFloat offsetY = (_drawAxisX || _drawInfo) ? 30.0f : 10.0f;
	
	CGFloat minY = 0;
	CGFloat maxY = -INFINITY;
	
	UIFont *font = [UIFont systemFontOfSize:15.0f];
	

		
		NSArray *values = [self.dataSource graphView:self yValuesForPlot:0];
		
		for (NSUInteger valueIndex = 0; valueIndex < values.count; valueIndex++) {
			
			CGFloat y = [[values objectAtIndex:valueIndex] floatValue];
			if (y > maxY) {
				maxY = y;
			} 
			
			if (y < minY) {
				minY = y;
			}

		}
	
	if (maxY > 0){
		maxY *= 1.1;
	} else {
		maxY *= 0.9;
	}

	CGFloat step = fabs(maxY - minY) / 5;
	if (minY < 0) {
		
	}
	CGFloat stepY = (self.frame.size.height - (offsetY * 2)) / fabs(maxY - minY);
	
	for (NSUInteger i = 0; i < 6; i++) {
		
		NSUInteger y = (i * step) * stepY;
		CGFloat value = i * step;
		
		if (_drawGridY) {
			
			CGFloat lineDash[2];
			lineDash[0] = 6.0f;
			lineDash[1] = 6.0f;
			
			CGContextSetLineDash(c, 0.0f, lineDash, 2);
			CGContextSetLineWidth(c, 0.3f);
			
			CGPoint startPoint = CGPointMake(offsetX, self.frame.size.height - y - offsetY);
			CGPoint endPoint = CGPointMake(self.frame.size.width - offsetX, self.frame.size.height - y - offsetY);
			
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, self.gridYColor.CGColor);
			CGContextStrokePath(c);
		}
		
		if (i >= 0 && _drawAxisY) {
			
			NSNumber *valueToFormat = [NSNumber numberWithFloat:(value + minY)];
			
			NSString *valueString;
			
			if (_yValuesFormatter) {
				valueString = [_yValuesFormatter stringForObjectValue:valueToFormat];
			} else {
				valueString = [valueToFormat stringValue];
			}
			
			[self.yValuesColor set];
			CGRect valueStringRect = CGRectMake(0.0f, self.frame.size.height - y - offsetY -10, 50.0f, 20.0f);
			
			[valueString drawInRect:valueStringRect withFont:font
					  lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
		}
	}
	
	NSUInteger maxStep;
	
	NSArray *xValues = [self.dataSource graphViewXValues:self];
	NSUInteger xValuesCount = xValues.count;
	
	if (xValuesCount > 5) {
		
		NSUInteger stepCount = 5;
		NSUInteger count = xValuesCount - 1;
		
		for (NSUInteger i = 4; i < 8; i++) {
			if (count % i == 0) {
				stepCount = i;
			}
		}
		
		step = xValuesCount / stepCount;
		maxStep = stepCount + 1;
		
	} else {
		
		step = 1;
		maxStep = xValuesCount;
	}
	
	CGFloat stepX = (self.frame.size.width - (offsetX * 2)) / (xValuesCount - 1);
	
	for (NSUInteger i = 0; i < maxStep; i++) {
		
		NSUInteger x = (i * step) * stepX;
		
		if (x > self.frame.size.width - (offsetX * 2)) {
			x = self.frame.size.width - (offsetX * 2);
		}
		
		NSUInteger index = i * step;
		
		if (index >= xValuesCount) {
			index = xValuesCount - 1;
		}
		
		if (_drawGridX) {
			
			CGFloat lineDash[2];
			
			lineDash[0] = 6.0f;
			lineDash[1] = 6.0f;
			
			CGContextSetLineDash(c, 0.0f, lineDash, 2);
			CGContextSetLineWidth(c, 0.3f);
			
			CGPoint startPoint = CGPointMake(x + offsetX, offsetY);
			CGPoint endPoint = CGPointMake(x + offsetX, self.frame.size.height - offsetY);
			
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, self.gridXColor.CGColor);
			CGContextStrokePath(c);
		}
		
		if (_drawAxisX) {
			
			id valueToFormat = [NSNumber numberWithDouble:[(UAVSTRUCT*)[xValues objectAtIndex:index] ms]];
			NSString *valueString;
			if (_xValuesFormatter) {
				valueString = [_xValuesFormatter stringForObjectValue:valueToFormat];
			} else {
				valueString = [NSString stringWithFormat:@"%@", valueToFormat];
			}
			[self.xValuesColor set];
			[valueString drawInRect:CGRectMake(x, self.frame.size.height - 20.0f, 120.0f, 20.0f) withFont:font
					  lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
		}
	}
	
	stepX = (self.frame.size.width - (offsetX * 2)) / (xValuesCount - 1);
	
	CGContextSetLineDash(c, 0, NULL, 0);
	
		
	//	NSArray *values = [self.dataSource graphView:self yValuesForPlot:plotIndex];
		
		CGColorRef plotColor = [self colorByIndex:0].CGColor;
		
		CGPoint lines[[values count] * 2 + 4]; 
//printf("%d\n", values.count);
		for (NSUInteger valueIndex = 0; valueIndex < values.count - 1; valueIndex++) {
			NSUInteger x = valueIndex * stepX;
			CGFloat y = ([[values objectAtIndex:valueIndex] doubleValue] - minY) * stepY;
		//	if(_info == @"3")
		//		NSLog(@"%f", y);
			CGContextSetLineWidth(c, 1.4f);
			
			//CGPoint startPoint = CGPointMake(x + offsetX, self.frame.size.height - y - offsetY);
			lines[valueIndex*2] = CGPointMake(x + offsetX, self.frame.size.height - y - offsetY);

			x = (valueIndex + 1) * stepX;
			y = ([[values objectAtIndex:valueIndex + 1] doubleValue] - minY) * stepY;
			
			//CGPoint endPoint = CGPointMake(x + offsetX, self.frame.size.height - y - offsetY);
		
			lines[valueIndex*2+1] = CGPointMake(x + offsetX, self.frame.size.height - y - offsetY);
			NSAssert(valueIndex*2+1 < [values count]*2, @"s7GraphView error");
		}
		CGContextSetStrokeColorWithColor(c, plotColor);
		CGContextStrokeLineSegments(c, lines, values.count*2);
	
	
	if (_drawInfo) {
		
		font = [UIFont boldSystemFontOfSize:13.0f];
		[self.infoColor set];
		[_info drawInRect:CGRectMake(0.0f, 5.0f, self.frame.size.width, 20.0f) withFont:font
			lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	}
	//rect.origin.x = 5;
}

- (void)reloadData {
	[self setNeedsDisplay];
}

#pragma mark PrivateMethods

- (void)initializeComponent {
	
	_drawAxisX = YES;
	_drawAxisY = YES;
	_drawGridX = YES;
	_drawGridY = YES;
	
	_xValuesColor = [[UIColor blackColor] retain];
	_yValuesColor = [[UIColor blackColor] retain];
	
	_gridXColor = [[UIColor blackColor] retain];
	_gridYColor = [[UIColor blackColor] retain];
	
	_drawInfo = NO;
	_infoColor = [[UIColor blackColor] retain];
}

@end

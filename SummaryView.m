//
//  SummaryView.m
//  UAV
//
//  Created by Eric Dong on 8/15/10.
//  Copyright 2010 NUS. All rights reserved.
//

#import "SummaryView.h"


@implementation SummaryView

@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		textLabel.text = @"MYMOTHER";
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end

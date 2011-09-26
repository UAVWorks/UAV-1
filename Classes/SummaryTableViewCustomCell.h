//
//  SummaryTableViewCustomCell.h
//  UAV
//
//  Created by Eric Dong on 8/18/10.
//  Copyright 2010 NUS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface SummaryTableViewCustomCell : UITableViewCell {
	IBOutlet UILabel *parameterLabel;
	IBOutlet UILabel *label1;
	IBOutlet UILabel *label2;
	IBOutlet UILabel *label3;
	IBOutlet UILabel *nameoflabel1;
	IBOutlet UILabel *nameoflabel2;
	IBOutlet UILabel *nameoflabel3;
}

@property(nonatomic, retain) UILabel *parameterLabel;
@property(nonatomic, retain) UILabel *label1;
@property(nonatomic, retain) UILabel *label2;
@property(nonatomic, retain) UILabel *label3;
@property(nonatomic, retain) UILabel *nameoflabel1;
@property(nonatomic, retain) UILabel *nameoflabel2;
@property(nonatomic, retain) UILabel *nameoflabel3;

@end

//
//  SummaryViewController.h
//  UAV
//
//  Created by Eric Dong on 8/16/10.
//  Copyright 2010 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "SummaryTableViewCustomCell.h"

@class GraphView;

@interface SummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UILabel *textLabel;
	NSArray *listData;
	sqlite3 *db;
	IBOutlet UITableView *summaryTable;
	IBOutlet UILabel *dataHeader;
	GraphView *unfiltered;
	NSInteger row;
	NSInteger oldResult;
	IBOutlet UIImageView *dataIndicatorYes;
	IBOutlet UIImageView *dataIndicatorNo;}

@property(nonatomic, retain) IBOutlet GraphView *unfiltered;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) NSArray *listData;// *tableView;
@property (nonatomic, retain) UITableView *summaryTable;
@property (nonatomic, retain) UILabel *dataHeader;
@property (nonatomic, retain) UIImageView *dataIndicatorYes;

@property (nonatomic, retain) UIImageView *dataIndicatorNo;

-(NSMutableArray*) getLatestRowData;
-(NSInteger) newDataInDB;
-(NSMutableArray*) getColumnData:(NSInteger)columnID;
@end

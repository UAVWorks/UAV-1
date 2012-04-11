//
//  SummaryViewController.h
//  UAV
//
//  Created by Eric Dong on 8/16/10.
//  Copyright 2010 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryTableViewCustomCell.h"
#import "UAV.h"
#import "S7GraphView.h"

@class GraphView;

@interface SummaryViewController : UIViewController <S7GraphViewDataSource, UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UILabel *textLabel;
	NSArray *listData;
	NSArray *listComponent;
	IBOutlet UITableView *summaryTable;
	IBOutlet UILabel *dataHeader;
//	GraphView *graph_1;
//	GraphView *graph_2;
//	GraphView *graph_3;
	sqlite3 *db;
	NSInteger row;
	NSInteger oldResult;
	NSArray *tableRows;
	S7GraphView *graphView1;
	S7GraphView *graphView2;
	S7GraphView *graphView3;
	
	NSMutableArray *temparray;
	NSMutableArray *temparray2;
}

//@property(nonatomic, retain) IBOutlet GraphView *graph_1;
//@property(nonatomic, retain) IBOutlet GraphView *graph_2;
//@property(nonatomic, retain) IBOutlet GraphView *graph_3;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) NSArray *listComponent;
@property (nonatomic, retain) UITableView *summaryTable;
@property (nonatomic, retain) UILabel *dataHeader;
@property (nonatomic, retain) NSArray *tableRows;
@property (nonatomic, retain) IBOutlet S7GraphView *graphView1;
@property (nonatomic, retain) IBOutlet S7GraphView *graphView2;
@property (nonatomic, retain) IBOutlet S7GraphView *graphView3;
@property (nonatomic, retain) NSArray *temparray;
@property (nonatomic, retain) NSArray *temparray2;
-(NSInteger) newDataInDB;
-(void) refreshTable:(NSNotification*)pNotification;
@end

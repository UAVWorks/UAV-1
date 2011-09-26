    //
//  SummaryViewController.m
//  UAV
//
//  Created by Eric Dong on 8/16/10.
//  Copyright 2010 NUS. All rights reserved.
//

#import "SummaryViewController.h"
#import "SummaryTableViewCustomCell.h"
#import "UAVAppDelegate.h"
#import "GraphView.h"
#import <sqlite3.h>

@implementation SummaryViewController

@synthesize textLabel;
@synthesize listData;
@synthesize summaryTable;
@synthesize dataHeader;

@synthesize unfiltered;

@synthesize dataIndicatorYes;
@synthesize dataIndicatorNo;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSArray *array = [[NSArray alloc] initWithObjects:
					  
					  @"Position", 
					  @"Velocity", 
					  @"Altitudes", 
					  @"Rotating Angles", 
					  @"Acceleration", 
					  @"Angular Acceleration", 
					  @"Velocities", 
					  @"GPS", 
					  @"Variables",
					  
	
					  nil];
	
	self.listData = array;
	//array[1];
	
	UAVAppDelegate *mainDelegate = (UAVAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	db =  mainDelegate.db;
	
	row = 0;
	oldResult = 0;
	
	[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshTable) userInfo:nil repeats:YES];
	[array release];
	
    [super viewDidLoad];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
//	self.unfiltered = nil;
}


- (void)dealloc {
//	[unfiltered release];
    [super dealloc];
}
*/

#pragma mark -
#pragma mark Table View DataSource 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
		
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	SummaryTableViewCustomCell *cell = (SummaryTableViewCustomCell *)[tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
	
	if(cell == nil){
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SummaryTableViewCustomCell" 
													 owner:self
												   options:nil];
		cell = [nib objectAtIndex:0];

	}
	
	NSMutableArray *results = [self getLatestRowData]; // returns whole t-uple.
	if([results count] == 0){ //if no data return, set attribute row to 0.
		cell.label1.text = @"0";
		cell.label2.text = @"0";
		cell.label3.text = @"0";
	}
	else{
			cell.label1.text = [NSString stringWithFormat: @"%.8f", [[results objectAtIndex:[indexPath row]*3] doubleValue]];
			cell.label2.text = [NSString stringWithFormat: @"%.8f", [[results objectAtIndex:[indexPath row]*3+1] doubleValue]];
			cell.label3.text = [NSString stringWithFormat: @"%.8f", [[results objectAtIndex:[indexPath row]*3+2] doubleValue]];
		
	}
	[results release];
	
	cell.parameterLabel.text = [listData objectAtIndex:[indexPath row]];
	
	[SimpleTableIdentifier release];
	
	return cell;
}

-(NSInteger) newDataInDB{ //not in use. this lags data. 
	//return 1;
	NSString *query = @"Select count(*) from FLIGHTDATA;";
	
	NSInteger numOfDataCount=0;
	
	sqlite3_stmt *statement;
	if(sqlite3_prepare_v2(db, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
		if (sqlite3_step(statement) == SQLITE_ROW){
			numOfDataCount = sqlite3_column_int(statement, 0);
		}
	}
	[query release];
	
	if(numOfDataCount > oldResult)
		oldResult = numOfDataCount;
	else {
		return 0;
	}
	return 1;
}
	
	

-(NSMutableArray*) getLatestRowData {
	printf("in\n");
	NSString *query;
	
	query = [[NSString alloc] initWithFormat:@"Select count(*) from FLIGHTDATA;"];

	int result=0;
	
	sqlite3_stmt *statement;
	printf("before\n");
	if(sqlite3_prepare_v2(db, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
		NSLog(@"%@", query);
		if (sqlite3_step(statement) == SQLITE_ROW){
			printf("heeeee\n");
			result = sqlite3_column_int(statement, 0);
		}
	}
	printf("He\n");
	printf("%d", result);
//	[query release];
	if(result == 0) //if no data, return empty array.
		return [NSMutableArray new];
	
	query = [[NSString alloc] initWithFormat:@"Select * from FLIGHTDATA where id=%d;",result];
	
	sqlite3_stmt *newstatement;
	
	NSMutableArray *results;
	
	results = [NSMutableArray new];
	
	if(sqlite3_prepare_v2(db, [query UTF8String], -1, &newstatement, nil) == SQLITE_OK){
		sqlite3_step(newstatement);
		for(int i=1;i<=27;i++){
		//p
		[results addObject:[NSNumber numberWithDouble:sqlite3_column_double(newstatement,i)]];
		}
	}
	
//	[query release];
	
	printf("return results\n");
	return results;
}

-(NSMutableArray*) getColumnData:(NSInteger)columnID{
	NSMutableArray *results;
	NSString *query = [[NSString alloc] initWithFormat:@"Select * from FLIGHTDATA order by id Desc;"];
	
	sqlite3_stmt *newstatement;
	
	results = [NSMutableArray new];
	
	if(sqlite3_prepare_v2(db, [query UTF8String], -1, &newstatement, nil) == SQLITE_OK){
		while(sqlite3_step(newstatement) == SQLITE_ROW){//column 0 is the id
			[results addObject:[NSNumber numberWithDouble:sqlite3_column_double(newstatement,columnID+1)]];
		}
	}
	
	[query release];
	
	return results;
}



-(void) refreshTable {
	
	if([self newDataInDB]){
	//if(1){
		dataIndicatorYes.hidden = FALSE;
		
		dataIndicatorNo.hidden = TRUE;
		
		NSMutableArray *result = [self getLatestRowData]; // returns p only for now
		//if(row > 4)
		//	row -= 4;
		[unfiltered addX:[[result objectAtIndex:row*3] intValue] y:[[result objectAtIndex:row*3+1] intValue] z:[[result objectAtIndex:row*3+2] intValue]];
		[result release];
		[summaryTable reloadData];
	}
	else {
		dataIndicatorNo.hidden = FALSE;
		dataIndicatorYes.hidden = TRUE;
	}

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

	return [self.listData count];
}

#pragma mark -
#pragma mark Table View Delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath{
	dataHeader.text = [listData objectAtIndex:indexPath.row];
	
	row = indexPath.row;
	
	
		NSMutableArray *result = [self getColumnData:indexPath.row*3]; // get the 3 columns
		NSMutableArray *result1 = [self getColumnData:indexPath.row*3+1]; //get the 3 columns
		NSMutableArray *result2 = [self getColumnData:indexPath.row*3+2]; //get the 3 columns
	int max = [result count];
	if (max>300){
		max = 300;
	}
	for(int i=max-1;i>=0;i--){
		[unfiltered addX:[[result objectAtIndex:i] intValue] y:[[result1 objectAtIndex:i] intValue] z:[[result2 objectAtIndex:i] intValue]];
	}
	
	[result release];
	[result1 release];
	[result2 release];
		
	//}
	return indexPath;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
#pragma mark -
@end

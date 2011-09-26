//
//  UAVAppDelegate.m
//  UAV
//
//  Created by Eric Dong on 8/15/10.
//  Copyright NUS 2010. All rights reserved.
//

#import "UAVAppDelegate.h"


@implementation UAVAppDelegate

@synthesize window;
@synthesize tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	void* data;
	data = malloc(100000000);
	NSLog(@"free-ing memory");
	free(data);
	NSLog(@"free memory");
	
	application.idleTimerDisabled = YES;

	[[UAV sharedInstance] createSQL];
	tabBarController.delegate = self;
	
	for (int i=0; i<[tabBarController.viewControllers count]; i++) {
		if([[tabBarController.viewControllers objectAtIndex:i] isKindOfClass:[SettingsViewController class]]){
			tabBarController.selectedIndex = i;
			break;
		}
	}
	
//	NSAssert([[tabBarController viewControllers] count] == kINDEXSETTINGS+1, @"Wrong kIndexSettings");
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods


// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)controller didSelectViewController:(UIViewController *)viewController {

}

- (BOOL)tabBarController:(UITabBarController *)controller shouldSelectViewController:(UIViewController *)viewController{
	/*if([viewController class] == [OpenGLViewController	class]){
		return NO;
	}*/
	
	if (![viewController isViewLoaded]) {
		[[UAV sharedInstance].activityIndicator startAnimating];
		[UAV sharedInstance].activityIndicator.center = CGPointMake(self.window.frame.size.height/2, self.window.frame.size.width/2);
		[tabBarController.view addSubview:[UAV sharedInstance].activityIndicator];
		
	}
	return YES;
	
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end


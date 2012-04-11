///git add -u .     to add committed files

///put all shared stuff here. app delegate is included in every header.

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "UAV.h"
#import "SettingsViewController.h"

@interface UAVAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

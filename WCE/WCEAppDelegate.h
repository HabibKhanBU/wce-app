//
//  WCEAppDelegate.h
//  WCE
//
//

#import <UIKit/UIKit.h>

#import "LoginViewController.h"
#import "WCETabBarController.h"

@class WCETabBarController;

@interface WCEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) LoginViewController *loginController;
@property (strong, nonatomic, readonly) WCETabBarController *tabBarController;
@property (strong, nonatomic, readonly) UINavigationController *loginNavController;
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;

- (void)presentLoginViewControllerAnimated:(BOOL)animated;

@end

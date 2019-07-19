#import "Rishima_prefsheader.h"

NSString *rishimaScreenshotFile = @"/Library/Application Support/Rishima/RishimaScreenShot.png";

@implementation RishimaListController
+ (NSString *)hb_specifierPlist {
    return @"Rishima";
    
}

//share button
-(void)loadView {
    [super loadView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(shareTapped)];
    
    [self checkSysVersionAndDisplayLargeTitlesBecauseTheyLookOk];
	
}

-(void)checkSysVersionAndDisplayLargeTitlesBecauseTheyLookOk {
    if (@available(iOS 11.0, *)) {
        
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
}

//tint color to use for toggles and buttons 
+ (UIColor *)hb_tintColor {
    return [UIColor colorWithRed:18.0/255.0 green:26.0/255.0 blue:45.0/255.0 alpha:1.0];
}

//share button action 
- (void)shareTapped {
   
    NSString *shareText = @"I'm using #Rishima by @iKilledAppl3 to give my Volume HUD/Ringer HUD an iOS 13 inspired look! download in Cydia/Sileo/Zebra today! on the @iospackixrepo! https://repo.packix.com/package/com.ikilledappl3.rishima/";
    
     UIImage *rishimaScreenshotImg = [UIImage imageWithContentsOfFile:rishimaScreenshotFile];
    
	 NSArray * itemsToShare = @[shareText, rishimaScreenshotImg];
	 
    	UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:itemsToShare applicationActivities:nil];
    
    // and present it
    [self presentActivityController:controller];
}

- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.rightBarButtonItem;
 
}


-(void)doAFancyRespring {
    self.mainAppRootWindow = [UIApplication sharedApplication].keyWindow;
    self.respringBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.respringEffectView = [[UIVisualEffectView alloc] initWithEffect:self.respringBlur];
    self.respringEffectView.frame = [[UIScreen mainScreen] bounds];
    [self.mainAppRootWindow addSubview:self.respringEffectView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:5.0];
    [self.respringEffectView setAlpha:0];
    [UIView commitAnimations];
    [self performSelector:@selector(respring) withObject:nil afterDelay:3.0];
    
}

-(void)respring {
    NSTask *task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    [task launch];
    
}

@end

// vim:ft=objc

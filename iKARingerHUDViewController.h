//
//  iKARingerHUDViewController.h
//  Rishima
//
//  Created by iKilledAppl3 on 6/12/19.
//  Copyright © 2019 iKilledAppl3 & ToxicAppl3 INSDC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+DCAnimationKit.h"
#import "CCUICAPackageView.h"

#define ringerColor [UIColor colorWithRed:172.0/255.0 green:165.0/255.0 blue:174.0/255.0 alpha:1]

#define ringerColor2 [UIColor colorWithRed:88.0/255.0 green:75.0/255.0 blue:84.0/255.0 alpha:1]

#define ringerColor3 [UIColor whiteColor];

#define trackColor [UIColor colorWithRed:88.0/255.0 green:75.0/255.0 blue:84.0/255.0 alpha:0.2]

//Thanks to Ultrasound! https://github.com/aydenp/Ultrasound/blob/master/ABVolumeHUDIconRingerGlyph.m
#define kGlyphPackageName @"Mute"
#define kGlyphPackageBundle [NSBundle bundleWithURL:[ControlCenterModulesRoot URLByAppendingPathComponent:@"MuteModule.bundle"]]

@interface iKARingerHUDViewController : UIViewController {
    UIView *newRingerHUDView;
    UILabel *ringerLabel;
    UILabel *onLabel;
    UIProgressView *ringerProgressView;
    CCUICAPackageView *ringerPackageView;
    CGSize kDeviceScreenSize;
}
@property (nonatomic, readwrite) BOOL shouldAppearDark;
@property (nonatomic, assign) float ringtoneVolumeProgress;
-(void)newRingHUDView:(UIView *)ringerHUD;
-(void)viewWillAppear:(BOOL)animated;
//-(void)shakeRingerPackageView;
@end



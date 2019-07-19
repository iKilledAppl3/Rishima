//
//  iKARingerHUDViewController.xm
//  Rishima
//
//  Created by iKilledAppl3 on 6/12/19.
//  Copyright © 2019 iKilledAppl3 & ToxicAppl3 INSDC. All rights reserved.
//

#import "iKARingerHUDViewController.h"

@interface iKARingerHUDViewController ()

@end

//These are here to prevent duplicate symbol issues -__-
//Don't nag about these :P
@interface SBMediaController : NSObject 
+(id)sharedInstance;
-(float)volume;
-(BOOL)isRingerMuted;
@end

@interface CALayer (Private)

@property (nonatomic, assign) BOOL continuousCorners;
@property (nonatomic, retain) NSString *compositingFilter;
@property (nonatomic, assign) BOOL allowsGroupOpacity;
@property (nonatomic, assign) BOOL allowsGroupBlending;

@end

@interface SBHUDView : UIView 
@property (assign,nonatomic) float progress;
+(float)progressIndicatorStep;
-(float)progress;
@end

@interface SBVolumeHUDView : SBHUDView
@property (assign, nonatomic) float progress;
@property (assign,nonatomic) int mode;
-(int)mode;
-(float)progress;
@end

@interface PSUISoundsPrefController : UIViewController {
    float _volume;
}
-(BOOL)_canChangeRingtoneWithButtons;
@end

@interface MPVolumeController : NSObject 
-(float)volumeValue;
-(NSString *)volumeAudioCategory;
@end

@interface _MTBackdropView : UIView
@property (assign,nonatomic) CGFloat blurRadius;
@property (assign,nonatomic) double saturation;
@property (assign, nonatomic) double brightness;
@property (nonatomic,copy) UIColor * colorAddColor;
@property (nonatomic,copy) UIColor * colorMatrixColor;
@property (nonatomic, copy, readwrite) NSString *groupName;
-(void)setBlurRadius:(double)arg1;
@end

@interface AVSystemController : NSObject
+(id)sharedAVSystemController;

@end

SBMediaController *mediaC = [%c(SBMediaController) sharedInstance];
SBVolumeHUDView *hudView = [[%c(SBVolumeHUDView) alloc] init];
PSUISoundsPrefController *ringtoneController = [[%c(PSUISoundsPrefController) alloc] init];
MPVolumeController *kVolumeController = [[%c(MPVolumeController) alloc] init];

_MTBackdropView *ringerHUDEffectView;


@implementation iKARingerHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = [UIColor clearColor];
       [self newRingHUDView:newRingerHUDView];

       if ([kVolumeController.volumeAudioCategory isEqualToString:@"Ringtone"] || hudView.mode == 1) {
        self.ringtoneVolumeProgress = hudView.progress;
       }
}


-(void)newRingHUDView:(UIView *)ringerHUD {
    kDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (kDeviceScreenSize.height == 568) {
        //iPhone 5s, SE, iPod touch 6/7 size :P
        ringerHUD = [[UIView alloc] initWithFrame:CGRectMake(63.5, 35, 200, 50)];
    }
    
    else if (kDeviceScreenSize.height == 667) {
        //iPhone 6, 6s, 7, 8 size :P
        ringerHUD = [[UIView alloc] initWithFrame:CGRectMake(83.5, 50, 200, 50)];
    }
    
    else if (kDeviceScreenSize.height == 812) {
        //iPhone X, XS size :P
        ringerHUD = [[UIView alloc] initWithFrame:CGRectMake(87.5, 50, 200, 50)];
    }
    
    else {
        //iPhone 6+, 6s+, 7+, 8+, iPhone XR, XS Max size :P
        //Also default if not specified otherwise :P
        ringerHUD = [[UIView alloc] initWithFrame:CGRectMake(111.5, 50, 200, 50)];
    }
    
    ringerHUD.backgroundColor = [UIColor clearColor];
    ringerHUD.layer.cornerRadius = 25.0f;
    ringerHUD.layer.continuousCorners = YES;
    ringerHUD.layer.masksToBounds = YES;
    ringerHUD.clipsToBounds = YES;
    [self.view addSubview:ringerHUD];
    ringerHUD.opaque = YES;
    ringerHUD.alpha = 0.8;
    
    ringerHUDEffectView = [[%c(_MTBackdropView) alloc] init];
    ringerHUDEffectView.frame = ringerHUD.frame;
    ringerHUDEffectView.layer.cornerRadius = ringerHUD.layer.cornerRadius;
    ringerHUDEffectView.layer.continuousCorners = YES;
    ringerHUDEffectView.layer.masksToBounds = YES;
    ringerHUDEffectView.clipsToBounds = YES;
    if (!self.shouldAppearDark) {
         ringerHUDEffectView.colorAddColor = [UIColor colorWithWhite:1 alpha:0.85];
    }

    else {
         ringerHUDEffectView.colorAddColor = [UIColor colorWithWhite:0 alpha:0.8];
    }
    ringerHUDEffectView.blurRadius = 15.0;
    [self.view addSubview:ringerHUDEffectView];
    [self.view insertSubview:ringerHUDEffectView belowSubview:ringerHUD];
    
    ringerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, -35, 100, 100)];
    if (!mediaC.isRingerMuted) {
        ringerLabel.text = @"Ringer";
    }

    else {
        ringerLabel.text = @"Silent Mode";
    }
    
    ringerLabel.textAlignment = NSTextAlignmentCenter;
    ringerLabel.textColor = ringerColor;
    ringerLabel.clipsToBounds = YES;
    ringerLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    [ringerHUD addSubview:ringerLabel];
    
    ringerProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(75, 35, ringerHUD.bounds.size.width - 140, ringerHUD.bounds.size.height - 40)];
    ringerProgressView.progressViewStyle = UIProgressViewStyleBar;
    ringerProgressView.transform = CGAffineTransformMakeScale(2.0, 2.5);
    ringerProgressView.progress = self.ringtoneVolumeProgress;
      if (!self.shouldAppearDark) {
        ringerProgressView.trackTintColor = trackColor;
        ringerProgressView.progressTintColor = ringerColor2;
    }

    else {
          ringerProgressView.trackTintColor = ringerColor2;
          ringerProgressView.progressTintColor = ringerColor3;
    }
    //if ([ringtoneController _canChangeRingtoneWithButtons] || [kVolumeController.volumeAudioCategory isEqualToString:@"Ringtone"]) {
         //ringerProgressView.progress = hudView.progress;
    //}
    ringerProgressView.clipsToBounds = YES;
    ringerProgressView.layer.cornerRadius = 1.5;
    ringerProgressView.alpha = ringerHUD.alpha;
    [ringerHUD addSubview:ringerProgressView];

    ringerPackageView = [[%c(CCUICAPackageView) alloc] init];
    ringerPackageView.frame = CGRectMake(10, 0, 26, 46);
    ringerPackageView.packageDescription = [%c(CCUICAPackageDescription) descriptionForPackageNamed:kGlyphPackageName inBundle:kGlyphPackageBundle];
    ringerPackageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [ringerHUD addSubview:ringerPackageView];
    [self checkToSeeIfSilentModeIsActive];
    
    if (ringerProgressView.hidden) {
        onLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 50, 50)];
        onLabel.text = @"On";
        onLabel.textAlignment = NSTextAlignmentCenter;
        onLabel.textColor = ringerPackageView.tintColor;
        onLabel.clipsToBounds = YES;
        onLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        [ringerHUD addSubview:onLabel];
        [self silentTransitionThing];

    }
    
    else {
        onLabel.hidden = YES;
        [self silentTransitionThing];
        //[self shakeRingerPackageView];
    }
}

-(void)silentTransitionThing {
      CATransition *transition = [CATransition animation];
        transition.duration = 0.2;//kAnimationDuration
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromBottom;
        [self->onLabel.layer addAnimation:transition forKey:nil];
        [self->ringerLabel.layer addAnimation:transition forKey:nil];
        [self->ringerProgressView.layer addAnimation:transition forKey:nil];
    
}

-(void)checkToSeeIfSilentModeIsActive {
    if ([ringerLabel.text isEqualToString:@"Silent Mode"]) {
        ringerProgressView.hidden = YES;
        ringerPackageView.tintColor = [UIColor redColor];
        [ringerPackageView setStateName:@"silent"];
    }
    
    else {
        ringerProgressView.hidden = NO;
        ringerPackageView.tintColor = ringerColor;
        [ringerPackageView setStateName:@"ringer"];
    }
}

/*-(void)shakeRingerPackageView {
       [UIView animateWithDuration:0.0 animations:^{
          [self->ringerPackageView swing:NULL];
           ringerPackageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL f){
          
        }];
}*/

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.view setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.view setHidden:YES];
}

@end
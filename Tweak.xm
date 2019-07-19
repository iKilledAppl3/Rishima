#import "Rishima.h"
#import "iKARingerHUDViewController.h"
//created by iKilledAppl3 on June 3rd, 2019 at 1:11 am

@interface SBMediaController : NSObject 
+(id)sharedInstance;
-(float)volume;
-(BOOL)isRingerMuted;
@end

@interface PSUISoundsPrefController : UIViewController {
    float _volume;
}
-(BOOL)_canChangeRingtoneWithButtons;
@end

SBMediaController *mediaController = [%c(SBMediaController) sharedInstance];
VolumeControl *volumeController = [%c(VolumeControl) sharedVolumeControl];
PSUISoundsPrefController *rController = [[%c(PSUISoundsPrefController) alloc] init];
SBHUDView *dangOldHUD = [[%c(SBHUDView) alloc] init];
iKARingerHUDViewController *newRingerHUDVC;
CATransition *ringerHUDTransition;

@interface iKilledAppl3ControlCenterAudioForSpringBoard ()
@end

@implementation iKilledAppl3ControlCenterAudioForSpringBoard

-(void)setupLabelViews {
  _volLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, -10, 100, 100)];
  _volLabel.text = @"Volume";
  _volLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
  _volLabel.textColor = [UIColor colorWithWhite:1 alpha:1.0];
  _volLabel.layer.shadowColor = [UIColor blackColor].CGColor;
  _volLabel.layer.shadowOpacity = 0.6;
  _volLabel.layer.shadowRadius = 3.0;
  _volLabel.layer.shadowOffset = CGSizeMake(2,2);
  [self.view addSubview:_volLabel];


  _speakerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 150, 100, 100)];

  if (volumeController.headphonesPresent) {
     _speakerLabel.text = @"Headphones";
  }
  else {
     _speakerLabel.text = @"Speaker";
  }
  _speakerLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
  _speakerLabel.textColor = [UIColor colorWithWhite:1 alpha:1.0];
  _speakerLabel.layer.shadowColor = [UIColor blackColor].CGColor;
  _speakerLabel.layer.shadowOpacity = 0.6;
  _speakerLabel.layer.shadowRadius = 3.0;
  _speakerLabel.layer.shadowOffset = CGSizeMake(2,2);
  [self.view addSubview:_speakerLabel];
  [self.view bringSubviewToFront:_speakerLabel];
}

-(void)setupPanGesture {
  _newPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedTheVolume:)];
  _newPanGesture.minimumNumberOfTouches = 1;
  [self.view addGestureRecognizer:_newPanGesture];

}

-(void)pannedTheVolume:(UIPanGestureRecognizer *)recognizer;
{

    if (recognizer.state == UIGestureRecognizerStateBegan)
  {
      
  }
  else if (recognizer.state == UIGestureRecognizerStateEnded)
  {

  }

}

-(void)setupImageViewBasedOnPercentage {
  _volumePackageImageView = [[UIImageView alloc] init];
  _volumePackageImageView.frame = CGRectMake(5,83,48,48);
  _volumePackageImageView.opaque = YES;
  _volumePackageImageView.layer.allowsGroupOpacity = YES;
  _volumePackageImageView.layer.allowsGroupBlending = YES;
  _volumePackageImageView.layer.compositingFilter = kCAFilterDestOut;

    _currentVolumeFromCC = mediaController.volume;

     if (_currentVolumeFromCC <= 0.65f) {
      _volumePackageImageView.image = [UIImage imageWithContentsOfFile:kTwoSpeakerImage];
    }

    if (_currentVolumeFromCC >= 0.68f) {
      _volumePackageImageView.image = [UIImage imageWithContentsOfFile:kMaxSpeakerImage];
    }

     else if (_currentVolumeFromCC == 0) {

      _volumePackageImageView.image = [UIImage imageWithContentsOfFile:kMutedImage];
    }

    else if (_currentVolumeFromCC <= 0.3125f) {
      _volumePackageImageView.image = [UIImage imageWithContentsOfFile:kOneSpeakerImage];
    }

    if (_currentVolumeFromCC == 1.0) {
      //make the volume hud speaker image animate with a pulse when it hits 100%
      [UIView animateWithDuration:0.2 animations:^{
        _volumePackageImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL f){
        [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
            _volumePackageImageView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL f){
           
        }];
    }];
    }

}

-(void)viewDidLoad {

self.view.userInteractionEnabled = YES;
self.view.frame = CGRectMake(3.74219,30,56,140);

[self setupImageViewBasedOnPercentage];
//[self setupPanGesture];

_newBackdropView = [[%c(_MTBackdropView) alloc] init];
_newBackdropView.frame = self.view.frame;
_newBackdropView.bounds = self.view.bounds;
_newBackdropView.opaque = YES;
_newBackdropView.layer.masksToBounds = YES;
_newBackdropView.clipsToBounds = YES;
_newBackdropView.layer.cornerRadius = 19.0;
_newBackdropView.layer.continuousCorners = YES;
_newBackdropView.groupName = kStyleString;
_newBackdropView.blurRadius = 15.0;
[self.view addSubview:_newBackdropView];

_newCCUIContent = [[%c(CCUIContentModuleContentContainerView) alloc] init];
_newCCUIContent.frame = self.view.frame;
_newCCUIContent.materialViewGroupName = kStyleString;
_newCCUIContent.userInteractionEnabled = YES;
[self.view addSubview:_newCCUIContent];

_newVolumeViewController = [[%c(CCUIAudioModuleViewController) alloc] init];
_newVolumeViewController.view.frame =CGRectMake(0,0,56,140);
_newVolumeViewController.view.userInteractionEnabled = YES;
[_newCCUIContent addSubview:_newVolumeViewController.view];
[_newCCUIContent addSubview:_volumePackageImageView];

}
@end

%group Rishima
%hook SBHUDView
-(void)layoutSubviews {
     if (kEnabled && ![self isKindOfClass:%c(SBRingerHUDView)] && kUseVolumeHUD) {
  for(UIView *subviews in self.subviews) {
        [subviews removeFromSuperview];
    }
    [self setUserInteractionEnabled:YES];

  self.frame = [[UIScreen mainScreen] bounds];
      [self performSelector:@selector(setupNewHUDView)];

}
   if (kEnabled && [self isKindOfClass:%c(SBRingerHUDView)]) {
      for(UIView *subviews in self.subviews) {
        [subviews removeFromSuperview];
    }
    [self setUserInteractionEnabled:YES];

  self.frame = [[UIScreen mainScreen] bounds];
      [self performSelector:@selector(setupNewRingerHUDView)];
    }


      else {
        %orig;
      }
}

%new -(void)setupNewRingerHUDView {
  newRingerHUDVC = [[%c(iKARingerHUDViewController) alloc] init];
  newRingerHUDVC.shouldAppearDark = kDarkMode;
  [self addSubview:newRingerHUDVC.view];
  [self showRingerHUDView];
}


%new -(void)showRingerHUDView {
      if (!mediaController.isRingerMuted && self.hidden == NO) {

      [UIView animateWithDuration:2.0 animations:^{

      ringerHUDTransition = [CATransition animation];
        ringerHUDTransition.duration = 0.7;//kAnimationDuration
        ringerHUDTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        ringerHUDTransition.type = kCATransitionMoveIn;
        ringerHUDTransition.subtype = kCATransitionFromBottom;
        [newRingerHUDVC.view.layer addAnimation:ringerHUDTransition forKey:nil];
        
    } completion:^(BOOL f){
            ringerHUDTransition = nil;
        }];

}

    }

%new 
-(void)setupNewHUDView {

newContentView = [[%c(iKilledAppl3ControlCenterAudioForSpringBoard) alloc] init];

    [self addSubview:newContentView.view];


}

%end

%hook SBHUDController

%new -(void)hideRingerHUDView {
      if (!newRingerHUDVC.view.hidden) {

      [UIView animateWithDuration:2.0 animations:^{

         CATransition *transition = [CATransition animation];
        transition.duration = 2.0;//kAnimationDuration
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [newRingerHUDVC.view.layer addAnimation:transition forKey:nil];
        
    } completion:^(BOOL f){
           newRingerHUDVC.view.alpha = 0.0;
           newRingerHUDVC.view.hidden = YES;
        }];

}
  }

-(void)presentHUDView:(SBHUDView *)arg1 autoDismissWithDelay:(double)arg2 {
  if (kEnabled && ![arg1 isKindOfClass:%c(SBRingerHUDView)] && ![rController _canChangeRingtoneWithButtons] && kUseVolumeHUD) {
   
    arg2 = 99999999;
     %orig;
      _transition = [CATransition animation];
    _transition.duration = 0.5;//kAnimationDuration
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = kCATransitionMoveIn;
    _transition.subtype =kCATransitionFromLeft;
    [arg1.layer addAnimation:_transition forKey:nil];
  }

   if (kEnabled && [arg1 isKindOfClass:%c(SBRingerHUDView)]) {
   
   //By making the autoDismissWithDelay = 999999999 we basically invalidate the dismiss delay >:) 
    arg2 = 999999999;
    %orig;

           [self performSelector:@selector(hideRingerHUDView) withObject:nil afterDelay:99999999999.0];
  }
  

  else {
    %orig;
  }

}
%end

%hook SBHUDWindow
-(BOOL)_ignoresHitTest {
    if (kEnabled) {
      return NO;
       [self setUserInteractionEnabled:YES];
    }

    else {
      return %orig;
    }
}

-(id)hitTest:(CGPoint)arg1 withEvent:(id)arg2 {
    if (kEnabled) {
     if (CGRectContainsPoint(newContentView.view.frame, arg1)) {
          return [newContentView.view hitTest:arg1 withEvent:arg2];
     }
    }

    return %orig;
}
%end 

//post notifications when ringer volume changes:
%hook VolumeControl

%new -(void)presentNewRingerHUDUI {
  [newRingerHUDVC viewWillAppear:YES];
}

-(void)_presentVolumeHUDWithMode:(int)arg1 volume:(float)arg2  {
  if (kEnabled && arg1 == 1) {
       UIProgressView *progressView = [newRingerHUDVC valueForKey:@"ringerProgressView"];
       AVSystemController *newSysController = [%c(AVSystemController) sharedAVSystemController];
       [newSysController setVolumeTo:progressView.progress forCategory:@"Ringtone"];

   [self presentNewRingerHUDUI];

  }

  else {
    %orig;
  }

}
%end

%hook SBVolumeHUDView 
-(void)setMode:(int)arg1 {
    if (kEnabled) {
      %orig;
      if (self.mode == 1) {
         
        //[dangOldHUD setupNewRingerHUDView];
      }
    }

    else {
      %orig;
    }
}
%end
%end

extern NSString *const HBPreferencesDidChangeNotification;

%ctor {

  %init(Rishima);

   preferences = [[HBPreferences alloc] initWithIdentifier:@"com.ikilledappl3.rishima"];

  [preferences registerBool:&kEnabled default:NO forKey:@"kEnabled"];
  [preferences registerBool:&kUseVolumeHUD default:YES forKey:@"kUseVolumeHUD"];
  [preferences registerBool:&kDarkMode default:YES forKey:@"kDarkMode"];
}
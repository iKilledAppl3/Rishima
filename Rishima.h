#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <sys/sysctl.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+DCAnimationKit.h"
#import "CCUICAPackageView.h"

#define kStyleString @"CCUIContentModuleCotainerViewControllerGroupName"


//created by iKilledAppl3 on June 3rd, 2019 at 1:11 am

//Images 
NSString *kMutedImage = @"/Library/Application Support/Rishima/VolumeMuted@2x.png";
NSString *kOneSpeakerImage = @"/Library/Application Support/Rishima/VolumeMin@2x.png";
NSString *kTwoSpeakerImage = @"/Library/Application Support/Rishima/VolumeMid@2x.png";
NSString *kMaxSpeakerImage = @"/Library/Application Support/Rishima/VolumeMax@2x.png"; 

//Thansk to andywiik and laughingquoll!
extern NSString* const kCAFilterDestOut;


@interface AVSystemController : NSObject
+(id)sharedAVSystemController;
-(BOOL)getVolume:(float)volume forCategory:(id)category;
-(id)volumeCategoryForAudioCategory:(id)audioCategory;
-(BOOL)setVolumeTo:(float)to forCategory:(id)category;
@end

@interface CALayer (Private)

@property (nonatomic, assign) BOOL continuousCorners;
@property (nonatomic, retain) NSString *compositingFilter;
@property (nonatomic, assign) BOOL allowsGroupOpacity;
@property (nonatomic, assign) BOOL allowsGroupBlending;

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

@interface MTMaterialView : UIView {
	BOOL _cornerRadiusIsContinuous;
}
@property (nonatomic, copy, readwrite) NSString *groupName;
@property (assign,nonatomic) CGFloat weighting;
- (double)_continuousCornerRadius;
@end


@interface CCUIContentModuleContentContainerView : UIView {
	MTMaterialView *_moduleMaterialView;
}
@property (nonatomic, copy, readwrite) NSString *materialViewGroupName;
@end

@interface CCUIModuleSliderView : UIView 
@end

@interface CCUIVolumeSliderView : CCUIModuleSliderView {
}
-(id)initWithFrame:(CGRect)frame;
@end

@interface CCUIAudioModuleViewController : UIViewController 
@property (nonatomic, readwrite) BOOL onScreenForVolumeDisplay;
@property (nonatomic, readwrite) BOOL providesOwnPlatter;
-(id)initWithNibName:(id)arg1 bundle:(id)arg2;
@end


@interface SBVolumeHardwareButtonActions : NSObject
-(void)volumeIncreasePressDown;
-(void)volumeDecreasePressDown;
@end

@interface iKilledAppl3ControlCenterAudioForSpringBoard : UIViewController {
	CCUIAudioModuleViewController *_newVolumeViewController;
	UIImageView *_volumePackageImageView;
	CCUIContentModuleContentContainerView *_newCCUIContent;
	_MTBackdropView *_newBackdropView;
	CGFloat _currentVolumeFromCC;
	UIPanGestureRecognizer *_newPanGesture;
	UILabel *_volLabel;
	UILabel *_speakerLabel;
}
//@property (nonatomic, readwrite) BOOL isVCExpanded;
-(void)viewDidLoad;
-(void)setupImageViewBasedOnPercentage;
//-(void)showFullViewController:(BOOL)showMe;
//-(void)shrinkViewBasedOnButtonPress:(BOOL)hideMe;
-(void)setupPanGesture;
-(void)pannedTheVolume:(UIPanGestureRecognizer *)recognizer;
-(void)setupLabelViews;
@end


//Thanks to @nepeta :P
@interface SBHUDWindow : UIWindow {

}
-(BOOL)_ignoresHitTest;
@end

@interface SBHUDView : UIView 
@property(nonatomic) float progress;
-(void)setupNewHUDView;
-(void)setupNewRingerHUDView;
-(void)showRingerHUDView;
@end

@interface SBHUDController : NSObject {
	SBHUDView *_hudView;
}
+(id)sharedHUDController;
-(void)presentHUDView:(SBHUDView *)arg1 autoDismissWithDelay:(double)arg2;
-(void)hideHUDView;
-(void)hideRingerHUDView;
@end


@interface VolumeControl : NSObject 
+(id)sharedVolumeControl;
-(BOOL)headphonesPresent;
-(void)presentNewRingerHUDUI;
-(float)volume;
@end

@interface SBVolumeHUDView : SBHUDView
-(int)mode;
@end


BOOL kEnabled;
BOOL kUseVolumeHUD;
BOOL kDarkMode;

HBPreferences *preferences;
iKilledAppl3ControlCenterAudioForSpringBoard *newContentView;
CATransition *_transition; 

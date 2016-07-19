//
//  ViewController.m
//  HCMotion
//
//  Created by ZHC on 16/7/19.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface ViewController ()
{
    CMMotionManager *manager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    manager = [[CMMotionManager alloc]init];
    ViewController * __weak weakSelf = self;
//    if (manager.accelerometerAvailable) {
//        manager.accelerometerUpdateInterval = 0.1f;
//        [manager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
//                                      withHandler:^(CMAccelerometerData *data, NSError *error) {
//                                          double rotation = atan2(data.acceleration.x, data.acceleration.y) - M_PI;
//                                          NSLog(@"x-->%0.2f , y-->%0.2f , z-->%0.2f ",data.acceleration.x,data.acceleration.y,data.acceleration.z);
//                                          weakSelf.imageview.transform = CGAffineTransformMakeRotation(rotation);
//                                      }];
//    }
    
    
//    if (manager.deviceMotionAvailable) {
//        manager.deviceMotionUpdateInterval = 0.1f;
//        [manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
//                                     withHandler:^(CMDeviceMotion *data, NSError *error) {
//                                         double rotation = atan2(data.gravity.x, data.gravity.y) - M_PI;
//                                          NSLog(@"gravity :x-->%0.2f , y-->%0.2f , z-->%0.2f \n",data.gravity.x,data.gravity.y,data.gravity.z);
//                                          NSLog(@"userAcceleration :x-->%0.2f , y-->%0.2f , z-->%0.2f \n",data.userAcceleration.x,data.userAcceleration.y,data.userAcceleration.z);
//                                         NSLog(@"rotationRate :x-->%0.2f , y-->%0.2f , z-->%0.2f \n",data.rotationRate.x,data.rotationRate.y,data.rotationRate.z);
//                                         NSLog(@"_________________________________________________________________");
//                                         weakSelf.imageview.transform = CGAffineTransformMakeRotation(rotation);
//                                     }];
//    }
//
    manager.gyroUpdateInterval = 0.1;
    [manager startGyroUpdates];
    manager.gyroData;
    CMAttitude *initialAttitude = manager.deviceMotion.attitude;
    __block BOOL showingPrompt = NO;// trigger values - a gap so there isn't a flicker zone
    double showPromptTrigger = 1.0f;
    double showAnswerTrigger = 0.8f;
    
    if (manager.deviceMotionAvailable) {
        [manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                     withHandler:^(CMDeviceMotion *data, NSError *error) {
                                         // translate the attitude
                                         [data.attitude multiplyByInverseOfAttitude:initialAttitude];
                                         // calculate magnitude of the change from our initial attitude
                                         double magnitude = [ViewController magnitudeFromAttitude:data.attitude];
                                         // show the prompt
                                         if (!showingPrompt && (magnitude > showPromptTrigger)) {
                                             showingPrompt = YES;
//                                             PromptViewController *promptViewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"PromptViewController"];
//                                             promptViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                             UIViewController *vc = [[UIViewController alloc]init];
                                             
                                             [weakSelf presentViewController:vc animated:YES completion:nil];
                                         }
                                         // hide the prompt
                                         if (showingPrompt && (magnitude < showAnswerTrigger)) {
                                             showingPrompt = NO;
                                             [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                         }
                                     }];
    }
}


+(double)magnitudeFromAttitude:(CMAttitude *)attitude {
    return sqrt(pow(attitude.roll, 2.0f) + pow(attitude.yaw, 2.0f) + pow(attitude.pitch, 2.0f));
}


@end

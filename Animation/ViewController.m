//
//  ViewController.m
//  Animation
//
//  Created by S2-10 on 2016/01/29.
//  Copyright © 2016年 S2-10. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>{
    IBOutlet UIView *calayeranimeView;
    IBOutlet UIView *uiviewanimeView;
    IBOutlet UISegmentedControl *viewchangeSegment;
    
    IBOutlet UIImageView *nikuImageView;
    IBOutlet UIImageView *pandaImageView;
    
    IBOutlet UITextField *fromTextField;
    IBOutlet UITextField *toTextField;
    IBOutlet UISegmentedControl *rotateSegment;
    IBOutlet UITextField *durationTextField;
    IBOutlet UISwitch *autoreversSwitch;
    IBOutlet UISegmentedControl *repeatSegment;
    IBOutlet UISegmentedControl *fillmodeSegment;
    IBOutlet UISwitch *removeSwitch;
    
    IBOutlet UITextField *angleTextField;
    IBOutlet UITextField *duration2TextField;
    IBOutlet UITextField *delayTextField;
    IBOutlet UITextField *scaleTextField;
    IBOutlet UISegmentedControl *optionsSegment;
    IBOutlet UISegmentedControl *completionSegment;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    calayeranimeView.hidden = NO;
    uiviewanimeView.hidden = YES;
    
    fromTextField.text = @"0";
    toTextField.text = @"90";
    durationTextField.text = @"3";
    
    angleTextField.text = @"90";
    duration2TextField.text = @"3";
    delayTextField.text = @"1";
    scaleTextField.text = @"1.5";
    
    fromTextField.delegate = self;
    toTextField.delegate = self;
    durationTextField.delegate = self;
    angleTextField.delegate = self;
    duration2TextField.delegate = self;
    delayTextField.delegate = self;
    scaleTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeViewSegment:(id)sender {
    switch (viewchangeSegment.selectedSegmentIndex) {
        case 0:
            calayeranimeView.hidden = NO;
            uiviewanimeView.hidden = YES;
            break;
        case 1:
            calayeranimeView.hidden = YES;
            uiviewanimeView.hidden = NO;
            break;
        default:
            break;
    }
}

- (IBAction)pushCABasicAnimationButton:(id)sender {
    // アニメーションを初期化する
    // アニメーションのキーパスを"transform"にする
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"transform"];
    // デリゲートを設定する
    anime.delegate = self;
    // 回転の開始と終わりの角度を設定する（単位はラジアン）
    double fromValue = [fromTextField.text doubleValue];
    double toValue = [toTextField.text doubleValue] * M_PI / 180;
    anime.fromValue = [NSNumber numberWithDouble:fromValue];
    anime.toValue = [NSNumber numberWithDouble:toValue];
    // 回転軸を設定
    switch (rotateSegment.selectedSegmentIndex) {
        case 0:
            anime.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateX];
            break;
        case 1:
            anime.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateY];
            break;
        case 2:
            anime.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
            break;
        default:
            break;
    }
    // 1回あたりのアニメーション時間（単位は秒）
    anime.duration = [durationTextField.text doubleValue];
    // アニメーションが終わった後に反対向きにアニメーションする
    anime.autoreverses = autoreversSwitch.isOn;
    // アニメーションのリピート回数
    switch (repeatSegment.selectedSegmentIndex) {
        case 0:
            anime.repeatCount = 1;
            break;
        case 1:
            anime.repeatCount = 2;
            break;
        case 2:
            anime.repeatCount = HUGE_VALF;    //無制限
            break;
        default:
            break;
    }
    // アニメーション終了後に回転した位置が元に戻らないようにする
    switch (fillmodeSegment.selectedSegmentIndex) {
        case 0:
            anime.fillMode = kCAFillModeForwards;
            break;
        case 1:
            anime.fillMode = kCAFillModeRemoved;
            break;
        case 2:
            anime.fillMode = kCAFillModeBackwards;
            break;
        default:
            break;
    }
    anime.removedOnCompletion = removeSwitch.isOn;
    // アニメーションをレイヤーにセットする
    [nikuImageView.layer addAnimation:anime forKey:@"nikuAnime"];
}

- (IBAction)pushUIViewAnimationButton:(id)sender {
    // アフィン変換の設定をクリアしてイメージビューを元に戻す
    pandaImageView.transform = CGAffineTransformIdentity;
    // 回転の角度を設定する（単位はラジアン）
    double angle = [angleTextField.text doubleValue] * M_PI / 180;
    // 拡大率を設定する
    double scalex = [scaleTextField.text doubleValue];
    double scaley = [scaleTextField.text doubleValue];
    // アニメーションする時間を設定する（単位は秒）
    double duration = [duration2TextField.text doubleValue];
    // アニメーションが開始する前の待ち時間を設定する（単位は秒）
    double delay = [delayTextField.text doubleValue];
    // アニメーションのオプションを設定する
    int option = 0;
    switch (optionsSegment.selectedSegmentIndex) {
        case 0:
            option = UIViewAnimationOptionCurveLinear;
            break;
        case 1:
            option = UIViewAnimationOptionCurveEaseIn;
            break;
        case 2:
            option = UIViewAnimationOptionCurveEaseOut;
            break;
        default:
            break;
    }
    
    // アニメーションを実行する
    [UIView animateWithDuration:duration
                          delay:delay
                        options:option
                     animations:^{
                         // アフィン変換で角度を変える
                         pandaImageView.transform = CGAffineTransformMakeRotation(angle);
                     }
                     completion:^(BOOL finished){
                         // 上のアニメーションが終わった後に実行する処理
                         if (completionSegment.selectedSegmentIndex == 0) {
                             [UIView animateWithDuration:duration
                                                   delay:delay
                                                 options:option
                                              animations:^{
                                                  pandaImageView.transform = CGAffineTransformMakeRotation(angle * 2);
                                              }
                                              completion:nil
                              ];
                         }else if (completionSegment.selectedSegmentIndex == 1) {
                             [UIView animateWithDuration:duration
                                                   delay:delay
                                                 options:option
                                              animations:^{
                                                  pandaImageView.transform = CGAffineTransformMakeScale(scalex, scaley);
                                              }
                                              completion:nil
                              ];
                         }
                     }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end

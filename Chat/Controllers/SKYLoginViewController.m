//
//  SKYLoginViewController.m
//  Chat
//
//  Created by sky on 14/12/18.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "SKYLoginViewController.h"
#import "EaseMob.h"
#import "NSString+Valid.h"
#import "MBProgressHUD.h"
#import "TTGlobalUICommon.h"


NSString * const KNOTIFICATION_LOGINCHANGE = @"com.bluesky.chat.loginStateChange";

@interface SKYLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation SKYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(UIButton *)sender {
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        if ([self.usernameTextField.text isChinese]) {
            TTAlertNoTitle(@"用户名不支持中文");
            return;
        }
#if !TARGET_IPHONE_SIMULATOR
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"填写推送消息时使用的昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *nameTextField = [alert textFieldAtIndex:0];
        nameTextField.text = self.usernameTextField.text;
        [alert show];
#elif TARGET_IPHONE_SIMULATOR
        [self loginWithUsername:_usernameTextField.text password:_passwordTextField.text];
#endif
    }

}

- (IBAction)registerAction:(UIButton *)sender {
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        if ([self.usernameTextField.text isChinese]) {
            TTAlertNoTitle(@"用户名不支持中文");
            return;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在注册...";
        hud.removeFromSuperViewOnHide = YES;
        
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_usernameTextField.text
                                                             password:_passwordTextField.text
                                                       withCompletion:
         ^(NSString *username, NSString *password, EMError *error) {
             [hud hide:YES];
             
             if (!error) {
                 TTAlertNoTitle(@"注册成功,请登录");
             }else{
                 switch (error.errorCode) {
                     case EMErrorServerNotReachable:
                         TTAlertNoTitle(@"连接服务器失败!");
                         break;
                     case EMErrorServerDuplicatedAccount:
                         TTAlertNoTitle(@"您注册的用户已存在!");
                         break;
                     case EMErrorServerTimeout:
                         TTAlertNoTitle(@"连接服务器超时!");
                         break;
                     default:
                         TTAlertNoTitle(@"注册失败");
                         break;
                 }
             }
         } onQueue:nil];
    }
}


- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    if (username.length == 0 || password.length == 0) {
        ret = YES;
    }
    
    return ret;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录...";
    hud.removeFromSuperViewOnHide = YES;

    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [hud hide:YES];
         if (loginInfo && !error) {
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
         }else {
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(@"连接服务器失败!");
                     break;
                 case EMErrorServerAuthenticationFailure:
                     TTAlertNoTitle(@"用户名或密码错误");
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(@"连接服务器超时!");
                     break;
                 default:
                     TTAlertNoTitle(@"登录失败");
                     break;
             }
         }
     } onQueue:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

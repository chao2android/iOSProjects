//
//  JYAddressBookAuthorityView.swift
//  friendJY
//
//  Created by aaa on 15/6/25.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

import UIKit

class JYAddressBookAuthorityView: UIView {
    
    
    override init(frame: CGRect) {
        let title = "你可能错过了好友的动态"
        let otis = "友寻要访问你的通讯录被阻止了"
        let guide = "请在手机“设置”-“隐私”-“通讯录”中，打开友寻通讯录服务开关"
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        let window = UIView(frame: UIApplication.sharedApplication().keyWindow!.bounds)
        window.backgroundColor = UIColor.blackColor()
        window.alpha = 0.8;
        self.addSubview(window)
        
        let backBg = UIView(frame: CGRectMake((frame.size.width - 270)/2,(frame.size.height - 250)/2,270 ,250))
        backBg.backgroundColor = UIColor.whiteColor()
        self.addSubview(backBg)

        let noFriendTopBg = UIImageView(frame: CGRectMake(0, 0, backBg.width, 45))
        noFriendTopBg.image = UIImage(named: "feedExportPhoneListBg");
        backBg.addSubview(noFriendTopBg)
        
        let titleLabel = UILabel(frame: CGRectMake(0, 15, backBg.width, 20))
        titleLabel.text = title
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont.systemFontOfSize(16)
        noFriendTopBg.addSubview(titleLabel)

        let noFriendTopContent = UILabel(frame: CGRectMake(10, titleLabel.bottom+15, titleLabel.width-20, 120))
//        noFriendTopContent.backgroundColor = UIColor.yellowColor() 
        noFriendTopContent.text = "友寻要访问你的通讯录被阻止了。\n\n\n请在手机“设置”-“隐私”-“通讯录”中，打开友寻通讯录服务开关。";
        noFriendTopContent.textAlignment = NSTextAlignment.Center
        noFriendTopContent.textColor = UIColor.blackColor()
        noFriendTopContent.font = UIFont.systemFontOfSize(14)
        noFriendTopContent.numberOfLines = 0
        backBg.addSubview(noFriendTopContent)
        
        var noFriendButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        noFriendButton.setBackgroundImage(UIImage(named: "feedExportPhoneListBg"), forState: UIControlState.Normal)
        noFriendButton.backgroundColor = UIColor.clearColor()
        noFriendButton.setTitle("确定", forState: UIControlState.Normal)
        noFriendButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        noFriendButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        noFriendButton.frame = CGRectMake((backBg.width - 250)/2, noFriendTopContent.bottom + 15, 250, 44)
        noFriendButton.addTarget(self, action:Selector("gotoSystemSettringClickOk"), forControlEvents: UIControlEvents.TouchUpInside)
        backBg.addSubview(noFriendButton)
        
    }
    func gotoSystemSettringClickOk(){
        println("gotoSystemSettringClickOk")
        
//        [gotoSystemSettringBox removeFromSuperview];
//        if(SYSTEM_IS_IOS8){
//            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                [[UIApplication sharedApplication] openURL:url];
//            }
//        }
        
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        if UIApplication.sharedApplication().canOpenURL(url!){
            UIApplication.sharedApplication() .openURL(url!)
        }
        
        self.removeFromSuperview()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

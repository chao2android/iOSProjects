//
//  JYGuideIntoAddressBookView.swift
//  friendJY
//
//  Created by aaa on 15/6/25.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

import UIKit

class JYGuideIntoAddressBookView: UIView {
    
    var oitsBtn : UIButton?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backBg = UIView(frame: frame)
        backBg.backgroundColor = UIColor.blackColor()
        backBg.alpha = 0.8
        self.addSubview(backBg)
        
        let noFriendInviteShow = UIView(frame: CGRectMake((frame.size.width-270)/2,(frame.size.height - 330)/2,270 ,330))
        noFriendInviteShow.backgroundColor = UIColor.whiteColor()
        self.addSubview(noFriendInviteShow)
        
        
        let noFriendTopBg = UIImageView(frame: CGRectMake(0, 0, noFriendInviteShow.width, 45))
        noFriendTopBg.image = UIImage(named: "feedExportPhoneListBg")
        noFriendInviteShow .addSubview(noFriendTopBg)
        
        let noFriendTopTitle = UILabel(frame: CGRectMake(0, 15, noFriendInviteShow.width, 20))
        noFriendTopTitle.text = "你可能错过了好友的动态"
        noFriendTopTitle.textAlignment = NSTextAlignment.Center
        noFriendTopTitle.textColor = UIColor.whiteColor()
        noFriendTopTitle.font = UIFont.systemFontOfSize(16)
        noFriendInviteShow.addSubview(noFriendTopTitle)
        
        let noFriendPhoneListIcon = UIImageView(frame: CGRectMake((noFriendInviteShow.width-100)/2, noFriendTopBg.bottom + 25, 100, 100))
        noFriendPhoneListIcon.image = UIImage(named: "feedPhoneListIcon")
        noFriendInviteShow.addSubview(noFriendPhoneListIcon)
        
        let noFriendTopContent = UILabel(frame: CGRectMake(10, noFriendPhoneListIcon.bottom+15, noFriendInviteShow.width-20, 60))
        noFriendTopContent.text = "友寻需要同步您的通讯录，仅用来识别您的好友。通过通讯录找到正在使用友寻好友，并且为您严格保密。"
        noFriendTopContent.textAlignment = NSTextAlignment.Left
        noFriendTopContent.textColor = UIColor.blackColor()
        noFriendTopContent.font = UIFont.systemFontOfSize(14)
        noFriendTopContent.numberOfLines = 0
        noFriendInviteShow.addSubview(noFriendTopContent)
        
        let noFriendButton :UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        noFriendButton.setBackgroundImage(UIImage(named: "feedExportPhoneListBg"), forState: UIControlState.Normal)
        noFriendButton.backgroundColor = UIColor.clearColor()
        noFriendButton.setTitle("查找通讯录好友", forState: UIControlState.Normal)
        noFriendButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        noFriendButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        noFriendButton.frame = CGRectMake((noFriendInviteShow.width - 250)/2, noFriendTopContent.bottom + 10, 250, 44)
        noFriendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        noFriendButton.addTarget(self, action: Selector("_noFriendButtonClick"), forControlEvents: UIControlEvents.TouchUpInside)
        noFriendInviteShow.addSubview(noFriendButton)
        
        
        let newsDelBtn :UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        newsDelBtn.frame = CGRectMake(noFriendInviteShow.right-20,noFriendInviteShow.top-20,40 ,40)
        newsDelBtn.setImage(UIImage(named: "feedGetPhoneClose"), forState: UIControlState.Normal)
        newsDelBtn.addTarget(self, action: Selector("_noFriendCloseButtonClick"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(newsDelBtn)
        
    }
    func _noFriendCloseButtonClick(){
        print("removeFromSuperview")
        self.removeFromSuperview()
    }
    func _noFriendButtonClick(){
        oitsBtn?.hidden = true
        self.removeFromSuperview()
        JYShareData.sharedInstance().upListAndShowProgress(true)
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

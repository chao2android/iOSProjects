//
//  JYGuideToAddressBookManager.swift
//  friendJY
//
//  Created by aaa on 15/7/1.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

import UIKit

class JYGuideToAddressBookManager: NSObject {
   
    class func HaveIntoAddressBook() -> Bool{
        let myUid:NSString? = NSUserDefaults.standardUserDefaults().objectForKey("uid") as?NSString
        var isUpList :Bool? = NSUserDefaults.standardUserDefaults().objectForKey("\(myUid)_IsUpList") as?Bool
        let call_upload :NSString = (JYShareData.sharedInstance()).myself_profile_model.callno_upload
        let upload :Bool = call_upload.isEqualToString("0")
        
        if let myBool = isUpList{
            
        }else{
            isUpList = false
        }
        return (!isUpList! && upload) //true 没导入过
    }
    
    class func CountNumToAddressBook() ->(){
        //判断有没有到如果通讯录
        if JYGuideToAddressBookManager.HaveIntoAddressBook(){
            //没有导入过--》计算次数
            //先取
            let myUid:NSString? = NSUserDefaults.standardUserDefaults().objectForKey("uid") as?NSString
            var oldNum :NSInteger? = NSUserDefaults.standardUserDefaults().objectForKey("\(myUid)_CountAddFriendNum")?.integerValue
            if let myOldNum = oldNum{
                
            }else{
                oldNum = 0
            }
            
            if oldNum==1{
                //是第二次，需要提示导入
                oldNum = 0
                NSUserDefaults.standardUserDefaults().setValue(NSNumber(integer:oldNum!), forKey: "\(myUid)_CountAddFriendNum")
                NSUserDefaults.standardUserDefaults().synchronize()
                let winsow :UIWindow = JYAppDelegate.sharedAppDelegate().window
                winsow.addSubview(JYGuideIntoAddressBookView(frame: CGRectMake(0, 0, winsow.size.width, winsow.size.height)))
            }else{
                //是第一次， num++
                oldNum = oldNum!+1
                NSUserDefaults.standardUserDefaults().setValue(NSNumber(integer:oldNum!), forKey: "\(myUid)_CountAddFriendNum")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
}




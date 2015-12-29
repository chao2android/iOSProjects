//
//  JYContactProfileController.swift
//  friendJY
//
//  Created by chenxiangjing on 15/6/24.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

import UIKit
import MessageUI

class JYContactProfileController: JYBaseController,MFMessageComposeViewControllerDelegate {
    
    var name        : String?
    var phone       : String?
    var promptLabel : UILabel?
    var tagListView : JYProfileTagListView?
    var addTagView  : JYContactProfileAddTagView?
    /**
    life cycle
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutSubviews()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func layoutSubviews(){
        
        self.title = name!
        
        var profileLabel = UILabel(frame: CGRectMake(15, 20, self.view.bounds.width-30, 20))
        profileLabel.font = UIFont.systemFontOfSize(15)
        profileLabel.textColor = UIColor.blackColor()
        profileLabel.text = "TA的资料"
        self.view.addSubview(profileLabel)
        
        var profileSection = UIView(frame: CGRectMake(-1, 40, self.view.bounds.width+2, 100))
        profileSection.layer.borderWidth = 1.0
        profileSection.layer.borderColor = JYHelpers.setFontColorWithString("#cccccc").CGColor
        profileSection.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(profileSection)
        
        
        var defaultAvatar = UIImageView(frame: CGRectMake(16, 20, 60, 60))
        defaultAvatar.image = UIImage(named: "pic_morentouxiang_man")
        profileSection.addSubview(defaultAvatar)
        
        var nameLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(defaultAvatar.frame) + 20, 20, 240, 20))
        nameLabel.font = UIFont.systemFontOfSize(15)
    
        var attributeString = NSMutableAttributedString(string: "手机联系人： "+name!)
        attributeString.addAttributes([NSForegroundColorAttributeName : JYHelpers.setFontColorWithString("#2695ff")], range: NSMakeRange(count("手机联系人： "), count(name!)))
        nameLabel.attributedText = attributeString
        
        profileSection.addSubview(nameLabel)
        
        var phoneLabel = UILabel(frame: CGRectMake(nameLabel.left, nameLabel.bottom + 5, nameLabel.width, nameLabel.height))
        phoneLabel.font = UIFont.systemFontOfSize(15)
        phoneLabel.textColor = UIColor.blackColor()
        phoneLabel.text = "手机号: "+phone!
        profileSection.addSubview(phoneLabel)
        
        var tagImageView = UIImageView(frame: CGRectMake(profileSection.right - 42, 0, 41, 41))
        tagImageView.image = UIImage(named: "dimensional_1")
        profileSection.addSubview(tagImageView)
        
        var tagLabel = UILabel(frame: CGRectMake(15, profileSection.bottom+40, 100, 20))
        tagLabel.text = "标签"
        tagLabel.font = UIFont.systemFontOfSize(15)
        tagLabel.textColor = UIColor.blackColor()
        tagLabel.backgroundColor = UIColor.clearColor()
        self.view.addSubview(tagLabel)
        
        var tagSection = UIView(frame: CGRectMake(-1, tagLabel.bottom, profileSection.width, 100))
        tagSection.backgroundColor = UIColor.whiteColor()
        tagSection.layer.borderColor = JYHelpers.setFontColorWithString("#cccccc").CGColor
        tagSection.layer.borderWidth = 1.0
        self.view .addSubview(tagSection)

        tagListView  = JYProfileTagListView()
        tagListView?.setDefaultAttribute("123", width: tagSection.width - 32, tagList: NSDictionary() as [NSObject : AnyObject], oringinal: CGPointMake(16, 10))
        
        tagListView?.addTagBlock = ({()->() in
        
          self.tagHimClicked()
        })
        
        tagSection.addSubview(tagListView!)
        tagSection.height = tagListView!.height + 20
        
        var textStr = "TA在你心中是个什么样的人呢？给TA打个标签来说说吧！"
        var height = (textStr as NSString).boundingRectWithSize(CGSizeMake(self.view.width - 30, 1000.0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15)], context: nil).height
        
        promptLabel = UILabel(frame: CGRectMake(15, tagSection.bottom+10, self.view.width-30, height))
        promptLabel?.numberOfLines = 0
        promptLabel?.textColor = UIColor.darkGrayColor()
        promptLabel?.font = UIFont.systemFontOfSize(15)
        promptLabel?.textAlignment = NSTextAlignment.Center
        promptLabel?.text = textStr
        self.view.addSubview(promptLabel!)
        
        var inviteHimButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        inviteHimButton.frame = CGRectMake(0, self.view.height - 64 - 49, self.view.width, 49)
        inviteHimButton.backgroundColor = JYHelpers.setFontColorWithString("#2695ff")
        inviteHimButton.setTitle("邀请TA加入友寻", forState: UIControlState.Normal)
        inviteHimButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        inviteHimButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        inviteHimButton.addTarget(self, action: "invite", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(inviteHimButton)
        
        addTagView = JYContactProfileAddTagView(frame: UIScreen.mainScreen().bounds)
//        addTagView?.layoutMySubviews()
        JYAppDelegate.sharedAppDelegate().window.addSubview(addTagView!)
        addTagView?.hidden = true
    }

    func tagHimClicked(){
    
        println("tagHim")

        addTagView?.show()
    }
    
    func invite(){
        
        if !MFMessageComposeViewController.canSendText() {
            JYAppDelegate.sharedAppDelegate().showTip("当前设备不支持发送短信的功能")
            return
        }
        var messageController = MFMessageComposeViewController()
        messageController.recipients = [phone!];
        
        var uid: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("uid")
        
        messageController.body = "快来【友寻】和我一起认识更多靠谱的朋友，朋友的朋友一秒变好友。和朋友的朋友谈恋爱，顺手解救身边的单身朋友，变身朋友圈丘比特。http://m.iyouxun.com/wechat/friend_invite/?uid=\(uid)"
        messageController.messageComposeDelegate = self;

        self.showProgressHUD("请稍后...", toView: self.view)
        self.presentViewController(messageController, animated: true, completion: ({()->() in
            self.dismissProgressHUDtoView(self.view)
        }))
    }

    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        switch result.value {
        case MessageComposeResultSent.value:
            println("sent")
        case MessageComposeResultCancelled.value:
            println("cancelled")
        case MessageComposeResultFailed.value:
            println("failed")
        default:
            println("error")
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    func keyboardWillChangeFrame(aNotification : NSNotification){
        
        addTagView?.keyboardWillChangeFrame(aNotification)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

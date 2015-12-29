//
//  JYContactProfileAddTagView.swift
//  friendJY
//
//  Created by chenxiangjing on 15/7/3.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

import UIKit

class JYContactProfileAddTagView: UIView,UITextFieldDelegate {

    private var blackBg                : UIView?
    private var addTagBg               : UIView?
    private var inputTagBackgroundView : UIView?
    
    var recommendTagView       : JYRecommendTagView?
    var newTagTextField        : JYBaseTextField?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.layoutMySubviews()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutMySubviews(){
        
        blackBg = UIView(frame: self.bounds)
        blackBg?.backgroundColor = UIColor.blackColor()
        blackBg?.alpha = 0.8
        self.addSubview(blackBg!)
        
        addTagBg = UIView(frame: CGRectMake(0, self.height - 185.0, self.width, 185.0))
        addTagBg?.backgroundColor = JYHelpers.setFontColorWithString("#edf1f4")
        self.addSubview(addTagBg!)
        
        var tagLabel = UILabel(frame: CGRectMake(15, 15, 10, 20))
        var text : NSString = "我眼中的TA"
        var myWidth = text.boundingRectWithSize(CGSizeMake(self.width, 20), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15)], context: nil).width
        tagLabel.width = myWidth
        tagLabel.backgroundColor = UIColor.clearColor()
        tagLabel.textColor = JYHelpers.setFontColorWithString("#848484")
        tagLabel.text = text as String
        tagLabel.font = UIFont.systemFontOfSize(15)
        
        addTagBg?.addSubview(tagLabel)
        
        var closeBtn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        closeBtn.frame = CGRectMake(self.width - 15-10-10, 15-10, 30, 30)
//        closeBtn.backgroundColor = UIColor.orangeColor()
        closeBtn.backgroundColor = UIColor.clearColor()
        closeBtn.setImage(UIImage(named: "find_close"), forState: UIControlState.Normal)
        closeBtn.showsTouchWhenHighlighted = false
        closeBtn.addTarget(self, action: "hide", forControlEvents: UIControlEvents.TouchUpInside)
        addTagBg?.addSubview(closeBtn)
        
        recommendTagView = JYRecommendTagView()
        //高度设置为10 调用layoutSubviews方法可以自动调整
        recommendTagView?.frame = CGRectMake(10, tagLabel.bottom, self.width - 20, 10)
        recommendTagView?.myLayoutSubviews([])
        addTagBg?.addSubview(recommendTagView!)
        
        inputTagBackgroundView = UIView(frame: CGRectMake(0, recommendTagView!.bottom + 15, self.width, 0))
        inputTagBackgroundView?.backgroundColor = UIColor.clearColor()
        addTagBg?.addSubview(inputTagBackgroundView!)
        
        var lineView = UIView(frame: CGRectMake(15, 0, self.width - 15, 1))
        lineView.layer.masksToBounds = true
        lineView.layer.cornerRadius = 1.0
        lineView.backgroundColor = JYHelpers.setFontColorWithString("#b9b9b9")
        inputTagBackgroundView?.addSubview(lineView)
        
//        var addTagLabel = UILabel(frame: CGRectMake(15, lineView.bottom + 15, 0, 30))
//        addTagLabel.backgroundColor = UIColor.whiteColor()
//        addTagLabel.textAlignment = NSTextAlignment.Center
//        addTagLabel.textColor = UIColor.blackColor()
//        addTagLabel.layer.borderWidth = 1
//        addTagLabel.layer.borderColor = JYHelpers.setFontColorWithString("#cccccc").CGColor
//        addTagLabel.font = UIFont.systemFontOfSize(15)
//        myWidth = JYHelpers.getTextWidthAndHeight("手动添加", fontSize: 15).width
//        addTagLabel.width = myWidth
//        addTagLabel.text = "手动添加"
//        inputTagBackgroundView?.addSubview(addTagLabel)
        
        newTagTextField = JYBaseTextField(frame: CGRectMake(15, lineView.bottom+15, self.width - 15 - 15 - 5 - 60/*确定button的宽*/, 30))
        newTagTextField?.returnKeyType = UIReturnKeyType.Done
        newTagTextField?.limitedLength = 10
        newTagTextField?.backgroundColor = UIColor.whiteColor()
        newTagTextField?.layer.borderColor = JYHelpers.setFontColorWithString("#cccccc").CGColor
        newTagTextField?.layer.borderWidth = 1
        newTagTextField?.setValue(UIFont.systemFontOfSize(15), forKeyPath: "_placeholderLabel.font")
        newTagTextField?.font = UIFont.systemFontOfSize(15)
        newTagTextField?.placeholder = " 输入新标签"
//        newTagTextField.textRectForBounds(CGRectMake(10, 0, newTagTextField.width - 10, newTagTextField.height))
        newTagTextField?.delegate = self
//        newTagTextField?.textAlignment = NSTextAlignment.Center
        inputTagBackgroundView?.addSubview(newTagTextField!)
        
        var confirmBtn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        confirmBtn.frame = CGRectMake(newTagTextField!.right + 5, newTagTextField!.top, 60, newTagTextField!.height)
        confirmBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        confirmBtn.backgroundColor = JYHelpers.setFontColorWithString("#2695ff")
        confirmBtn.setTitle("确定", forState: UIControlState.Normal)
        confirmBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmBtn.addTarget(self, action: "confirmClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        inputTagBackgroundView?.addSubview(confirmBtn)
        
        inputTagBackgroundView?.height = confirmBtn.bottom + 20
        addTagBg?.height = inputTagBackgroundView!.bottom
        
        addTagBg?.frame = CGRectMake(0, self.height, self.width, addTagBg!.height)
        
    }
    func show(){
    
        self.hidden = false
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.addTagBg?.origin = CGPointMake(0, self.height - addTagBg!.height)
        })
        
    }
    func hide(){
        
        if newTagTextField!.isFirstResponder(){
            newTagTextField?.resignFirstResponder()
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.addTagBg?.origin = CGPointMake(0, self.height)
        }) { (finished) -> Void in
            self.hidden = true
        }
    }
    
    func confirmClicked(){
        
        if let text = newTagTextField?.text{
            if let handler = recommendTagView?.clickHandler{
                handler(text)
            }
        }
        self.hide()

    }
    func keyboardWillChangeFrame(aNotification : NSNotification){
        
        if let userInfo = aNotification.userInfo as? Dictionary<String,AnyObject>{
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
            let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
            
            UIView.animateWithDuration(duration!, animations: { () -> Void in
                self.addTagBg?.frame = CGRectMake(0, endFrame!.origin.y - addTagBg!.height, addTagBg!.width, addTagBg!.height)
            })

        }
//        println(duration)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func reloadRecommendTagView(tagTitles:[String]){
        recommendTagView?.myLayoutSubviews(tagTitles)
        inputTagBackgroundView?.origin = CGPointMake(0, recommendTagView!.bottom+15)
        addTagBg?.height = inputTagBackgroundView!.bottom
        
        addTagBg?.origin = CGPointMake(0, self.height - addTagBg!.height)
    }
//    func closeClicked(){
//        self.hidden = true
//    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

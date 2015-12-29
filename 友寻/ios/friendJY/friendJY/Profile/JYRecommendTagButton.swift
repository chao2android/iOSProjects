//
//  JYRecommendTagButton.swift
//  friendJY
//
//  Created by chenxiangjing on 15/6/29.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

import UIKit
/**
*  标签加上一个+的小视图
*/
class JYRecommendTagButton: UIView {
    
    var title : String
    var addImgView : UIImageView?

    init(frame: CGRect, aTitle : String) {
        title = aTitle
        super.init(frame: frame)
        self.myLayoutSubviews()
    
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    class func getMyWidth(title:String){
//    
//    }
    func myLayoutSubviews(){
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = JYHelpers.setFontColorWithString("#cccccc").CGColor
        self.layer.borderWidth = 1.0
        
        var width = JYHelpers.getTextWidthAndHeight(title, fontSize: 15).width
        var titleLabel = UILabel(frame: CGRectMake(5, 0, width, 30))
        titleLabel.text = title
//        titleLabel.backgroundColor = UIColor.orangeColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = JYHelpers.setFontColorWithString("#2695ff")
        titleLabel.font = UIFont.systemFontOfSize(15)
        
        self.addSubview(titleLabel)
        
        addImgView = UIImageView(frame: CGRectMake(titleLabel.right+5, 5, 20.0, 20.0))
        addImgView?.userInteractionEnabled = true
        addImgView?.image = UIImage(named: "profile_addtag")
        self.addSubview(addImgView!)
        
        self.frame = CGRectMake(self.left, self.top, addImgView!.right+6.0, self.height)
        
    }
    //本来是只要在addImgView上加手势的  需求改了，直接改这个方法简单些，虽然看起来很奇怪
    func addTapGesture(aGesture : UITapGestureRecognizer){
        self.addGestureRecognizer(aGesture)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

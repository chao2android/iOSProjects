//
//  JYRecommendTagView.swift
//  friendJY
//
//  Created by chenxiangjing on 15/6/30.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

import UIKit


class JYRecommendTagView: UIScrollView {
    //显示的推荐标签
    var recommendTagArr : [String]?
    //点击推荐标签之后回调控制器处理的 闭包
    var clickHandler    : ((String)->())?

    
    func myLayoutSubviews(recommendTags : [String]){
        //每一次刷新需要清除之前添加的标签视图
        for aView in self.subviews{
            if let anotherView = aView as? UIView{
                anotherView.removeFromSuperview()
            }
        }
        recommendTagArr = recommendTags
        
        var aBottom : CGFloat = 0.0;
        var pointStart = ( x:self.bounds.origin.x, y:self.bounds.origin.y)
        if count(recommendTags) == 0{
            var noTagLabel = UILabel(frame: CGRectMake(pointStart.x+5, pointStart.y+10, 120, 30))
            noTagLabel.text = "暂无推荐标签"
            noTagLabel.font = UIFont.systemFontOfSize(15)
            noTagLabel.textColor = JYHelpers.setFontColorWithString("#848484")
            noTagLabel.tag = 1234
            noTagLabel.backgroundColor = UIColor.clearColor()
            self.addSubview(noTagLabel)
            aBottom = noTagLabel.bottom
        }else {
            

            for var i = 0; i < count(recommendTagArr!);i++ {
                var title = recommendTagArr![i]
                var button = JYRecommendTagButton(frame: CGRectMake(pointStart.x+5, pointStart.y+10, 10, 30), aTitle: title)
                if button.right > self.width{
                    button.frame = CGRectMake(5, pointStart.y + 50, button.width, button.height)
                    pointStart = (5+button.width,pointStart.y+40)
                    
                }else{
                    pointStart = (button.right,pointStart.y)
                }
                
                button.tag = 101+i
                var aTapGesture = UITapGestureRecognizer(target: self, action: "tagClicked:")
                button.addTapGesture(aTapGesture)
                self.addSubview(button)
                aBottom = button.bottom
            }
        }
        self.height = aBottom
    }
    /**
    点击推荐标签
    
    :param: aTap 点击手势
    */
    func tagClicked(aTap : UITapGestureRecognizer){
        var index = (aTap.view?.tag)!-101
        var title = recommendTagArr![index]
        //点击回调
        if let handler = clickHandler {
            handler(title)
        }
    
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

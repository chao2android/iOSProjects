//
//  JYGuideToAddressBookCell.swift
//  friendJY
//
//  Created by aaa on 15/6/30.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

import UIKit

class JYGuideToAddressBookCell: UITableViewCell {
    
    var aBlock :(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clearColor()
        
        let width = UIApplication.sharedApplication().keyWindow?.bounds.width
        
        var back = UIView(frame: CGRectMake(5, 0, width!-10, 40))
        back.backgroundColor = JYHelpers.setFontColorWithString("#2695ff")
        back.layer.borderColor = JYHelpers .setFontColorWithString("#e2e5e7").CGColor
        back.layer.borderWidth = 1;
        self.contentView.addSubview(back)
        
        var title = UILabel(frame: CGRectMake(0, 0, back.bounds.size.width-60, 40))
        title.text = "立即导入通讯录，看看好友在干嘛"
        title.textColor = UIColor.whiteColor()
        title.textAlignment = NSTextAlignment.Center
        title.font = UIFont.systemFontOfSize(14)
        back.addSubview(title)
        
        var cancle : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        cancle.frame = CGRectMake(back.bounds.size.width-60, 0, 60, 40)
        cancle.addTarget(self, action: Selector("Cancle"), forControlEvents: UIControlEvents.TouchUpInside)
        back.addSubview(cancle)
        
        var image = UIImageView(frame: CGRectMake(20, 10, 20, 20))
        image.image = UIImage(named: "feedNewsTipsDelete")
        cancle.addSubview(image)
        
    }
    func Cancle(){
        self.aBlock!()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

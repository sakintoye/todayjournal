//
//  PostTableViewCell.swift
//  weather-journal
//
//  Created by Luke Geiger on 6/29/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    /**
    The big label!
    */
    var prominentLabel:UILabel?
    
    /**
    A small label beneath the big label.
    */
    var prominentSubLabel:UILabel?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.prominentLabel = UILabel.new()
        self.prominentLabel?.textAlignment = NSTextAlignment.Center
        self.prominentLabel?.font = UIFont.boldAppFontOfSize(40)
        self.prominentLabel?.textColor = UIColor.appDarkGreyColor()
        self.contentView.addSubview(self.prominentLabel!)
        
        self.prominentSubLabel = UILabel.new()
        self.prominentSubLabel?.textAlignment = NSTextAlignment.Center
        self.prominentSubLabel?.font = UIFont.appFontOfSize(10)
        self.prominentSubLabel?.textColor = UIColor.appGreyColor()
        self.prominentSubLabel?.numberOfLines = 2;
        self.contentView.addSubview(self.prominentSubLabel!)
        
        self.textLabel?.font = UIFont.boldAppFontOfSize(14)
        self.detailTextLabel?.font = UIFont.appFontOfSize(12)
        self.detailTextLabel?.numberOfLines = 3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.textLabel?.y = 10;
        
        self.prominentLabel?.frame = CGRectMake(0, self.textLabel!.y, 75, self.height - 40)
        self.prominentSubLabel?.frame = CGRectMake(self.prominentLabel!.x,self.prominentLabel!.bottomY,self.prominentLabel!.width,30)

        self.textLabel?.x = self.prominentLabel!.endX
        self.textLabel?.width = self.width - self.textLabel!.x

        self.detailTextLabel?.x = self.textLabel!.x
        self.detailTextLabel?.width = self.textLabel!.width
        self.detailTextLabel?.y = self.textLabel!.bottomY;
        
    }

}

//
//  TableViewCell.swift
//  sort
//
//  Created by Spiro Mifsud on 1/20/17.
//  Copyright © 2017 Material Cause LLC. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell
{
    var label:UILabel!
    var label2:UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
    };
    
    public func setText (line1:String,line2:String)
    {
        self.label = UILabel(frame: CGRect(x: 15, y: 0,width: UIScreen.main.bounds.width-31, height: 34))
        self.label.text = line1;
        self.label.font = label.font.withSize(16)
        self.addSubview(self.label)
        
        self.label2 = UILabel(frame: CGRect(x: 15, y: 23,width: UIScreen.main.bounds.width-31, height: 34))
        self.label2.text = line2;
        self.label2.textColor = UIColor.gray
        self.label2.font = label.font.withSize(14)
        self.addSubview(self.label2)
    };
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    };
    
    override func prepareForReuse()
    {
        self.label.removeFromSuperview();
        self.label2.removeFromSuperview();
        self.label = nil;
        self.label2 = nil;
    };
};

//
//  FundTableViewCell.swift
//  Spending Management
//
//  Created by CNTT on 5/12/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class FundTableViewCell: UITableViewCell {
    
    //PropoType
    @IBOutlet weak var lblLichSu: UILabel!
    @IBOutlet weak var lblTien: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

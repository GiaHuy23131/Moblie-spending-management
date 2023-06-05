//
//  ChiPhiTableViewCell.swift
//  QuanLyChiTieu
//
//  Created by CNTT on 5/24/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class ChiPhiTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTen: UILabel!
    
    @IBOutlet weak var lblTien: UILabel!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

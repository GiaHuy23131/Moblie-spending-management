//
//  Fund.swift
//  Spending Management
//
//  Created by CNTT on 5/7/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class Fund {
    //MARK: Properties
    private var soTien:Double
    private var tongTien:Double
    private var dateTime:String
    private var ghiChu:String
    private var lichSu:String
    
    //MARK: Contructers
    init?(soTien:Double,tongTien:Double, dateTime:String, ghiChu:String, lichSu:String) {
        //kiểm tra xem có tạo được đối tượng meal hay không
        if (soTien < 0){
            return nil
        }
        if lichSu.isEmpty{
            return nil
        }
        //khởi gán giá trị cho đối tượng
        self.soTien = soTien
        self.tongTien = tongTien
        self.dateTime = dateTime
        self.ghiChu = ghiChu
        self.lichSu = lichSu
    }
    public func getSoTien() ->Double {
        return soTien
    }
    public func getTongTien() ->Double {
        return tongTien
    }
    public func getDataTime() ->String {
        return dateTime
    }
    public func getGhiChu() ->String {
        return ghiChu
    }
    public func getLichSu() ->String {
        return lichSu
    }
    //


}

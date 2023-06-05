//
//  ChiPhi.swift
//  QuanLyChiTieu
//
//  Created by CNTT on 5/24/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class ChiPhi{
    //MARK: Properties
    private var soTien:Double
    private var dateTime:String
    private var taiKhoan:String
    private var ghiChu:String
    private var danhMuc:DanhMuc
    private var lichSu:String
    
    //MARK: Contructers
    init?(soTien:Double, dateTime:String,taiKhoan:String, ghiChu:String, danhMuc:DanhMuc, lichSu:String) {
        //kiểm tra xem có tạo được đối tượng meal hay không
        if (soTien < 0){
            return nil
        }
        if lichSu.isEmpty{
            return nil
        }
        //khởi gán giá trị cho đối tượng
        self.soTien = soTien
        self.dateTime = dateTime
        self.taiKhoan = taiKhoan
        self.ghiChu = ghiChu
        self.danhMuc = danhMuc
        self.lichSu = lichSu
    }
    public func getSoTien() ->Double {
        return soTien
    }
    public func getDataTime() ->String {
        return dateTime
    }
    public func getTaiKhoan() ->String {
        return taiKhoan
    }
    
    public func getGhiChu() ->String {
        return ghiChu
    }
    
    public func getDanhMuc() ->DanhMuc {
        return danhMuc
    }
    public func getLichSu() ->String {
        return lichSu
    }}

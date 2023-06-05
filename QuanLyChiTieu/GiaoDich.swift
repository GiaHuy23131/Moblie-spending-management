//
//  DanhMuc.swift
//  DoAn
//
//  Created by CNTT on 5/24/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import Foundation
import UIKit

class GiaoDich {
    //properties
    private var id:Int
    private var ghiChu:String
    private var hinhDanhMuc:UIImage
    private var soTien:Int
    private var loai:Int
    //private var mauSac:UIColor
    
    
    init(id:Int, ghiChu:String, hinhDanhMuc:UIImage, soTien:Int, loai:Int) {
        self.id = id
        self.ghiChu = ghiChu
        self.hinhDanhMuc = hinhDanhMuc
        //self.mauSac = mauSac
        self.soTien = soTien
        self.loai = loai
    }
    
    var Id:Int {
        get {
            return self.id
        }
        set {
            return self.id = newValue
        }
    }
    
    var GhiChu:String{
        get {
            return self.ghiChu
        }
        set {
            self.ghiChu = newValue
        }
    }
    
    var HinhDanhMuc:UIImage{
        get {
            return self.hinhDanhMuc
        }
        set {
            self.hinhDanhMuc = newValue
        }
    }
    
//    var MauSac:UIColor {
//        get {
//            return self.mauSac
//        }
//        set {
//            self.mauSac = newValue
//        }
//    }
    
    var Loai:Int {
        get {
            return self.loai
        }
        set {
            self.loai = newValue
        }
    }
    
    var SoTien:Int {
        get {
            return self.soTien
        }
        set {
            self.soTien = newValue
        }
    }
    
    //Getter Setter
//    public func getRed()->CGFloat {
//        var redComponent: CGFloat = 0
//        mauSac.getRed(&redComponent, green: nil, blue: nil, alpha: nil)
//        return redComponent
//    }
//
//    public func getGreen()->CGFloat {
//        var greenComponent: CGFloat = 0
//        mauSac.getRed(nil, green: &greenComponent, blue: nil, alpha: nil)
//        return greenComponent
//    }
//    
//    public func getBlue()->CGFloat {
//        var blueComponent: CGFloat = 0
//        mauSac.getRed(nil, green: nil, blue: &blueComponent, alpha: nil)
//        return blueComponent
//    }
    
    
    
}

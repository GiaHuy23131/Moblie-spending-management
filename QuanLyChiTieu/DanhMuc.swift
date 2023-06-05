	//
//  DanhMuc.swift
//  QuanLyChiTieu
//
//  Created by CNTT on 5/24/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

    import UIKit
    
    class DanhMuc {
        private var id:Int
        private var tenDanhMuc:String
        private var hinhDanhMuc:UIImage
        
        private var chiTieu:Int
        private var loai:Int
        
        
        private var mauSac:UIColor
        //    private var red:Float
        //    private var green:Float
        //    private var blue:Float
        //    private var alpha:Float = 1
        
        //    init(tenDanhMuc:String, hinhDanhMuc:UIImage, mauSac:UIColor) {
        //        self.tenDanhMuc = tenDanhMuc
        //        self.hinhDanhMuc = hinhDanhMuc
        //        self.mauSac = mauSac
        //    }
        
        
        init(id:Int, tenDanhMuc:String, hinhDanhMuc:UIImage, mauSac:UIColor, chiTieu:Int, loai:Int) {
            self.id = id
            self.tenDanhMuc = tenDanhMuc
            self.hinhDanhMuc = hinhDanhMuc
            self.mauSac = mauSac
            self.chiTieu = chiTieu
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
        
        var TenDanhMuc:String{
            get {
                return self.tenDanhMuc
            }
            set {
                self.tenDanhMuc = newValue
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
        
        var MauSac:UIColor {
            get {
                return self.mauSac
            }
            set {
                self.mauSac = newValue
            }
        }
        
        var Loai:Int {
            get {
                return self.loai
            }
            set {
                self.loai = newValue
            }
        }
        
        var ChiTieu:Int {
            get {
                return self.chiTieu
            }
            set {
                self.chiTieu = newValue
            }
        }
        
        //Getter Setter
        public func getRed()->CGFloat {
            var redComponent: CGFloat = 0
            mauSac.getRed(&redComponent, green: nil, blue: nil, alpha: nil)
            return redComponent
        }
        
        public func getGreen()->CGFloat {
            var greenComponent: CGFloat = 0
            mauSac.getRed(nil, green: &greenComponent, blue: nil, alpha: nil)
            return greenComponent
        }
        
        public func getBlue()->CGFloat {
            var blueComponent: CGFloat = 0
            mauSac.getRed(nil, green: nil, blue: &blueComponent, alpha: nil)
            return blueComponent
        }
        
        
        
    }

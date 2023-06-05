//
//  ColorViewController.swift
//  DoAn
//
//  Created by CNTT on 5/24/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBAction func btnSaveAction(_ sender: UIBarButtonItem) {
        
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "DanhMucDetailViewController") as! DanhMucDetailViewController
        //        detail.imgDanhMuc.backgroundColor = UIColor(red: color.Red/255, green: color.Green/255, blue: color.Blue/255, alpha: 1)
        
        danhMuc.MauSac = UIColor(red: color.Red/255, green: color.Green/255, blue: color.Blue/255, alpha: 1)
        if danhMuc.Id != -1 {
            detail.sDanhMuc = danhMuc
            detail.navigationType = .editDanhMuc
        }
        else{
            detail.sDanhMuc = danhMuc
            detail.navigationType = .newDanhMuc
        }
        
        detail.customColor = UIColor(red: color.Red/255, green: color.Green/255, blue: color.Blue/255, alpha: 1)
        self.navigationController?.popViewController(animated: false)
        
    }
    
    
    
    
    var color:Color!
    var sColor:UIColor?
    var danhMuc:DanhMuc!
    
    //    enum NavigationType {
    //        case newDanhMuc
    //        case editDanhMuc
    //    }
    //
    //    var navigationType:NavigationType = .newDanhMuc
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        color = Color(red: redSlider.value, green: greenSlider.value, blue: blueSlider.value)
        displayLabel.text = color.getString()
        displayView.backgroundColor = color.getColor()
        
        
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        if (sender.tag == 1) {
            color.setRed(red: sender.value)
            displayLabel.text = color.getString()
            displayView.backgroundColor = color.getColor();
        }
        else if (sender.tag == 2) {
            color.setGreen(green: sender.value)
            displayLabel.text = color.getString()
            displayView.backgroundColor = color.getColor();
        }
        else if (sender.tag == 3) {
            color.setBlue(blue: sender.value)
            displayLabel.text = color.getString()
            displayView.backgroundColor = color.getColor();
        }
    }
    
    // Chuan bi du lieu va gui di truoc khi chuyen man hinh
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("Chuan bi du lieu truoc khi chuyen man hinh")
        
        // Xac dinh tac nhan chuyen man hinh
        if let btnBarItem = sender as? UIBarButtonItem {
            // Neu dung la btnSave
            if (btnBarItem === btnSave) {
                // Tao bien meal moi va luu trong bien thanh phan meal cua lop
                sColor = UIColor(red: color.Red/255, green: color.Green/255, blue: color.Blue/255, alpha: 1)
            }
        }else {
            // Tac nhan khong phai la UIBarButtonItem
            print("Chuyen sang man hinh khac")
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

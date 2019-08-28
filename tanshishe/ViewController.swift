//
//  ViewController.swift
//  tanshishe
//
//  Created by xiaofeng on 2019/8/26.
//  Copyright © 2019 xiaofeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let SPEED: Int = 10
    let FRAME_TIME: Float = 0.2
    
    var timer: Timer?
    var mBtnType: Int = -2
    var mBtnTmpType: Int = -2
    
    var mIsVertical: Bool = false
    var mMoveLenth: Int = 0;
    
    @IBOutlet weak var mCoustomView: CustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.FRAME_TIME), target: self, selector: #selector(ViewController.run), userInfo: nil, repeats: true)
    }
    
    @objc func run() {
        if 0 == self.mBtnType {
            return
        }
        let value = self.mBtnType - self.mBtnTmpType
        if !(0 == value || 2 == abs(value)) {
            switch mBtnType {
            case 1:
                self.mIsVertical = true
                self.mMoveLenth = -self.SPEED
            case 2:
                self.mIsVertical = false
                self.mMoveLenth = -self.SPEED
            case 3:
                self.mIsVertical = true
                self.mMoveLenth = self.SPEED
            case 4:
                self.mIsVertical = false
                self.mMoveLenth = self.SPEED
            default:
                self.mMoveLenth = 0
                self.mBtnType = -2
            }
        }
        self.mBtnTmpType = self.mBtnType
        self.mCoustomView.updateArgs(self, self.mIsVertical, CGFloat(self.mMoveLenth))
    }
    
    @IBAction func moveUp(_ sender: Any) {
        self.mBtnType = 1;
    }
    
    @IBAction func moveDown(_ sender: Any) {
        self.mBtnType = 3;
    }
    
    @IBAction func moveLeft(_ sender: Any) {
        self.mBtnType = 2;
    }
    
    @IBAction func moveRight(_ sender: Any) {
        self.mBtnType = 4;
    }
}


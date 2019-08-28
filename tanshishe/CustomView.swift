//
//  CustomView.swift
//  tanshishe
//
//  Created by xiaofeng on 2019/8/26.
//  Copyright © 2019 xiaofeng. All rights reserved.
//

import UIKit
import GameplayKit

class CustomView: UIView {
    let SIZE: Int = 20    // 食物刷新边界
    let foodSize: CGSize = CGSize(width: 10, height: 10)    // 食物大小
    var foodPoint: CGPoint = CGPoint(x: 0, y: 0)    // 食物位置坐标
    var foodRect: CGRect = CGRect()    // 食物矩形
    
    var bodyPoints: [CGPoint] = []     // 身体矩形中心点集合
    var bodyTmpPoints: [CGPoint] = []
    var bodyRects: [CGRect] = []     // 身体矩形集合
    var mScore: Int = 0    // 分数
    
    var mRandomX: GKRandomDistribution?
    var mRandomY: GKRandomDistribution?
    
    var mController: ViewController?
    var mIsFinish: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initArgs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initArgs()
    }
    
    private func initArgs() {
        self.mRandomX = GKRandomDistribution(lowestValue: self.SIZE, highestValue: Int(self.frame.width) - self.SIZE)
        self.mRandomY = GKRandomDistribution(lowestValue: self.SIZE, highestValue: Int(self.frame.height) - self.SIZE)
        
        // 食物初始化
        self.foodPoint = self.randomPoint()
        self.foodRect.size = self.foodSize
        
        // 蛇身初始化
        self.bodyPoints.append(self.randomPoint())
        self.bodyRects.append(CGRect(origin: self.bodyPoints[0], size: self.foodSize))
    }
    
    private func randomPoint() -> CGPoint {
        return CGPoint(x: self.mRandomX!.nextInt(), y: self.mRandomY!.nextInt())
    }
    
    public func updateArgs(_ controller: ViewController, _ isVertical: Bool, _ moveLength: CGFloat) {
        if self.mIsFinish {
            return
        }
        self.mController = controller
        let bodyCount = bodyPoints.count - 1
        self.bodyTmpPoints = self.bodyPoints
        // 身体各中心点位置对应
        if 1 <= bodyCount {
            for index in 1...bodyCount {
                bodyPoints[index] = self.bodyTmpPoints[index - 1]
            }
        }
        if isVertical {
            self.bodyPoints[0].y += moveLength
        } else {
            self.bodyPoints[0].x += moveLength
        }
        self.bodyRects[0].origin = self.bodyPoints[0]
        
        // 吃到食物尾巴增长
        if self.bodyRects[0].intersects(self.foodRect) {
            self.mScore += 1
            self.bodyRects.append(CGRect(origin: CGPoint(x: 0, y: 0), size: self.foodSize))
            if 0 == bodyCount {
                self.appendBodyPoint(isVertical, bodyCount, moveLength)
            } else {
                let movX = self.bodyPoints[bodyCount - 1].x - self.bodyPoints[bodyCount].x
                let movY = self.bodyPoints[bodyCount - 1].y - self.bodyPoints[bodyCount].y
                let movL = 0 == movX ? movY : movX
                self.appendBodyPoint(0 == movX, bodyCount, movL)
            }
            self.foodPoint = self.randomPoint()
        }
        
        // 调整蛇身体
        let count = self.bodyRects.count - 1
        for i in 0...count {
            self.bodyRects[i].origin = self.bodyPoints[i]
        }
        self.setNeedsDisplay()
    }
    
    private func appendBodyPoint(_ isVertical: Bool, _ bodyCount: Int, _ moveLength: CGFloat) {
        if isVertical {
            self.bodyPoints.append(CGPoint(x: self.bodyPoints[bodyCount].x, y: self.bodyPoints[bodyCount].y - moveLength))
        } else {
            self.bodyPoints.append(CGPoint(x: self.bodyPoints[bodyCount].x - moveLength, y: self.bodyPoints[bodyCount].y))
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 获取绘图上下文
        let context = UIGraphicsGetCurrentContext()
        
        // 绘制食物
        self.foodRect.origin = self.foodPoint
        context?.fill(foodRect)
        
        // 绘制蛇身
        context?.setFillColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context?.fill(self.bodyRects)
        
        // 撞墙判定
        if self.bodyRects[0].minX <= 0 || self.bodyRects[0].minY <= 0 || self.bodyRects[0].maxX >= self.frame.width || self.bodyRects[0].maxY >= self.frame.height || self.isInBody() {
            self.reStart()
        }
    }
    
    private func isInBody() -> Bool {
        if 1 >= self.bodyRects.count {
            return false
        }
        for i in 1...(self.bodyRects.count - 1) {
            if self.bodyRects[0].intersects(self.bodyRects[i]) {
                return true
            }
        }
        return false
    }
    
    private func reStart() {
        mIsFinish = true
        let dialog = UIAlertController(title: "提示", message: "游戏失败，分数：\(self.mScore)", preferredStyle:.alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: {(action: UIAlertAction) -> Void  in
            exit(0)
        })
        dialog.addAction(action)
        self.mController?.present(dialog, animated: true, completion: nil)
    }
}

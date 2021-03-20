//
//  VerticalBarChartView.swift
//  SCharts
//
//  Created by ginokeos hasee mac on 2021/3/20.
//

import UIKit

protocol VerticalBarChartViewDelegate {
    func titleForValue(at index: Int) -> String
    func colorForBar(at index: Int) -> UIColor
}

class VerticalBarDataView: UIView {
    
    var chartDelegate: VerticalBarChartViewDelegate?
    
    var datas: [Double] = [] {
        didSet {
            setMaxDataValue()
        }
    }
    
    var numericalLevel = 4
    
    var itemSpacing: CGFloat = 50
    
    var bottomHeight: CGFloat = 30
    
    var topHeight: CGFloat = 30
    
    var barColor: UIColor = .black
    
    var barWidth: CGFloat = 18
    
    private(set) var bars: [CAShapeLayer] = []
    
    private(set) var maxDataValue: Double = 0
    private func setMaxDataValue() {
        
        if datas.isEmpty { return }
        let max = datas.max { (a, b) -> Bool in
            return a < b
        }
        maxDataValue = max ?? 0
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    private func initViews() {
        
        
    }
    
    private var lineLayer: CAShapeLayer!
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let subs = layer.sublayers {
            for s in subs {
                s.removeFromSuperlayer()
            }
        }
        
        bars.removeAll()
        
        
        let fullHeight = rect.height - bottomHeight - topHeight
        
        for i in 0...numericalLevel {
            let b = UIBezierPath()
            let x: CGFloat = 0
            let y = topHeight + (fullHeight / CGFloat(numericalLevel) * CGFloat(i))
            b.move(to: CGPoint(x: x, y: y))
            b.addLine(to: CGPoint(x: rect.width, y: y))
            
            let bL = CAShapeLayer()
            bL.path = b.cgPath
            bL.lineWidth = 0.25
            bL.strokeColor = UIColor.lightGray.cgColor
            bL.lineDashPattern = [5,3]
            layer.addSublayer(bL)
        }
        
        
        for (index, item) in datas.enumerated() {
            
            let strAtt = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
                NSAttributedString.Key.foregroundColor: UIColor.black]
            let valueTitle = NSString(format: "%.2f", item)
            let tCalRect = valueTitle.boundingRect(with: CGSize(width: 36, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: strAtt, context: nil)
            
            
            
            let x = barWidth / 2 + itemSpacing * CGFloat(index)
            let h = CGFloat(item / maxDataValue) * fullHeight
            let y = rect.height - bottomHeight - h
            
            
            let bRect = CGRect(x: x, y: y, width: barWidth, height: h)
            let c = UIBezierPath(roundedRect: bRect, cornerRadius: 4)
            let cs = CAShapeLayer()
            cs.path = c.cgPath
            let bColor = chartDelegate?.colorForBar(at: index) ?? barColor
            cs.fillColor = bColor.cgColor
            layer.addSublayer(cs)
            bars.append(cs)
            
            
            let titleY = y - 8 - tCalRect.height
            let titleX = bRect.midX - tCalRect.width / 2
            let titleRect = CGRect(x: titleX, y: titleY, width: tCalRect.width, height: tCalRect.height)
            valueTitle.draw(with: titleRect, options: .usesLineFragmentOrigin, attributes: strAtt, context: nil)
            
            let bottomTitle = NSString(string: chartDelegate?.titleForValue(at: index) ?? "")
            let btRect = bottomTitle.boundingRect(with: CGSize(width: 36, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: strAtt, context: nil)
            
            let btdX = bRect.midX - btRect.width / 2
            
            let btdY = rect.height - bottomHeight + 8
            let btdRect = CGRect(x: btdX, y: btdY, width: btRect.width, height: btRect.height)
            
            bottomTitle.draw(with: btdRect, options: .usesLineFragmentOrigin, attributes: strAtt, context: nil)
            
            
        }
        
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private var lastBar: CAShapeLayer?
    
    private func setBarShadow(_ bar: CAShapeLayer) {
        
        bar.shadowPath = bar.path
        bar.shadowColor = UIColor.black.cgColor
        bar.shadowOpacity = 0.25
        bar.shadowOffset = .zero
        bar.shadowRadius = barWidth / 3
        
    }
    
    private func resetBarShadow(_ bar: CAShapeLayer) {
        
        bar.shadowPath = nil
        bar.shadowColor = nil
        bar.shadowOpacity = 0
        bar.shadowOffset = .zero
        bar.shadowRadius = 0
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let point = touches.first?.location(in: self) {
            let bar = bars.first { (d) -> Bool in
                if let path = d.path {
                    let m: CGFloat = 10
                    let x = path.boundingBox.minX - m
                    let w = path.boundingBox.maxX + m
                    if x < point.x  && point.x < w {
                        return true
                    } else {
                        return false
                    }
                } else { return false }
                
            }
            if let selectedBar = bar {
                if let ld = lastBar, !ld.isEqual(selectedBar) {
                    
                    resetBarShadow(ld)
                }
                lastBar = selectedBar
                setBarShadow(selectedBar)
            } else {
                if lastBar != nil {
                    resetBarShadow(lastBar!)
                }
            }
        }
        
    }
    
}


class VerticalBarChartView: UIView {
    
    var delegate: VerticalBarChartViewDelegate? {
        didSet {
            dataView.chartDelegate = delegate
        }
    }
    
    var dataView = VerticalBarDataView()
    
    var scroller = UIScrollView()
    
    var leftMargin: CGFloat = 24
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    func initViews() {
        
        
        
        scroller.showsHorizontalScrollIndicator = false
        scroller.showsVerticalScrollIndicator = false
        
        
        scroller.addSubview(dataView)
        scroller.backgroundColor = .white
        dataView.backgroundColor = .white
        backgroundColor = .white
    }
    
    func showAnimation() {
        
        UIView.animate(withDuration: 1, delay: 0.2, options: [.curveEaseInOut]) {
            self.scroller.setContentOffset(CGPoint(x: self.scroller.contentSize.width - self.scroller.frame.width, y: 0), animated: false)
        } completion: { (f) in
            if f {
                UIView.animate(withDuration: 1, delay: 0.2, options: [.curveEaseInOut], animations: {
                    self.scroller.setContentOffset(.zero, animated: false)
                }, completion: nil)
            }
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let subs = layer.sublayers {
            for s in subs {
                s.removeFromSuperlayer()
            }
        }
        
        for v in subviews {
            v.removeFromSuperview()
        }
        
        addSubview(scroller)
        
        let fullHeight = rect.height - dataView.bottomHeight - dataView.topHeight
        let level = dataView.numericalLevel
        let per = fullHeight / CGFloat(level)
        let perNum = dataView.maxDataValue / Double(dataView.numericalLevel)
        
        let strAtt = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
            NSAttributedString.Key.foregroundColor: UIColor.black]
        for i in 0...level {
            let titleNum = perNum * Double(level - i)
            let title = NSString(format: "%.0f", titleNum)
            
            let tCalRect = title.boundingRect(with: CGSize(width: 36, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: strAtt, context: nil)
            
            let x: CGFloat = leftMargin - tCalRect.width - 8
            let y = per * CGFloat(i) + dataView.topHeight - tCalRect.height / 2
            
            let titleRect = CGRect(x: x, y: y, width: tCalRect.width, height: tCalRect.height)
            title.draw(with: titleRect, options: .usesLineFragmentOrigin, attributes: strAtt, context: nil)
        }
        
        
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let edgeMargin: CGFloat = 0
        scroller.frame = CGRect(x: leftMargin, y: 0, width: frame.width - leftMargin - edgeMargin, height: frame.height)
        let dataW = CGFloat(dataView.datas.count - 1) * dataView.itemSpacing + dataView.barWidth * 2
        dataView.frame = CGRect(x: 0, y: 0, width: dataW, height: frame.height)
        scroller.contentSize = CGSize(width: dataW, height: frame.height)
        
    }
        
    
}

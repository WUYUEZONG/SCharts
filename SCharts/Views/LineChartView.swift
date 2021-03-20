//
//  LineChartView.swift
//  BX
//
//  Created by Ginokeo on 2021/3/19.
//

import UIKit

protocol LineChartViewDelegate {
    //func bottomTitleHeihgt() -> CGFloat
    func titleForValue(at index: Int) -> String
    func colorForDot(at index: Int) -> UIColor
}

class LineChartView: UIView {
    
    var delegate: LineChartViewDelegate? {
        didSet {
            dataView.chartDelegate = delegate
        }
    }
    
    var dataView = LineChartDataView()
    
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
        
        dataView.layerAnimation()
        UIView.animate(withDuration: 1, delay: 0.2, options: [.curveEaseInOut]) {
            self.scroller.setContentOffset(CGPoint(x: self.scroller.contentSize.width - self.frame.width, y: 0), animated: false)
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
        
        let fullHeight = rect.height - dataView.bottomHeight - 10
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
            let y = per * CGFloat(i) + 10 - tCalRect.height / 2
            
            let titleRect = CGRect(x: x, y: y, width: tCalRect.width, height: tCalRect.height)
            title.draw(with: titleRect, options: .usesLineFragmentOrigin, attributes: strAtt, context: nil)
        }
        
        
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let edgeMargin: CGFloat = 12
        scroller.frame = CGRect(x: leftMargin, y: 0, width: frame.width - leftMargin - edgeMargin, height: frame.height)
        let dataW = CGFloat(dataView.datas.count - 1) * dataView.itemSpacing + 30
        dataView.frame = CGRect(x: 0, y: 0, width: dataW, height: frame.height)
        scroller.contentSize = CGSize(width: dataW, height: frame.height)
        
    }
}


class LineChartDataView: UIView {
    
    var chartDelegate: LineChartViewDelegate?
    
    var datas: [Double] = [] {
        didSet {
            setMaxDataValue()
        }
    }
    
    var numericalLevel = 4
    
    var itemSpacing: CGFloat = 50
    
    var bottomHeight: CGFloat = 30
    
    var circleRaduis: CGFloat = 4
    
    var lineColor: UIColor = .black
    
    var isShowAnimation = true
    
    var marker = ChartMakerView()
    
    
    private(set) var dots: [CAShapeLayer] = []
    
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
        
        marker.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        marker.isHidden = true
    }
    
    private var lineLayer: CAShapeLayer!
    
    func layerAnimation() {
        if isShowAnimation {
            let a = CABasicAnimation(keyPath: "strokeEnd")
            a.toValue = 1
            a.timingFunction = CAMediaTimingFunction(name: .linear)
            a.duration = 1
            a.isRemovedOnCompletion = false
            a.fillMode = .forwards
            lineLayer.add(a, forKey: nil)
        }
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let subs = layer.sublayers {
            for s in subs {
                s.removeFromSuperlayer()
            }
        }
        
        addSubview(marker)
        
        dots.removeAll()
        
        let topMargin: CGFloat = 10
        let fullHeight = rect.height - bottomHeight - topMargin
        
        for i in 0...numericalLevel {
            let b = UIBezierPath()
            let x: CGFloat = 0
            let y = topMargin + (fullHeight / CGFloat(numericalLevel) * CGFloat(i))
            b.move(to: CGPoint(x: x, y: y))
            b.addLine(to: CGPoint(x: rect.width, y: y))
            
            let bL = CAShapeLayer()
            bL.path = b.cgPath
            bL.lineWidth = 0.25
            bL.strokeColor = UIColor.lightGray.cgColor
            bL.lineDashPattern = [5,3]
            layer.addSublayer(bL)
        }
        
        let b = UIBezierPath()
        for (index, item) in datas.enumerated() {
            
            let strAtt = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
                NSAttributedString.Key.foregroundColor: UIColor.black]
            let title = NSString(string: chartDelegate?.titleForValue(at: index) ?? "")
            let tCalRect = title.boundingRect(with: CGSize(width: 36, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: strAtt, context: nil)
            
            let x = tCalRect.width / 2 + itemSpacing * CGFloat(index)
            let y = (1 - CGFloat(item / maxDataValue)) * fullHeight + topMargin
            if index == 0 {
                b.move(to: CGPoint(x: x, y: y))
            } else {
                b.addLine(to: CGPoint(x: x, y: y))
            }
            
            let c = UIBezierPath(roundedRect: CGRect(x: x - circleRaduis, y: y - circleRaduis, width: circleRaduis * 2, height: circleRaduis * 2), cornerRadius: circleRaduis)
            let cs = CAShapeLayer()
            cs.path = c.cgPath
            let dotColor = chartDelegate?.colorForDot(at: index) ?? lineColor
            cs.fillColor = dotColor.cgColor
            cs.shadowPath = c.cgPath
            cs.shadowColor = dotColor.cgColor
            cs.shadowRadius = 4
            cs.shadowOpacity = 0.2
            layer.addSublayer(cs)
            dots.append(cs)
            
            
            let titleY = rect.height - bottomHeight + topMargin
            let titleX = x - tCalRect.width / 2
            let titleRect = CGRect(x: titleX, y: titleY, width: tCalRect.width, height: tCalRect.height)
            title.draw(with: titleRect, options: .usesLineFragmentOrigin, attributes: strAtt, context: nil)
            
            
        }
        
        
        lineLayer = CAShapeLayer()
        lineLayer.path = b.cgPath
        lineLayer.lineWidth = 1
        lineLayer.lineJoin = .round
        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.fillColor = nil
        lineLayer.strokeEnd = isShowAnimation ? 0 : 1
        
        layer.insertSublayer(lineLayer, at: 0)
        
        
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private var lastDot: CAShapeLayer?
    
    private func dotAnimation(_ dot: CAShapeLayer) {
        
        if let path = dot.path {
            marker.direction = path.boundingBox.midY > frame.midY ? .up : .down
            let x = path.boundingBox.midX - marker.frame.width / 2
            var y: CGFloat = 0
            switch marker.direction {
            case .down:
                y = path.boundingBox.midY - marker.raduis
            case .up:
                y = path.boundingBox.midY - marker.frame.height + marker.raduis
            }
            marker.frame.origin = CGPoint(x: x, y: y)
            marker.isHidden = false
        }
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            if let path = dot.path {
                dot.transform.m11 = 1.6
                dot.transform.m22 = 1.6
                dot.transform.m41 = (-path.boundingBox.minX - path.boundingBox.width / 2) * dot.transform.m11 + dot.path!.boundingBox.minX + path.boundingBox.width / 2
                dot.transform.m42 = (-path.boundingBox.minY - path.boundingBox.height / 2) * dot.transform.m22 + path.boundingBox.minY + path.boundingBox.height / 2
            }
            
            
        }, completion: nil)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let point = touches.first?.location(in: self) {
            let dot = dots.first { (d) -> Bool in
                if let path = d.path {
                    let m: CGFloat = 30
                    let x = path.boundingBox.minX - m
                    let y = path.boundingBox.minY - m
                    let w = path.boundingBox.maxX + m
                    let h = path.boundingBox.maxY + m
                    if x < point.x && y < point.y && point.x < w && point.y < h {
                        return true
                    } else {
                        return false
                    }
                } else { return false }
                
            }
            if let selectedDot = dot {
                if let ld = lastDot, !ld.isEqual(selectedDot) {
                    marker.isHidden = true
                    ld.transform = CATransform3DIdentity
                }
                lastDot = selectedDot
                dotAnimation(selectedDot)
            } else {
                marker.isHidden = true
                lastDot?.transform = CATransform3DIdentity
            }
        }
        
    }
    
}

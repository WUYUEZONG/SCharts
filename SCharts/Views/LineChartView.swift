//
//  LineChartView.swift
//  BX
//
//  Created by Ginokeo on 2021/3/19.
//

import UIKit

protocol LineChartViewDelegate {
    //func bottomTitleHeihgt() -> CGFloat
}

class LineChartView: UIView {
    
    var delegate: LineChartViewDelegate?
    
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
        backgroundColor = .lightGray
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
            NSAttributedString.Key.foregroundColor: UIColor.blue]
        for i in 0...level {
            let titleNum = perNum * Double(level - i)
            let title = NSString(format: "%.0f", titleNum)
            
            let tCalRect = title.boundingRect(with: CGSize(width: 36, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: strAtt, context: nil)
            
            let x: CGFloat = leftMargin - tCalRect.width - 4
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
    
    var datas: [Double] = [] {
        didSet {
            setMaxDataValue()
        }
    }
    
    var numericalLevel = 4
    
    var itemSpacing: CGFloat = 60
    
    var bottomHeight: CGFloat = 30
    
    var circleRaduis: CGFloat = 4
    
    var titles: [String] = []
    
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
        
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let subs = layer.sublayers {
            for s in subs {
                s.removeFromSuperlayer()
            }
        }
        
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
                NSAttributedString.Key.foregroundColor: UIColor.blue]
            let title = NSString(string: "标题")
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
            cs.fillColor = UIColor.systemBlue.cgColor
            cs.shadowPath = c.cgPath
            cs.shadowColor = UIColor.black.cgColor
            cs.shadowRadius = 3
            cs.shadowOpacity = 0.2
            layer.addSublayer(cs)
            dots.append(cs)
            
            
            let titleY = rect.height - bottomHeight + topMargin
            let titleX = x - tCalRect.width / 2
            let titleRect = CGRect(x: titleX, y: titleY, width: tCalRect.width, height: tCalRect.height)
            title.draw(with: titleRect, options: .usesLineFragmentOrigin, attributes: strAtt, context: nil)
            
            
        }
        
        
        let bL = CAShapeLayer()
        bL.path = b.cgPath
        bL.lineWidth = 1
        bL.lineJoin = .round
        bL.strokeColor = UIColor.blue.cgColor
        bL.fillColor = nil
        layer.insertSublayer(bL, at: 0)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //let dataW = CGFloat(datas.count) * itemSpacing + 40
//        dataView.frame = CGRect(x: 0, y: 0, width: dataW, height: frame.height)
        //contentSize = CGSize(width: dataW, height: frame.height)
//        translatesAutoresizingMaskIntoConstraints = false
//        let wConstraint = self.constraints.filter { (item) -> Bool in
//            return item.firstAttribute == .width
//        }
//        NSLayoutConstraint.deactivate(wConstraint)
//        let w = CGFloat(datas.count - 1) * itemSpacing + 20
//        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: w)])
    }
    
}

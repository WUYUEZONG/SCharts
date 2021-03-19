//
//  HorizonBarChartView.swift
//  BX
//
//  Created by Ginokeo on 2021/3/18.
//

import UIKit

protocol HorizonBarChartViewDelegate {
    func widthForLeftYAxle() -> CGFloat
    func titleForLeftYAxle(at index: Int) -> String?
    func colorForBar(at index: Int) -> UIColor
}

class HorizonBarChartView: UIView {
    
    var delegate: HorizonBarChartViewDelegate?
    
    var datas: [Double] = [] {
        didSet {
            setMaxDataValue()
        }
    }
    
    private func setMaxDataValue() {
        
        if datas.isEmpty { return }
        let max = datas.max { (a, b) -> Bool in
            return a < b
        }
        maxDataValue = max ?? 0
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    private var maxDataValue: Double = 0
    
    var lineWidth: CGFloat = 18
    
    var lineSpacing: CGFloat = 8
    
    var isShowLeftYStartLine = true
    private let yExtraHeight: CGFloat = 30
    
    var isShowBottomXAlex = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        if let subs = layer.sublayers {
            for s in subs {
                s.removeFromSuperlayer()
            }
        }
        
        let textWidth: CGFloat = 32
        let textSpacing: CGFloat = 8
        
        let yAlexWidth = delegate?.widthForLeftYAxle() ?? 0
        
        let fullWidth = rect.width - textWidth - textSpacing - yAlexWidth
        
        // x line
        if isShowBottomXAlex {
            
            let perStrAtt = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 9),
                NSAttributedString.Key.foregroundColor: UIColor.black]
            
            let perWidth = fullWidth / 5
            for i in 1...5 {
                let textX = yAlexWidth + perWidth * CGFloat(i)
                
                let per = maxDataValue / 5 * Double(i)
                let perStr = NSString(format: "%.1f", per)
                let calRect = perStr.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: perStrAtt, context: nil)
                
                let xPath = UIBezierPath()
                xPath.move(to: CGPoint(x: textX, y: 0))
                xPath.addLine(to: CGPoint(x: textX, y: rect.height - calRect.height - 2))
                let xLayer = CAShapeLayer()
                xLayer.path = xPath.cgPath
                xLayer.lineWidth = 0.25
                //xLayer.lineDashPhase = 4
                xLayer.lineDashPattern = [5, 3]
                xLayer.strokeColor = UIColor.lightGray.cgColor
                layer.addSublayer(xLayer)
                
                
                
                let strRect = CGRect(x: textX - calRect.width / 2, y: bounds.height - calRect.height, width: textWidth, height: calRect.height)
                perStr.draw(with: strRect, options: .usesLineFragmentOrigin, attributes: perStrAtt, context: nil)
            }
        }
        
        for (index, item) in datas.enumerated() {
            let b = UIBezierPath()
            var lineY = lineWidth/2 + (lineSpacing + lineWidth) * CGFloat(index)
            if isShowBottomXAlex {
                lineY += 10
            }
            b.move(to: CGPoint(x: yAlexWidth, y: lineY))
            let lineLength = CGFloat(item / maxDataValue) * fullWidth + yAlexWidth
            b.addLine(to: CGPoint(x: lineLength, y: lineY))
            
            let s = CAShapeLayer()
            s.strokeColor = delegate?.colorForBar(at: index).cgColor ?? UIColor.black.cgColor
            s.path = b.cgPath
            s.lineWidth = lineWidth
            layer.addSublayer(s)
            
            
            let strAtt = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
                NSAttributedString.Key.foregroundColor: UIColor.blue]
            // title
            let title = NSString(string: "\(delegate?.titleForLeftYAxle(at: index) ?? "")")
            let tCalRect = title.boundingRect(with: CGSize(width: yAlexWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: strAtt, context: nil)
            let titleY = lineY - tCalRect.height / 2
            let titleRect = CGRect(x: 0, y: titleY, width: yAlexWidth, height: tCalRect.height)
            title.draw(with: titleRect, options: .usesLineFragmentOrigin, attributes: strAtt, context: nil)
            // vaule
            let str = NSString(format: "%.2f", item)
            
            let calRect = str.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: strAtt, context: nil)
            let textY = lineY - calRect.height / 2
            let strRect = CGRect(x: lineLength + textSpacing, y: textY, width: textWidth, height: calRect.height)
            str.draw(with: strRect, options: .usesLineFragmentOrigin, attributes: strAtt, context: nil)
            
        }
        
        // yStartLine
        
        if isShowLeftYStartLine {
            let yStartLinePath = UIBezierPath()
            yStartLinePath.move(to: CGPoint(x: yAlexWidth - 1, y: 0))
            yStartLinePath.addLine(to: CGPoint(x: yAlexWidth - 1, y: rect.height))
            let yStartLineLayer = CAShapeLayer()
            yStartLineLayer.path = yStartLinePath.cgPath
            yStartLineLayer.lineWidth = 0.5
            yStartLineLayer.strokeColor = UIColor.black.cgColor
            layer.addSublayer(yStartLineLayer)
        }
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        translatesAutoresizingMaskIntoConstraints = false
        let hConstraint = self.constraints.filter { (item) -> Bool in
            return item.firstAttribute == .height
        }
        NSLayoutConstraint.deactivate(hConstraint)
        var h = lineWidth * CGFloat(datas.count) + lineSpacing * CGFloat(datas.count - 1)
        if isShowBottomXAlex {
            h += yExtraHeight
        }
        NSLayoutConstraint.activate([heightAnchor.constraint(equalToConstant: h)])
    }
}

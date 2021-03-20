//
//  ChartMakerView.swift
//  SCharts
//
//  Created by ginokeos hasee mac on 2021/3/20.
//

import UIKit


class ChartMakerView: UIView {
    
    enum Direction {
        case up
        case down
    }
    
    var text: String = "标记"
    
    var raduis: CGFloat = 10
    
    var lineWidth: CGFloat = 2
    
    private let textLabel = UILabel()
    
    var direction: Direction = .down {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
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
        textLabel.font = .systemFont(ofSize: 14, weight: .medium)
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let ls = layer.sublayers {
            for i in ls {
                i.removeFromSuperlayer()
            }
        }
        
        addSubview(textLabel)
        
        
        let arrowW: CGFloat = 4
        
        var circleX: CGFloat = 0
        var circleY: CGFloat = 0
//        var ty: CGFloat = 0
//
//        let atts = [
//            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium),
//            NSAttributedString.Key.foregroundColor: UIColor.black]
//        let t = NSString(string: text)
//        let cRect = t.boundingRect(with: CGSize(width: 36, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: atts, context: nil)
        
        let m = UIBezierPath()
        
        
        switch direction {
        case .down:
            circleX = rect.width / 2
            circleY = raduis
            m.move(to: CGPoint(x: rect.width / 2, y: raduis * 2 + arrowW))
            m.addLine(to: CGPoint(x: rect.width / 2 + arrowW, y: raduis * 2 + arrowW + arrowW))
            m.addLine(to: CGPoint(x: rect.width, y: raduis * 2 + arrowW + arrowW))
            m.addLine(to: CGPoint(x: rect.width, y: rect.height))
            m.addLine(to: CGPoint(x: 0, y: rect.height))
            m.addLine(to: CGPoint(x: 0, y: raduis * 2 + arrowW + arrowW))
            m.addLine(to: CGPoint(x: rect.width / 2 - arrowW, y: raduis * 2 + arrowW + arrowW))
            m.close()
            
            //ty = (rect.height - (raduis * 2 + arrowW + arrowW)) / 2 + raduis * 2 + arrowW + arrowW - cRect.height / 2
            break
        case .up:
            circleX = rect.width / 2
            circleY = rect.height - raduis
            m.move(to: CGPoint(x: rect.width / 2, y: rect.height - raduis * 2 - arrowW))
            m.addLine(to: CGPoint(x: rect.width / 2 + arrowW, y: rect.height - raduis * 2 - arrowW - arrowW))
            m.addLine(to: CGPoint(x: rect.width, y: rect.height - raduis * 2 - arrowW - arrowW))
            m.addLine(to: CGPoint(x: rect.width, y: 0))
            m.addLine(to: CGPoint(x: 0, y: 0))
            m.addLine(to: CGPoint(x: 0, y: rect.height - raduis * 2 - arrowW - arrowW))
            m.addLine(to: CGPoint(x: rect.width / 2 - arrowW, y: rect.height - raduis * 2 - arrowW - arrowW))
            m.close()
            //ty = (rect.height - (raduis * 2 + arrowW + arrowW)) / 2 - cRect.height / 2
            break
        }
        
        let b = UIBezierPath(arcCenter: CGPoint(x: circleX, y: circleY), radius: raduis, startAngle: CGFloat(Double.pi / 4), endAngle: CGFloat(Double.pi * 2 + Double.pi / 4), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = b.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeEnd = 1
        
        layer.addSublayer(shapeLayer)
        
        
        
        let ms = CAShapeLayer()
        ms.path = m.cgPath
        ms.fillColor = UIColor.white.cgColor
        ms.strokeColor = UIColor.systemBlue.cgColor
        ms.lineWidth = lineWidth
        
        
        
        
        
//        let tRect = CGRect(x: rect.width/2 - cRect.width/2, y: ty, width: cRect.width, height: cRect.height)
//        t.draw(with: tRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: atts, context: nil)
        
        layer.insertSublayer(ms, at: 0)

    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        
        var y: CGFloat = 0
        switch direction {
        case .up:
            y = 0
        case .down:
            y = raduis*2 + 8
        }
        textLabel.text = text
        textLabel.frame = CGRect(x: 0, y: y, width: frame.width, height: frame.height - raduis*2 - 8)
    }
    
}

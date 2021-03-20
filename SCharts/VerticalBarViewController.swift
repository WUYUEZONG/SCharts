//
//  VerticalBarViewController.swift
//  SCharts
//
//  Created by ginokeos hasee mac on 2021/3/20.
//

import UIKit


class VerticalBarViewController: UIViewController {
    
    @IBOutlet weak var chartView: VerticalBarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.dataView.chartDelegate = self
        chartView.dataView.datas = [73, 3, 1, 30, 22, 34, 10, 60, 28]
        chartView.dataView.barColor = .systemTeal
        chartView.dataView.itemSpacing = 60
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chartView.showAnimation()
    }
    
}


extension VerticalBarViewController: VerticalBarChartViewDelegate {
    
    func titleForValue(at index: Int) -> String {
        "标题"
    }
    
    func colorForBar(at index: Int) -> UIColor {
        .systemBlue
    }
    
    func didSelectBar(at index: Int, with value: Double) {
        print("at: \(index), with: \(value)")
    }
    
    
}

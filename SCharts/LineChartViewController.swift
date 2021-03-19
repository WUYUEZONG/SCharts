//
//  LineChartViewController.swift
//  SCharts
//
//  Created by ginokeos hasee mac on 2021/3/19.
//

import UIKit

class LineChartViewController: UIViewController {
    
    @IBOutlet weak var chart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.dataView.delegate = self
        chart.dataView.datas = [73, 3, 1, 30, 22, 34, 10, 60, 28]
        chart.dataView.circleRaduis = 4
        chart.dataView.lineColor = .systemTeal
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chart.showAnimation()
    }
    
}

extension LineChartViewController: LineChartViewDelegate {
    func titleForValue(at index: Int) -> String {
        return "标题"
    }
    func colorForDot(at index: Int) -> UIColor {
        .systemTeal
    }
}

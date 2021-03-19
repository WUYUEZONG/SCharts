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
        
        chart.dataView.datas = [73, 3, 1, 30, 22, 34, 10, 60, 28]
        
    }
}

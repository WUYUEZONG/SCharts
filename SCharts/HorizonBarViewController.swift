//
//  HorizonBarViewController.swift
//  SCharts
//
//  Created by ginokeos hasee mac on 2021/3/19.
//

import UIKit

class HorizonBarViewController: UIViewController {
    
    @IBOutlet weak var chart: HorizonBarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.delegate = self
        chart.datas = [4, 5, 32, 9, 15, 8]
    }
}

extension HorizonBarViewController: HorizonBarChartViewDelegate {
    func widthForLeftYAxle() -> CGFloat {
        30
    }
    
    func titleForLeftYAxle(at index: Int) -> String? {
        "标题"
    }
    
    func colorForBar(at index: Int) -> UIColor {
        .systemTeal
    }
    
    
}

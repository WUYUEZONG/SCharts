//
//  ViewController.swift
//  SCharts
//
//  Created by ginokeos hasee mac on 2021/3/19.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var chartTitles = ["HorizonBarChartView", "LineChartView"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    let cellId = "UITableViewCellId"

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chartTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        }
        cell?.textLabel?.text = chartTitles[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let h = loadViewController("HorizonBarViewController")
            show(h, sender: nil)
        case 1:
            show(loadViewController("LineChartViewController"), sender: nil)
        default: break
        }
    }
    
    func loadViewController(_ id: String) -> UIViewController {
        return  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: id)
    }
    
    
}


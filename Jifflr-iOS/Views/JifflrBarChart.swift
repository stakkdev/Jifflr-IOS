//
//  JifflrBarChart.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 11/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Charts

class JifflrBarChart: UIView {

    var barChartView: BarChartView!
    var spinner: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.setupUI()
        self.setupConstraints()
    }
    
    func setupUI() {
        self.barChartView = BarChartView()
        self.barChartView.noDataText = "alert.noChartData".localized()
        self.barChartView.noDataTextColor = UIColor.clear
        self.barChartView.noDataFont = UIFont(name: Constants.FontNames.GothamBook, size: 16.0)!
        self.barChartView.drawBarShadowEnabled = false
        self.barChartView.setScaleEnabled(false)
        
        self.barChartView.gridBackgroundColor = UIColor.clear
        self.barChartView.backgroundColor = UIColor.clear
        self.barChartView.legend.enabled = false
        self.barChartView.chartDescription?.enabled = false
        self.barChartView.setScaleEnabled(false)
        self.barChartView.isUserInteractionEnabled = false
        
        self.barChartView.xAxis.labelPosition = .bottom
        self.barChartView.xAxis.axisLineColor = UIColor.white
        self.barChartView.xAxis.drawLabelsEnabled = true
        self.barChartView.xAxis.drawAxisLineEnabled = true
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.xAxis.axisLineWidth = 2.0
        self.barChartView.xAxis.granularity = 1.0
        self.barChartView.xAxis.granularityEnabled = true
        self.barChartView.xAxis.decimals = 0
        self.barChartView.xAxis.labelTextColor = UIColor.white
        self.barChartView.xAxis.labelFont = UIFont(name: Constants.FontNames.GothamBold, size: 20.0)!
        
        self.barChartView.leftAxis.axisLineColor = UIColor.white
        self.barChartView.leftAxis.drawLabelsEnabled = false
        self.barChartView.leftAxis.drawAxisLineEnabled = true
        self.barChartView.leftAxis.drawGridLinesEnabled = false
        self.barChartView.leftAxis.axisLineWidth = 2.0
        
        self.barChartView.rightAxis.drawLabelsEnabled = false
        self.barChartView.rightAxis.drawAxisLineEnabled = false
        self.barChartView.rightAxis.drawGridLinesEnabled = false
        self.barChartView.rightAxis.axisLineColor = UIColor.clear
        
        self.barChartView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.barChartView)
        
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.spinner.hidesWhenStopped = true
        self.spinner.isHidden = true
        self.spinner.translatesAutoresizingMaskIntoConstraints = false
        self.barChartView.addSubview(self.spinner)
    }
    
    func setupConstraints() {
        let chartLeading = NSLayoutConstraint(item: self.barChartView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10)
        let chartTop = NSLayoutConstraint(item: self.barChartView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 12)
        let chartBottom = NSLayoutConstraint(item: self.barChartView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -18)
        let chartTrailing = NSLayoutConstraint(item: self.barChartView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10)
        self.addConstraints([chartLeading, chartTop, chartBottom, chartTrailing])
        
        let x = NSLayoutConstraint(item: self.spinner, attribute: .centerX, relatedBy: .equal, toItem: self.barChartView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let y = NSLayoutConstraint(item: self.spinner, attribute: .centerY, relatedBy: .equal, toItem: self.barChartView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.addConstraints([x, y])
    }
    
    func setupData(points: [BarChartPoint]) {
        var months:[String] = []
        var data:[Double] = []
        
        for point in points {
            months.append(point.x)
            data.append(point.y)
        }
        
        self.barChartView.setBarChartData(xValues: months, yValues: data, label: "Data")
        self.barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
    }
    
    func startSpinner() {
        self.spinner.startAnimating()
    }
    
    func stopSpinner() {
        self.spinner.stopAnimating()
    }
    
    func showNoDataLabel() {
        self.stopSpinner()
        self.barChartView.noDataText = "alert.noChartData".localized()
        self.barChartView.noDataTextColor = UIColor.white
    }
    
    func hideNoDataLabel() {
        self.barChartView.noDataText = "alert.noChartData".localized()
        self.barChartView.noDataTextColor = UIColor.clear
    }
}

extension BarChartView {
    
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: label)
        chartDataSet.colors = [UIColor.mainLightBlue]
        self.fitBars = true
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        chartData.barWidth = 0.15
        self.xAxis.labelCount = xValues.count
        
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        self.data = chartData
    }
}

//
//  JifflrTeamChart.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 15/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Charts
import Parse

class JifflrTeamChart: UIView {

    var lineChartView: LineChartView!
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
        self.backgroundColor = UIColor.clear

        self.lineChartView = LineChartView()
        self.lineChartView.noDataText = "alert.noChartData".localized()
        self.lineChartView.noDataTextColor = UIColor.clear
        self.lineChartView.noDataFont = UIFont(name: Constants.FontNames.GothamBook, size: 16.0)

        self.lineChartView.gridBackgroundColor = UIColor.clear
        self.lineChartView.backgroundColor = UIColor.clear
        self.lineChartView.legend.enabled = false
        self.lineChartView.chartDescription?.enabled = false
        self.lineChartView.setScaleEnabled(false)
        self.lineChartView.isUserInteractionEnabled = false

        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.xAxis.axisLineColor = UIColor.white
        self.lineChartView.xAxis.drawLabelsEnabled = false
        self.lineChartView.xAxis.drawAxisLineEnabled = true
        self.lineChartView.xAxis.drawGridLinesEnabled = false
        self.lineChartView.xAxis.axisLineWidth = 2.0

        self.lineChartView.leftAxis.drawLabelsEnabled = false
        self.lineChartView.leftAxis.drawAxisLineEnabled = true
        self.lineChartView.leftAxis.drawGridLinesEnabled = false
        self.lineChartView.leftAxis.axisLineWidth = 2.0
        self.lineChartView.leftAxis.axisLineColor = UIColor.white
        self.lineChartView.leftAxis.drawZeroLineEnabled = true
        self.lineChartView.leftAxis.zeroLineColor = UIColor.white
        self.lineChartView.leftAxis.zeroLineWidth = 2.0

        self.lineChartView.rightAxis.drawLabelsEnabled = false
        self.lineChartView.rightAxis.drawAxisLineEnabled = false
        self.lineChartView.rightAxis.drawGridLinesEnabled = false
        self.lineChartView.rightAxis.axisLineColor = UIColor.clear

        self.lineChartView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.lineChartView)
        
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.spinner.hidesWhenStopped = true
        self.spinner.isHidden = true
        self.spinner.translatesAutoresizingMaskIntoConstraints = false
        self.lineChartView.addSubview(self.spinner)
    }

    func setupConstraints() {
        let chartLeading = NSLayoutConstraint(item: self.lineChartView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 18)
        let chartTop = NSLayoutConstraint(item: self.lineChartView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 18)
        let chartBottom = NSLayoutConstraint(item: self.lineChartView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -18)
        let chartTrailing = NSLayoutConstraint(item: self.lineChartView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -18)
        self.addConstraints([chartLeading, chartTop, chartBottom, chartTrailing])
        
        let x = NSLayoutConstraint(item: self.spinner, attribute: .centerX, relatedBy: .equal, toItem: self.lineChartView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let y = NSLayoutConstraint(item: self.spinner, attribute: .centerY, relatedBy: .equal, toItem: self.lineChartView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.addConstraints([x, y])
    }

    func setData(data: [Graph], color: UIColor, fill: Bool, targetData: [Graph]?, targetColor: UIColor?) {
        let allData = data + (targetData ?? [])
        
        if allData.contains(where: { $0.y < 0 }) {
            self.lineChartView.xAxis.axisLineColor = UIColor.clear
            self.lineChartView.leftAxis.drawZeroLineEnabled = true
        } else {
            self.lineChartView.xAxis.axisLineColor = UIColor.white
            self.lineChartView.leftAxis.drawZeroLineEnabled = false
        }

        var maxX = 0.0
        var minX = Double(CGFloat.greatestFiniteMagnitude)
        var maxY = 0.0
        var minY = Double(CGFloat.greatestFiniteMagnitude)

        for point in allData {
            if point.y < -120.0 { point.y = -120.0 }
            if point.y > 620.0 { point.y = 620.0 }
            
            if point.x > maxX { maxX = point.x }
            if point.y > maxY { maxY = point.y }
            if point.x < minX { minX = point.x }
            if point.y < minY { minY = point.y }
        }
        
        let topPadding = (maxY - minY) / Double(allData.count)

        self.lineChartView.xAxis.axisMaximum = maxX
        self.lineChartView.leftAxis.axisMaximum = maxY + topPadding
        self.lineChartView.xAxis.axisMinimum = minX
        self.lineChartView.leftAxis.axisMinimum = minY

        let lineDataSet = self.lineDataSet(data: data, color: color, fill: fill)
        var dataSets:[LineChartDataSet] = []

        if let targetData = targetData, let targetColor = targetColor {
            let targetDataSet = self.targetDataSet(data: targetData, color: targetColor)
            dataSets.append(targetDataSet)
        }
        
        dataSets.append(lineDataSet)

        let finalData = LineChartData(dataSets: dataSets)
        finalData.setDrawValues(false)
        self.lineChartView.data = finalData
        self.stopSpinner()
        self.lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
    }

    func lineDataSet(data: [Graph], color: UIColor, fill: Bool) -> LineChartDataSet {

        var chartDataEntry:[ChartDataEntry] = []
        for point in data {
            chartDataEntry.append(ChartDataEntry(x: point.x, y: point.y))
        }

        let dataSet = LineChartDataSet(values: chartDataEntry, label: "")
        dataSet.axisDependency = .left
        dataSet.setColor(color)
        dataSet.lineWidth = 3.0
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .horizontalBezier
        dataSet.lineCapType = .round

        if fill == true {
            dataSet.fill = Fill(CGColor: UIColor.mainWhiteTransparent20.cgColor)
            dataSet.fillAlpha = 1.0
            dataSet.drawFilledEnabled = true
        } else {
            dataSet.drawFilledEnabled = false
        }

        return dataSet
    }

    func targetDataSet(data: [Graph], color: UIColor) -> LineChartDataSet {
        var chartDataEntry:[ChartDataEntry] = []
        for point in data {
            chartDataEntry.append(ChartDataEntry(x: point.x, y: point.y))
        }

        let dataSet = LineChartDataSet(values: chartDataEntry, label: "")
        dataSet.axisDependency = .left
        dataSet.setColor(color)
        dataSet.lineWidth = 2.5
        dataSet.lineDashPhase = 5.0
        dataSet.lineDashLengths = [5, 2]
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.drawFilledEnabled = false
        dataSet.lineCapType = .round

        return dataSet
    }
    
    func startSpinner() {
        self.spinner.startAnimating()
    }
    
    func stopSpinner() {
        self.spinner.stopAnimating()
    }
    
    func showNoDataLabel() {
        self.stopSpinner()
        self.lineChartView.noDataText = "alert.noChartData".localized()
        self.lineChartView.noDataTextColor = UIColor.white
    }
    
    func hideNoDataLabel() {
        self.lineChartView.noDataText = "alert.noChartData".localized()
        self.lineChartView.noDataTextColor = UIColor.clear
    }
}

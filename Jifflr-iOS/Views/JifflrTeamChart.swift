//
//  JifflrTeamChart.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 15/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Charts

class JifflrTeamChart: UIView {

    var lineChartView: LineChartView!

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
        self.lineChartView.noDataText = "No chart data"
        self.lineChartView.noDataTextColor = UIColor.white
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

        self.lineChartView.leftAxis.axisLineColor = UIColor.white
        self.lineChartView.leftAxis.drawLabelsEnabled = false
        self.lineChartView.leftAxis.drawAxisLineEnabled = true
        self.lineChartView.leftAxis.drawGridLinesEnabled = false
        self.lineChartView.leftAxis.axisLineWidth = 2.0

        self.lineChartView.rightAxis.drawLabelsEnabled = false
        self.lineChartView.rightAxis.drawAxisLineEnabled = false
        self.lineChartView.rightAxis.drawGridLinesEnabled = false
        self.lineChartView.rightAxis.axisLineColor = UIColor.clear

        self.lineChartView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.lineChartView)
    }

    func setupConstraints() {
        let chartLeading = NSLayoutConstraint(item: self.lineChartView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 18)
        let chartTop = NSLayoutConstraint(item: self.lineChartView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 18)
        let chartBottom = NSLayoutConstraint(item: self.lineChartView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -18)
        let chartTrailing = NSLayoutConstraint(item: self.lineChartView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -18)
        self.addConstraints([chartLeading, chartTop, chartBottom, chartTrailing])
    }

    func setData(data: [(x: Double, y: Double)]) {

        var maxX = 0.0
        var minX = Double(CGFloat.greatestFiniteMagnitude)
        var maxY = 0.0
        var minY = Double(CGFloat.greatestFiniteMagnitude)

        var chartDataEntry:[ChartDataEntry] = []
        for point in data {
            chartDataEntry.append(ChartDataEntry(x: point.x, y: point.y))

            if point.x > maxX { maxX = point.x }
            if point.y > maxY { maxY = point.y }
            if point.x < minX { minX = point.x }
            if point.y < minY { minY = point.y }
        }

        self.lineChartView.xAxis.axisMaximum = maxX
        self.lineChartView.leftAxis.axisMaximum = maxY
        self.lineChartView.xAxis.axisMinimum = minX
        self.lineChartView.leftAxis.axisMinimum = minY

        let dataSet = LineChartDataSet(values: chartDataEntry, label: "")
        dataSet.axisDependency = .left
        dataSet.setColor(UIColor.mainOrange)
        dataSet.lineWidth = 3.0
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.fill = Fill(CGColor: UIColor.mainWhiteTransparent20.cgColor)
        dataSet.fillAlpha = 1.0
        dataSet.drawFilledEnabled = true

        let dataSets = [dataSet]
        let finalData = LineChartData(dataSets: dataSets)
        finalData.setDrawValues(false)
        self.lineChartView.data = finalData
        self.lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
    }
}

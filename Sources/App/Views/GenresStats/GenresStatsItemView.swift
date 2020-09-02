import Boomerang
import Charts
import RxCocoa
import RxSwift
import SwiftRichString
import UIKit
/**
 A Boomerang ItemView for Show contents.

 Contents should be entirely driven by `ViewModel`, so that this view can safely deployed in production without being tested.

 */
class GenresStatsItemView: UIView, WithViewModel {
    @IBOutlet var title: UILabel?
    @IBOutlet var chart: PieChartView!

    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        // Always clear disposeBag for proper cell recycle
        disposeBag = DisposeBag()

        guard let viewModel = viewModel as? GenresStatsItemViewModel else { return }
        /// Configure here every property that contributes to change view size
        /// Multiline text bindings should go here

        backgroundColor = .clear
        chart.backgroundColor = .clear
        if let title = title {
            title.applyStyle(.subtitle)
            title.styledText = viewModel.title
        }

        if isPlaceholderForAutosize { return }

        setupCharts(values: viewModel.values)
        // configure here everything not related to automatic sizing
    }

    func setupCharts(values: [ChartValue]) {
        let entries = values.map { (value) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            PieChartDataEntry(value: value.percentage,
                              label: value.name)
        }

        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 4
        chart.transparentCircleColor = .clear
        set.colors = [UIColor.red]
//            + ChartColorTemplates.joyful()
//            + ChartColorTemplates.colorful()
//            + ChartColorTemplates.liberty()
//            + ChartColorTemplates.pastel()
//            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]

        let data = PieChartData(dataSet: set)

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.white)
        chart.data = data
        chart.holeColor = .clear

        chart.holeRadiusPercent = 0.30
        chart.legendRenderer.legend = nil
        chart.chartDescription = nil
        chart.highlightValues(nil)
    }

    override var canBecomeFocused: Bool { true }
}

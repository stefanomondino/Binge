import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

struct ChartValue {
    var percentage: Double
    let name: String
}

class GenresStatsItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    let uniqueIdentifier: UniqueIdentifier
    let title: String
    let values: [ChartValue]
    init(genresStats: [Trakt.UserGenresStats],
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.genresStats) {
        self.layoutIdentifier = layoutIdentifier
        uniqueIdentifier = UUID()
        title = ""
        values = genresStats.reduce([ChartValue(percentage: 0, name: "Other")]) { acc, current in
            var accumulator = acc
            if current.percentage > 9 {
                return [ChartValue(percentage: current.percentage, name: current.name)] + acc
            } else {
                guard var other = accumulator.popLast() else { return acc }
                other.percentage += current.percentage
                return accumulator + [other]
            }
        }
    }
}

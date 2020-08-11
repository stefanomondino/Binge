//
//  ShowDetailViewController.swift
//  App
//

import Boomerang
import PluginLayout
import RxCocoa
import RxSwift
import SnapKit
import UIKit

extension RxCollectionViewDelegateProxy: PluginLayoutDelegate {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: PluginLayout, pluginForSectionAt section: Int) -> PluginType? {
        return (forwardToDelegate() as? PluginLayoutDelegate)?.collectionView(collectionView, layout: collectionViewLayout, pluginForSectionAt: section)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: PluginLayout, effectsForItemAt indexPath: IndexPath, kind: String?) -> [PluginEffect] {
        return (forwardToDelegate() as? PluginLayoutDelegate)?.collectionView(collectionView, layout: collectionViewLayout, effectsForItemAt: indexPath, kind: kind) ?? []
    }
}

class ShowHeaderPlugin: Plugin {
    required init(delegate: FlowLayoutDelegate) {
        self.delegate = delegate
    }

    var sectionHeadersPinToVisibleBounds: Bool = false

    var sectionFootersPinToVisibleBounds: Bool = false

    public typealias Delegate = FlowLayoutDelegate
    public typealias Parameters = FlowSectionParameters

    weak var delegate: Delegate?

    func layoutAttributes(in section: Int, offset: inout CGPoint, layout: PluginLayout) -> [PluginLayoutAttributes] {
        guard let collectionView = layout.collectionView else { return [] }
        let params = sectionParameters(inSection: section, layout: layout)
        offset.x = params.insets.left
        offset.y += 100
        let poster = PluginLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        let size = delegate?.collectionView?(collectionView, layout: layout, sizeForItemAt: poster.indexPath) ?? .zero
        poster.frame = CGRect(x: offset.x + 20, y: offset.y, width: size.width / 3, height: size.height / 3)
        poster.zIndex = 1
        offset.y += poster.frame.height + 20
        let parallax = PluginLayoutAttributes(forSupplementaryViewOfKind: "parallax", with: IndexPath(item: 0, section: 0))
        parallax.frame = CGRect(x: 0, y: 0, width: params.contentBounds.width, height: 200)
        parallax.zIndex = 0
        return [poster, parallax]
    }
}

class ShowDetailDelegate: CollectionViewDelegate, PluginLayoutDelegate {
    func collectionView(_: UICollectionView, layout _: PluginLayout, pluginForSectionAt section: Int) -> PluginType? {
        switch section {
        case 0: return ShowHeaderPlugin(delegate: self)
        default: return FlowLayoutPlugin(delegate: self)
        }
    }

    func collectionView(_: UICollectionView, layout _: PluginLayout, effectsForItemAt _: IndexPath, kind: String?) -> [PluginEffect] {
        guard kind == "parallax" else { return [] }
        return [StickyEffect(position: .start)]
    }
}

class ShowDetailViewController: UIViewController {
    class SizeCalculator: AutomaticCollectionViewSizeCalculator {
        override func sizeForItem(at indexPath: IndexPath, in collectionView: UICollectionView, direction: Direction? = nil, type: String? = nil) -> CGSize {
            guard let viewModel = viewModel(at: indexPath, for: type) else { return .zero }
            let width = calculateFixedDimension(for: .vertical, collectionView: collectionView, at: indexPath, itemsPerLine: 1)
            switch viewModel {
            case is CarouselItemViewModel: return CGSize(width: width, height: 200)
            default: return super.sizeForItem(at: indexPath, in: collectionView, direction: direction, type: type)
            }
        }
    }

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var backgroundImage: UIImageView!

    var viewModel: ShowDetailViewModel

    var collectionViewDataSource: CollectionViewDataSource? {
        didSet {
            collectionView.dataSource = collectionViewDataSource
            collectionView.reloadData()
        }
    }

    var collectionViewDelegate: CollectionViewDelegate? {
        didSet {
            collectionView.delegate = collectionViewDelegate
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    var disposeBag = DisposeBag()
    private let collectionViewCellFactory: CollectionViewCellFactory

    init(nibName: String?,
         bundle: Bundle? = nil,
         viewModel: ShowDetailViewModel,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibName, bundle: bundle)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)

        collectionView.alwaysBounceVertical = true
        view.applyContainerStyle(Styles.Generic.container)

//        let spacing: CGFloat = 10
        let sizeCalculator = SizeCalculator(viewModel: viewModel,
                                            factory: collectionViewCellFactory, itemsPerLine: 1)

        let collectionViewDelegate = ShowDetailDelegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }

        let layout = PluginLayout()
        collectionView.collectionViewLayout = layout

        collectionView.backgroundColor = .clear

        collectionView.rx
            .animated(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)

        self.collectionViewDelegate = collectionViewDelegate

        viewModel
            .routes
            .bind(to: rx.routes())
            .disposed(by: disposeBag)

        viewModel.reload()

        if let container = self.container {
            collectionView.rx
                .topWindow(of: 100)
                .bind(to: container.rx.updateCurrentNavbarAlpha())
                .disposed(by: disposeBag)
        }
    }
}

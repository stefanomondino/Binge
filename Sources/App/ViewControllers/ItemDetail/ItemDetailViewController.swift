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
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: PluginLayout,
                               pluginForSectionAt section: Int) -> PluginType? {
        return (forwardToDelegate() as? PluginLayoutDelegate)?.collectionView(collectionView, layout: collectionViewLayout, pluginForSectionAt: section)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: PluginLayout,
                               effectsForItemAt indexPath: IndexPath, kind: String?) -> [PluginEffect] {
        return (forwardToDelegate() as? PluginLayoutDelegate)?.collectionView(collectionView, layout: collectionViewLayout, effectsForItemAt: indexPath, kind: kind) ?? []
    }
}

extension ViewIdentifier.CarouselType {
    func height(for _: CGFloat) -> CGFloat {
        switch self {
        case .cast: return 180
        case .relatedShows: return 200
        case .castInMovie: return 250
        case .castInShow: return 270
        case .seasons: return 200
        }
    }

    var desiredItemWidth: CGFloat? {
        switch self {
        case .castInShow, .castInMovie: return 100
        default: return nil
        }
    }

    var itemRatio: CGFloat {
        switch self {
        case .cast: return 9 / 14
        case .seasons: return Constants.showPosterRatio * 0.8
        case .relatedShows: return Constants.showPosterRatio
        case .castInShow: return Constants.showPosterRatio * 0.8
        case .castInMovie: return Constants.showPosterRatio * 0.8
        }
    }
}

class ItemDetailViewController: UIViewController {
    class Delegate: CollectionViewDelegate, PluginLayoutDelegate {
        func collectionView(_: UICollectionView, layout _: PluginLayout, pluginForSectionAt section: Int) -> PluginType? {
            switch section {
            case 0: return DetailHeaderPlugin(delegate: self)
            default: return FlowLayoutPlugin(delegate: self)
            }
        }

        func collectionView(_: UICollectionView, layout _: PluginLayout, effectsForItemAt _: IndexPath, kind: String?) -> [PluginEffect] {
            guard kind == ViewIdentifier.Supplementary.parallax.identifierString else { return [] }
            return [ZoomEffect(parallax: 0.7)]
        }
    }

    class SizeCalculator: AutomaticCollectionViewSizeCalculator {
        override func lineSpacing(for _: UICollectionView, in _: Int) -> CGFloat {
            return Constants.detailLineSpacing
        }

        override func itemSpacing(for _: UICollectionView, in _: Int) -> CGFloat {
            Constants.detailLineSpacing
        }

        override func insets(for _: UICollectionView, in sectionIndex: Int) -> UIEdgeInsets {
            let section = viewModel.sections[sectionIndex]
            if section.items.first is CarouselItemViewModel {
                return .zero
            }
            return UIEdgeInsets(top: 0, left: Constants.sidePadding, bottom: Constants.detailLineSpacing, right: Constants.sidePadding)
        }

        override func sizeForItem(at indexPath: IndexPath, in collectionView: UICollectionView, direction: Direction? = nil, type: String? = nil) -> CGSize {
            guard let viewModel = viewModel(at: indexPath, for: type) else { return .zero }

            switch viewModel {
            case let item as GenericItemViewModel:
                let direction = direction ?? Direction.from(layout: collectionView.collectionViewLayout)
                let fixedDimension = calculateFixedDimension(for: direction, collectionView: collectionView, at: indexPath, itemsPerLine: item.showIdentifier.gridCount)
                let lock = LockingSize(direction: direction, value: fixedDimension)
                return autosizeForItem(at: indexPath, type: type, lockedTo: lock)
            case let carousel as CarouselItemViewModel:
                let width = calculateFixedDimension(for: .vertical, collectionView: collectionView, at: indexPath, itemsPerLine: 1)
                return CGSize(width: width, height: carousel.carouselType.height(for: width))

            default: return super.sizeForItem(at: indexPath, in: collectionView, direction: direction, type: type)
            }
        }
    }

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var backgroundImage: UIImageView!

    var viewModel: ItemDetailViewModel

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
         viewModel: ItemDetailViewModel,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibName, bundle: bundle)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if os(iOS)
        override var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent
        }
    #endif

    override func viewDidLoad() {
        collectionView.backgroundColor = .clear
        super.viewDidLoad()
        let layout = PluginLayout()
        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)

        collectionView.alwaysBounceVertical = true
        view.applyContainerStyle(.container)

        let sizeCalculator = SizeCalculator(viewModel: viewModel,
                                            factory: collectionViewCellFactory, itemsPerLine: 1)

        let collectionViewDelegate = Delegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }

        collectionView.collectionViewLayout = layout

        collectionView.backgroundColor = .clear

        collectionView.rx
            .reloaded(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)

        self.collectionViewDelegate = collectionViewDelegate

        viewModel
            .routes
            .bind(to: rx.routes())
            .disposed(by: disposeBag)

        viewModel.reload()

        viewModel.navbarTitleViewModel
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] in
                if let viewModel = $0 {
                    self?.setNavigationView(self?.collectionViewCellFactory.component(from: viewModel))
                } else {
                    self?.title = viewModel.title
                }
            })
            .disposed(by: disposeBag)

        if let container = self.container {
            collectionView.rx
                .topWindow(of: 200)
                .bind(to: container.rx.updateCurrentNavbarAlpha())
                .disposed(by: disposeBag)
        }
        setupLoader()
    }

    private func setupLoader() {
        let loader = RingLoaderView()
        loader.tintColor = .mainDescription
        view.addSubview(loader)
        loader.snp.makeConstraints { make in make.center.equalToSuperview() }
        viewModel.isLoading.asDriver(onErrorJustReturn: false)
            .drive(loader.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

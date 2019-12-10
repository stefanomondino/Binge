func {{ name|firstLowercase }}(viewModel: {{ name|firstUppercase }}ViewModel) -> UIViewController {
        return {{ name|firstUppercase }}ViewController(nibName: name(from: viewModel.layoutIdentifier),
                                   	viewModel: viewModel,
                                   	collectionViewCellFactory: container.collectionViewCellFactory)
    }


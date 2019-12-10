func {{ name|firstLowercase }}() -> {{name|firstUppercase}}ViewModel {
        ShowListViewModel(itemViewModelFactory: container.itemViewModelFactory,
                          useCase: container.model.useCases.{{ name|firstLowercase}},
                          styleFactory: container.styleFactory)
    }


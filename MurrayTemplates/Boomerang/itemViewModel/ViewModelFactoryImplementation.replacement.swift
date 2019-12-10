func {{ name|firstLowercase }}(_ {{name|firstLowercase}}: {{name|firstUppercase}}) -> ViewModel {
        {{name|firstUppercase}}ViewModel({{name|firstLowercase}}: {{name|firstUppercase}},
                        layoutIdentifier: ViewIdentifier.{{name|firstLowercase}},
                        styleFactory: container.styleFactory)
    }

    
# ViewModel

**ViewModel** is a crossplatform framework that encapsulates most of the *business logic*

ViewModel should not have any direct references to the `App` or any of its Pods (unless they are shared), but has visibility of `Model.framework`, specifically through its UseCases that may return Entities through Observables.

ViewModel implements most of required [Boomerang](https://github.com/synesthesia-it/Boomerang) logic, defining and implementing: 

- `ViewModelType` objects (`ListViewModelType`, `ItemViewModelType`, `InteractionViewModelType`, etc...)
- `SceneIdentifier` and `ViewIdentifier` enumerations, demanding the real creation of `View`s and `Scene`s to the App through [Dependency Inversion](injection.md)
- `Route`s that will be returned to Scenes and passed to the `Router`, but without declaring how a route should be handled (that's App's responsability).
- Non-concrete concepts of Strings, Images, Style, expressed through enumerations without any App-related implementation detail
- Any type of custom value that is obtained through business logic and needs to be passed down to the view.

The main role of a `ViewModelType` object should be **the retrieval and transformation of Model-related raw data into ready-to-be-displayed data that will feed a specific view**. For more informations and examples about this, please check [Boomerang](https://github.com/synesthesia-it/Boomerang) documentation. 

## Non-concrete concepts and custom values

One of the main feature of a ViewModel object is the transformation of raw data into data for the view. This data is usually made of localized strings and/or local images. Example: the same `UIButton` should display "Login" if user is not logged in, or "Logout" is already logged in. Since the `UIButton` should not know the concept of "logged in" (it's handled by the Model layer), the string value of that button must be exposed through `Observable` by the viewModel to the button's containing viewController and reference a local translation (`btn_login` and `btn_logout`) inside the app's bundle. There can also be cases of multi-target applications where the same translation is obtained through remote vocabulary for a target and through `Localizable.string` on another one, or simply driven by a configuration file. From the `ViewModel` point of view, the logic doesn't change. For this reason, we're exposing `Identifiers.Strings` with enumeration

```
extension Identifiers {
    public enum Strings: String, CaseIterable, DependencyKey {
        case login
        case logout
    }
}
```
and handle how "login" and "logout" should be translated inside the app's configuration.

Same thing goes for local Images and, if needed, Styles object. The general approach should be a public, `Identifiers` namespaced enumeration in the `ViewModel` framework target, and the concrete implementation under the `App` target (as done [here](../Sources/App/Configuration/Strings.swift))

# POC `Bloc` vs `Provider`

## Why I think we should Use `Bloc` Instead of `Provider` for _Movies App_ mobile app.

I've been diving deep into state management approaches we're taking into account, and I still think we should work with Bloc (with Cubits, actually) over Provider.

I know and understand that some of the Bloc disadvantages are:
- Additional overhead compared to using Provider. It's real that Bloc uses some more dependecies than Provider, which is actually reflected in package size (provider: ~70KB, flutter_bloc: ~300KB). However, in modern hardware this difference (still in KB) could be considered negligible, taking into account the advantages using Bloc can bring us once the software start growing and we need a clean and concise way to manage properties in out business logic, for example.
We could see a bit of these on the example provided in the `lib` folder:
  - Using __Provider__ it's a common practise to keep all our variables and dependecies in the same place where our logic is. We can view it in `lib/provider_version/movie_listing_provider.dart` where we have a bunch of variables in the top of the class, and below, the methods to manage logic.
On the __Bloc__ side (`lib/cubit_version/movie_listing_cubit.dart`) we have a cleaner file, as we abstract all of the variable we'll be using to manage our state in the `movie_listing_state.dart`. Creating this additional (a completely acceptable overhead) will save us time fixing bugs or extending our business logic in a future, which I personally consider quite valuable. 
  - In `movie_listing_provider.dart` we also see how we add values line by line and then we call `nofifyListeners()` to properly update widgets listening for one or more changes. While in `movie_listing_cubit.dart` we can assign all new values to state in a single line using `emit()` function, which on the listeners side, we can decide whether we want to rebuild a specific widgets only of some specific state values changes, helped by the `buidlWhen` property of `BlocBuilder` or `BlocConsumer`. Having these properties ready to implement can save us time and help us have granual control over rebuilds, which we should take a lot of attention to.
  - Another thing to note is the way we display errors in UI (or showing a banner, navigating back to a screen, call an action, etc). With Bloc we have a `BlocConsumer` widget that simplifies us the implementetation of `BlocListener` and  `BlocBuilder` and let us setup a listener to trigger actions, and the builder to build a widget. If we try to do this with Provider, we get a code a bit uglier and less elegant, while also having some additional lines of code.

- Bit more complex to understand. That's why we could use Cubits instead, which simplifies the understanding and implementation of our business logic and reactive UI, with multiple built-in widgets that will save us time and work thinking how to implement our logic in a clean way.

### _Movies App_ is complex and with multiple features.

On the Flutter community it's recommended the use of __Provider__ in small and medium complexity apps. While another approaches are suggested for medium to large applications, like ours.
That's why I still think __Bloc__ is a suitable solution for what we are about to create. Bloc is built to handle this kind of complexity. Giving us tools like build-in widgets and separation of concerns to have a clear structure for managing all these features without turning our code into a possible spaghetti case.

### Run the example
To turn the examples for `Provider` and `Bloc`, just comment/uncomment lines 2 and 3 in `lib/main.dart`
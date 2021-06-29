import ComposableArchitecture
import Persistence
import SwiftUI

struct AppState: PersistedObject, Equatable {
    private enum PropertyKey: String, CodingKey {
        case user
        case screen
    }
    
    @PersistedProperty(codingKeyName: PropertyKey.user)
    var user: User = User(id: UUID(), name: "")
    
    var unsavedUser: User = User(id: UUID(), name: "")

    @PersistedProperty(codingKeyName: PropertyKey.screen)
    var currentScreen: Screen = .home
}

enum AppAction: Equatable {
    case savedUser(UserManagementAction)
    case unsavedUser(UserManagementAction)
    case changeScreen
    case save
    case saveComplete
    case saveFailed(NSError)
    case loadState
    case loadStateComplete(Result<AppState, NSError>)
}

struct AppEnvironment {
    var persistence: Persistence<AppState>
}

extension PersistenceStorage {
    static func userDefaults(_ userDefaults: UserDefaults = .standard) -> Self {
        .init(
            save: { data, identifier in
                userDefaults.setValue(data, forKey: identifier)
            },
            load: { identifier in
                guard let data = userDefaults.data(forKey: identifier) else {
                    return nil
                }
                return data
            }
        )
    }
}

extension AppEnvironment {
    static var live: Self {
        .init(
            persistence: .json(
                storage: .userDefaults(),
                identifier: "appState"
            )
        )
    }
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    Reducer { state, action, environment in
        switch action {
        case .changeScreen:
            let screen = state.currentScreen
            switch screen {
            case .home:
                state.currentScreen = .account("Extra State")
            case .account:
                state.currentScreen = .home
            }
            return .none

        case .save:
            let state = state
            return Effect.catching {
                try environment.persistence.save(state)
            }
            .mapError { $0 as NSError }
            .catchToEffect()
            .map {
                switch $0 {
                case .success: return AppAction.saveComplete
                case let .failure(error): return AppAction.saveFailed(error)
                }
            }
            
        case let .saveFailed(error):
            dump("SAVE FAILED")
            dump(error)
            return .none
            
        case .saveComplete:
            dump("SAVE COMPLETE")
            return .none
            
        case .loadState:
            return Effect.catching {
                try environment.persistence.load()
            }
            .mapError { $0 as NSError }
            .catchToEffect()
            .map(AppAction.loadStateComplete)
            
        case let .loadStateComplete(.success(appState)):
            state = appState
            return .none
            
        case let .loadStateComplete(.failure(error)):
            dump("LOAD FAILED")
            dump(error)
            return .none
            
        case .savedUser, .unsavedUser:
            return .none
        }
    },
    userManagementReducer.pullback(
        state: \.user,
        action: /AppAction.savedUser,
        environment: { _ in () }
    ),
    userManagementReducer.pullback(
        state: \.unsavedUser,
        action: /AppAction.unsavedUser,
        environment: { _ in () }
    )
)

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store.scope(state: \.view)) { viewStore in
            VStack(spacing: 15) {
                Text("Persisted User")
                
                UserManagementView(
                    store: store.scope(
                        state: \.user,
                        action: AppAction.savedUser
                    )
                )
                
                Text("Unpersisted User")
                
                UserManagementView(
                    store: store.scope(
                        state: \.unsavedUser,
                        action: AppAction.unsavedUser
                    )
                )

                Text("Persisted Enum State")
                HStack {
                    Text(screenString(currentScreen: viewStore.screen))
                    Spacer()
                    Button(action: { viewStore.send(.changeScreen) }) {
                        Text("Change Screen")
                    }
                }

                Button(action: { viewStore.send(.save) }) {
                    Text("Save Data")
                }
                
                Button(
                    action: {
                        withAnimation {
                            viewStore.send(.loadState)
                        }
                    }
                ) {
                    Text("Load Data")
                }
            }
            .onAppear {
                viewStore.send(.loadState)
            }
        }
    }
    
    func screenString(currentScreen: Screen) -> String {
        switch currentScreen {
        case .home:
            return "Home"
        case let .account(state):
            return "Account: \(state)"
        }
    }
}

extension AppView {
    struct LocalState: Equatable {
        let screen: Screen
    }
}

extension AppState {
    var view: AppView.LocalState {
        .init(screen: currentScreen)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: Store(
                initialState: AppState(),
                reducer: .empty,
                environment: ()
            )
        )
    }
}

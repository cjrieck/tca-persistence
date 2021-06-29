import ComposableArchitecture
import SwiftUI

struct User: Equatable, Codable {
    let id: UUID
    var name: String
    var preferences: UserPreferences = .init()
}

struct UserPreferences: Equatable, Codable {
    var enablePrivacy: Bool = false
    var uselessToggle: Bool = false
}

enum UserManagementAction: Equatable {
    case updateName(String)
    case userPreferences(UserPreferencesAction)
}

let userManagementReducer: Reducer<User, UserManagementAction, Void> = Reducer { state, action, _ in
    switch action {
    case let .updateName(newName):
        state.name = newName
        return .none

    case .userPreferences:
        return .none
    }
}.combined(
    with: userPreferencesReducer
        .pullback(
        state: \.preferences,
        action: /UserManagementAction.userPreferences,
        environment: { $0 }
    )
)

struct UserManagementView: View {
    let store: Store<User, UserManagementAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                TextField(
                    "Enter A Name",
                    text: viewStore.binding(
                        get: \.name,
                        send: UserManagementAction.updateName
                    )
                )

                UserPreferencesView(
                    store: store.scope(
                        state: \.preferences,
                        action: UserManagementAction.userPreferences
                    )
                )
            }
        }
    }
}

enum UserPreferencesAction: Equatable {
    case updatePrivacyToggle(Bool)
    case updateUselessToggle(Bool)
}

let userPreferencesReducer = Reducer<UserPreferences, UserPreferencesAction, Void> { state, action, _ in

    switch action {
    case let .updatePrivacyToggle(newValue):
        state.enablePrivacy = newValue
        return .none

    case let .updateUselessToggle(newValue):
        state.uselessToggle = newValue
        return .none
    }
}

struct UserPreferencesView: View {
    let store: Store<UserPreferences, UserPreferencesAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Toggle(
                    "Enable Privacy",
                    isOn: viewStore.binding(
                        get: \.enablePrivacy,
                        send: UserPreferencesAction.updatePrivacyToggle
                    )
                )
                Toggle(
                    "Something Useless",
                    isOn: viewStore.binding(
                        get: \.uselessToggle,
                        send: UserPreferencesAction.updateUselessToggle
                    )
                )
            }
        }
    }
}

import ComposableArchitecture
import Persistence
import SwiftUI

@main
struct PersistencePOCApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppState(),
                    reducer: appReducer,
                    environment: .live
                )
            )
        }
    }
}

import Foundation

@MainActor
final class SessionViewModel: ObservableObject {
    @Published private(set) var user: AuthUser?
    @Published var errorMessage: String?
    private let auth: AuthProviding

    init(auth: AuthProviding) {
        self.auth = auth
    }

    func load() async {
        user = await auth.currentUser()
    }

    func signIn(with provider: AuthProvider) async {
        do {
            user = try await auth.signIn(with: provider)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() async {
        do {
            try await auth.signOut()
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}



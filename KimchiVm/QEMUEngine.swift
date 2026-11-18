
import Foundation

enum QEMUError: LocalizedError {
    case backendNotInstalled
    case unsupportedConfiguration

    var errorDescription: String? {
        switch self {
        case .backendNotInstalled:
            return "The native QEMU backend has not been installed."
        case .unsupportedConfiguration:
            return "This VM configuration is not supported."
        }
    }
}

final class QEMUEngine {
    static let shared = QEMUEngine()

    private init() {}

    var isBackendAvailable: Bool {
        // Replace with a real native QEMU bridge.
        false
    }

    func start(
        configuration: VMConfiguration
    ) async throws {
        guard isBackendAvailable else {
            throw QEMUError.backendNotInstalled
        }

        throw QEMUError.unsupportedConfiguration
    }

    func stop() async {
        // Native QEMU shutdown will be implemented here.
    }
}

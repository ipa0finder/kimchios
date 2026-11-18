
import Foundation

enum VMArchitecture: String, CaseIterable, Identifiable {
    case x86_64 = "x86_64"
    case x86 = "x86"
    case arm64 = "ARM64"
    case riscv64 = "RISC-V 64"

    var id: String { rawValue }
}

struct VMConfiguration: Identifiable {
    let id: UUID
    var name: String
    var architecture: VMArchitecture
    var memoryMB: Int
    var cpuCores: Int
    var diskSizeGB: Int
    var isRunning: Bool

    init(
        name: String,
        architecture: VMArchitecture = .x86_64,
        memoryMB: Int = 1024,
        cpuCores: Int = 2,
        diskSizeGB: Int = 16
    ) {
        self.id = UUID()
        self.name = name
        self.architecture = architecture
        self.memoryMB = memoryMB
        self.cpuCores = cpuCores
        self.diskSizeGB = diskSizeGB
        self.isRunning = false
    }
}

@MainActor
final class VMManager: ObservableObject {
    @Published var machines: [VMConfiguration] = []

    func create(
        name: String,
        architecture: VMArchitecture
    ) {
        let machine = VMConfiguration(
            name: name,
            architecture: architecture
        )
        machines.append(machine)
    }

    func toggle(_ id: UUID) {
        guard let index = machines.firstIndex(
            where: { $0.id == id }
        ) else { return }

        machines[index].isRunning.toggle()
    }

    func delete(_ id: UUID) {
        machines.removeAll { $0.id == id }
    }
}


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: VMManager
    @State private var showingCreateVM = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.035, green: 0.045, blue: 0.075)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        header

                        HStack(spacing: 12) {
                            statCard(
                                "Virtual Machines",
                                value: "\(manager.machines.count)",
                                icon: "desktopcomputer"
                            )

                            statCard(
                                "Running",
                                value: "\(manager.machines.filter(\.isRunning).count)",
                                icon: "play.circle"
                            )
                        }

                        HStack {
                            Text("My Virtual Machines")
                                .font(.title2.bold())

                            Spacer()

                            Button {
                                showingCreateVM = true
                            } label: {
                                Label("New VM", systemImage: "plus")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }

                        if manager.machines.isEmpty {
                            emptyState
                        } else {
                            ForEach(manager.machines) { machine in
                                machineCard(machine)
                            }
                        }

                        backendNotice
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingCreateVM) {
                CreateVMView()
                    .environmentObject(manager)
            }
        }
        .tint(.red)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "cpu.fill")
                    .foregroundStyle(.red)

                Text("KIMCHIOS")
                    .font(.headline.bold())
                    .tracking(3)

                Spacer()

                Circle()
                    .fill(.orange)
                    .frame(width: 9, height: 9)

                Text("ENGINE OFFLINE")
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
            }

            Text("Your virtual machine hub.")
                .font(.largeTitle.bold())

            Text("Manage and configure your virtual machines.")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 14)
    }

    private func statCard(
        _ title: String,
        value: String,
        icon: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.red)

            Text(value)
                .font(.system(size: 30, weight: .bold))

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "desktopcomputer")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)

            Text("No virtual machines yet")
                .font(.headline)

            Text("Create your first VM to get started.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 45)
        .background(.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func machineCard(
        _ machine: VMConfiguration
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "desktopcomputer")
                    .font(.title2)
                    .foregroundStyle(.red)

                VStack(alignment: .leading) {
                    Text(machine.name)
                        .font(.headline)

                    Text(machine.architecture.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Circle()
                    .fill(machine.isRunning ? .green : .gray)
                    .frame(width: 9, height: 9)
            }

            HStack {
                Label("\(machine.memoryMB) MB", systemImage: "memorychip")
                Spacer()
                Label("\(machine.cpuCores) CPU", systemImage: "cpu")
                Spacer()
                Label("\(machine.diskSizeGB) GB", systemImage: "internaldrive")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            Button {
                manager.toggle(machine.id)
            } label: {
                Label(
                    machine.isRunning ? "Stop VM" : "Start VM",
                    systemImage: machine.isRunning ? "stop.fill" : "play.fill"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(machine.isRunning ? .gray : .red)
        }
        .padding()
        .background(.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var backendNotice: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(.orange)

            Text("QEMU is not integrated yet. VM controls currently manage demonstration states only.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct CreateVMView: View {
    @EnvironmentObject var manager: VMManager
    @Environment(\.dismiss) private var dismiss

    @State private var name = "My First VM"
    @State private var architecture = VMArchitecture.x86_64

    var body: some View {
        NavigationStack {
            Form {
                Section("Machine details") {
                    TextField("VM name", text: $name)

                    Picker("Architecture", selection: $architecture) {
                        ForEach(VMArchitecture.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                }

                Section {
                    Text("Default configuration: 1 GB RAM, 2 CPU cores, 16 GB disk.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Create VM")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let cleanName = name.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )

                        guard !cleanName.isEmpty else { return }

                        manager.create(
                            name: cleanName,
                            architecture: architecture
                        )

                        dismiss()
                    }
                }
            }
        }
    }
}

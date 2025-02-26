// The Swift Programming Language
// https://docs.swift.org/swift-book

import IRCore
import IRDashboard
import IRDashboardInterface

@MainActor
public class IRLibraries {
    public static func registerDependencies() {
        IRDependencyContainer.shared.register(IRDashboardFactory(), for: IRDashboardFactoryProtocol.self)
    }
}

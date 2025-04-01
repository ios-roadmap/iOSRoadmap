// The Swift Programming Language
// https://docs.swift.org/swift-book

import IRCore

import IRJPH
import IRJPHInterface

@MainActor
public class IRDashboardDemoLibrary {
    public static func registerDependency() {
        IRDependencyContainer.shared.register(IRJPHFactory().create() as IRJPHInterface)
    }
}

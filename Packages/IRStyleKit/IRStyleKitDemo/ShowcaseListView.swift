//
//  ShowcaseListView.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 27.04.2025.
//

import SwiftUI

// MARK: – Demo-page contract
public protocol ShowcasePage: View {
    init()
    static var title: String { get }
}

public extension ShowcasePage {
    static var title: String { String(describing: Self.self) }
}

// MARK: – Page descriptor
private struct ShowcaseEntry: Identifiable {
    let build: () -> AnyView
    let title: String
    var id: String { title }
}

// MARK: – Showcase list
public struct ShowcaseListView: View {

    /// Register new pages here.
    private let pages: [ShowcaseEntry] = [
        .init(build: { AnyView(TypographyDemo()) },   title: TypographyDemo.title),
        .init(build: { AnyView(ColourPaletteDemo()) }, title: ColourPaletteDemo.title),
        .init(build: { AnyView(ButtonDemo()) },       title: ButtonDemo.title),
    ]

    public var body: some View {
        List(pages) { entry in
            NavigationLink(entry.title) {
                entry.build()                     
                    .navigationTitle(entry.title)
            }
        }
        .navigationTitle("IRStyleKit Showcase")
    }
}

//TODO: Projede şuan SwiftUI sayfa yok. Ama burası gibi ayarlanabilir.

// MARK: – Example demo pages
struct TypographyDemo: ShowcasePage {
    var body: some View {
        VStack(spacing: 16) {
            Text("Display Large").font(.largeTitle)
            Text("Body Regular").font(.body)
            Text("Caption Small").font(.caption)
        }
        .padding()
    }
}

struct ColourPaletteDemo: ShowcasePage {
    var body: some View {
        VStack(spacing: 24) {
            Color.primary
                .frame(height: 60)
                .overlay(Text("Primary").foregroundStyle(.background))
            Color.secondary
                .frame(height: 60)
                .overlay(Text("Secondary").foregroundStyle(.background))
        }
        .padding()
    }
}

struct ButtonDemo: ShowcasePage {
    var body: some View {
        VStack(spacing: 20) {
            Button("Primary") {}
                .buttonStyle(.borderedProminent)

            Button("Secondary") {}
                .buttonStyle(.bordered)

            Button(role: .destructive) {}
            label: { Text("Destructive") }
                .buttonStyle(.bordered)
        }
        .padding()
    }
}

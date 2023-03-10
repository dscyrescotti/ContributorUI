//
//  ContributorCard.swift
//  
//
//  Created by Aye Chan on 3/9/23.
//

import SwiftUI

public struct ContributorCard: View {
    let configuration: Configuration
    
    @StateObject internal var viewModel: ContributorCardViewModel
    @State internal var width: CGFloat = .zero

    init(configuration: Configuration, viewModel: StateObject<ContributorCardViewModel>) {
        self.configuration = configuration
        self._viewModel = viewModel
    }

    public var body: some View {
        let columns = [GridItem](repeating: GridItem(.flexible(), spacing: configuration.spacing), count: configuration.countPerRow)
        let size = max(0, (width - configuration.spacing * CGFloat(configuration.countPerRow - 1)) / CGFloat(configuration.countPerRow))
        LazyVGrid(columns: columns, spacing: configuration.spacing) {
            ForEach(viewModel.contributors) { contributor in
                AsyncImage(url: URL(string: contributor.avatarURL)) { image in
                    image
                        .resizable()
                } placeholder: {
                    Color.black
                }
                .frame(width: size, height: size)
            }
        }
        .onChangeSize { size in
            width = size.width
        }
        .padding(configuration.padding)
        .background(configuration.backgroundStyle)
        .cornerRadius(configuration.cornerRadius)
        .border(with: configuration.borderStyle, cornerRadius: configuration.cornerRadius)
        .task {
            await viewModel.loadContributors(with: configuration)
        }
    }
}

extension ContributorCard {
    public init(owner: String, repo: String) {
        self.configuration = Configuration()
        let dependency = ContributorCardViewModel.Dependency(
            repo: repo,
            owner: owner,
            github: .live
        )
        let viewModel = ContributorCardViewModel(dependency: dependency)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
}

public extension ContributorCard {
    func padding(_ value: CGFloat) -> ContributorCard {
        var configuration = self.configuration
        configuration.padding = value
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }

    func backgroundStyle<S: ShapeStyle>(_ style: S) -> ContributorCard {
        var configuration = self.configuration
        configuration.backgroundStyle = AnyShapeStyle(style)
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }

    func spacing(_ value: CGFloat) -> ContributorCard {
        var configuration = self.configuration
        configuration.spacing = value
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }

    func cornerRadius(_ radius: CGFloat) -> ContributorCard {
        var configuration = self.configuration
        configuration.cornerRadius = radius
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }

    func borderStyle(_ style: BorderStyle) -> ContributorCard {
        var configuration = self.configuration
        configuration.borderStyle = style
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }

    func countPerRow(_ count: Int) -> ContributorCard {
        var configuration = self.configuration
        configuration.countPerRow = count
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }

    func maximumDisplayCount(_ count: Int) -> ContributorCard {
        var configuration = self.configuration
        configuration.maximumDisplayCount = count
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }

    func includesAnonymous(_ value: Bool) -> ContributorCard {
        var configuration = self.configuration
        configuration.includesAnonymous = value
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }
}

//
//  ContributorCard.swift
//  
//
//  Created by Aye Chan on 3/9/23.
//

import SwiftUI

public struct ContributorCard: View {
    let configuration: Configuration

    @State var width: CGFloat = .zero
    @State var selection: Contributor?
    @State var location: CGPoint = .zero
    @State var labelHeight: CGFloat = .zero
    @StateObject var viewModel: ContributorCardViewModel

    init(configuration: Configuration, viewModel: StateObject<ContributorCardViewModel>) {
        self.configuration = configuration
        self._viewModel = viewModel
    }

    public var body: some View {
        let columns = [GridItem](repeating: GridItem(.flexible(), spacing: configuration.spacing), count: configuration.countPerRow)
        let size: CGFloat = max(0, (width - configuration.spacing * CGFloat(configuration.countPerRow - 1)) / CGFloat(configuration.countPerRow))
        let count = configuration.maximumDisplayCount - viewModel.contributors.count
        let minimumHeight: CGFloat = size * CGFloat(configuration.minimumCardRowCount) + configuration.spacing * CGFloat(configuration.minimumCardRowCount - 1)
        LazyVGrid(columns: columns, spacing: configuration.spacing) {
            ForEach(viewModel.contributors) { contributor in
                AsyncImage(url: contributor.imageURL) { image in
                    image
                        .resizable()
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.secondary)
                        .shimmering()
                }
                .hovering(selection: $selection, location: $location, contributor: contributor)
                .frame(width: size, height: size)
                .clipShape(configuration.avatarStyle.shape())
            }
            if viewModel.isLoading, count > 0 {
                ForEach(0..<count, id: \.self) { _ in
                    Rectangle()
                        .foregroundColor(.secondary)
                        .frame(width: size, height: size)
                        .shimmering()
                        .clipShape(configuration.avatarStyle.shape())
                }
            }
        }
        .onChangeSize { size in
            width = size.width
        }
        .frame(minHeight: minimumHeight, alignment: .topLeading)
        .padding(configuration.padding)
        .background(configuration.backgroundStyle)
        .cornerRadius(configuration.cornerRadius)
        .borderStyle(with: configuration.borderStyle, cornerRadius: configuration.cornerRadius)
        .coordinateSpace(name: "contributor-cards")
        .overlay {
            hoverLabel
        }
        .task {
            await viewModel.loadContributors(with: configuration)
        }
        .onChange(of: configuration) { configuration in
            Task {
                await viewModel.loadContributors(with: configuration)
            }
        }
    }

    @ViewBuilder
    var hoverLabel: some View {
        if let contributor = selection {
            Text(contributor.login)
                .font(configuration.labelStyle.font)
                .foregroundColor(configuration.labelStyle.color)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(configuration.labelStyle.backgroundStyle, in: BubbleBox())
                .shadow(radius: 10)
                .onChangeSize { size in
                    labelHeight = size.height
                }
                .position(x: location.x, y: location.y - labelHeight / 2 - 8)
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

    func labelStyle(_ style: LabelStyle) -> ContributorCard {
        var configuration = self.configuration
        configuration.labelStyle = style
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }
    
    func minimumCardRowCount(_ value: Int) -> ContributorCard {
        var configuration = self.configuration
        configuration.minimumCardRowCount = value
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }
    
    func avatarStyle(_ style: AvatarStyle) -> ContributorCard {
        var configuration = self.configuration
        configuration.avatarStyle = style
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }
}

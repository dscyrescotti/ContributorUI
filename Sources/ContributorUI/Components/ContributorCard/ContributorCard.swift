//
//  ContributorCard.swift
//  
//
//  Created by Aye Chan on 3/9/23.
//

import SwiftUI
import Kingfisher

public struct ContributorCard: View {
    let configuration: Configuration

    @State var width: CGFloat = .zero
    @State var selection: Contributor?
    @State var location: CGPoint = .zero
    @State var labelHeight: CGFloat = .zero
    @StateObject var viewModel: ContributorCardViewModel

    #if canImport(XCTest)
    internal let inspection = Inspection<Self>()
    #endif

    init(configuration: Configuration, viewModel: StateObject<ContributorCardViewModel>) {
        self.configuration = configuration
        self._viewModel = viewModel
    }

    public var body: some View {
        contentView
            .onChangeSize { size in
                width = size.width
            }
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
            #if canImport(XCTest)
            .onReceive(inspection.notice) {
                self.inspection.visit(self, $0)
            }
            #endif
    }

    @ViewBuilder
    var contentView: some View {
        let countPerRow = Int(width / configuration.estimatedSize)
        let columns = [GridItem](repeating: GridItem(.flexible(), spacing: configuration.spacing), count: countPerRow)
        let size: CGFloat = max(0, (width - configuration.spacing * CGFloat(countPerRow - 1)) / CGFloat(max(countPerRow, 1)))
        let count = configuration.maximumDisplayCount - viewModel.contributors.count
        let minimumHeight: CGFloat = size * CGFloat(configuration.minimumCardRowCount) + configuration.spacing * CGFloat(configuration.minimumCardRowCount - 1)
        
        if viewModel.contributors.isEmpty, let error = viewModel.error {
            ErrorPrompt(error: error) {
                await viewModel.loadContributors(with: configuration)
            }
            .frame(minHeight: minimumHeight)
        } else {
            LazyVGrid(columns: columns, spacing: configuration.spacing) {
                ForEach(viewModel.contributors) { contributor in
                    KFImage(contributor.imageURL)
                        .placeholder {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.4))
                        }
                        .resizable()
                        .diskCacheExpiration(.days(1))
                        .hovering(selection: $selection, location: $location, contributor: contributor)
                        .frame(width: size, height: size)
                        .clipShape(configuration.avatarStyle.shape())
                }
                if viewModel.isLoading, count > 0 {
                    ForEach(0..<count, id: \.self) { _ in
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.4))
                            .shimmering()
                            .frame(width: size, height: size)
                            .clipShape(configuration.avatarStyle.shape())
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: minimumHeight, alignment: .topLeading)
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
        self.configuration = Configuration(repo: repo, owner: owner)
        let viewModel = ContributorCardViewModel(github: .live)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    #if canImport(XCTest)
    init(owner: String, repo: String, github: GitHub) {
        self.configuration = Configuration(repo: repo, owner: owner)
        let viewModel = ContributorCardViewModel(github: github)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    #endif
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

    func estimatedSize(_ value: CGFloat) -> ContributorCard {
        var configuration = self.configuration
        configuration.estimatedSize = value
        return ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }

    func maximumDisplayCount(_ count: Int) -> ContributorCard {
        var configuration = self.configuration
        configuration.maximumDisplayCount = count
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

extension ContributorCard {
    func configure(with configuration: Configuration) -> ContributorCard {
        ContributorCard(configuration: configuration, viewModel: self._viewModel)
    }
}

//
//  ErrorPrompt.swift
//  
//
//  Created by Aye Chan on 3/15/23.
//

import SwiftUI
import Foundation

struct ErrorPrompt: View {
    let error: APIError
    let retryAction: () async -> Void
    var body: some View {
        VStack(spacing: 5) {
            if let title = error.errorDescription, let message = error.recoverySuggestion {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            if error == .unknownError {
                Button {
                    Task {
                        await retryAction()
                    }
                } label: {
                    Label("Retry", systemImage: "arrow.clockwise")
                }
                .font(.callout)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

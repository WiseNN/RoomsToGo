//
//  RoomsToGoMessageCenterApp.swift
//  RoomsToGoMessageCenter
//
//  Created by Norris Wise Jr on 5/9/24.
//

import SwiftUI

@main
struct RoomsToGoMessageCenterApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView()
				.environmentObject(Network())
        }
    }
}

//
//  MessagesView.swift
//  RoomsToGoMessageCenter
//
//  Created by Norris Wise Jr on 5/9/24.
//

import Foundation
import SwiftUI

struct MessagesView: View {
	
	@EnvironmentObject var network: Network
	
	var body: some View {
		if let first = network.messages.msgAry.first, !first.isEmpty {
			List(network.messages.msgAry, id: \.self) { item in
				Section {
					ForEach(item, id: \.self) { msg in
						HStack {
							if let status = msg.message, let date = msg.getFormattedDate() {
								Text(status)
									.font(Font.custom("Poppins-Medium", size: 14))
								Spacer()
								Text(date)
									.font(Font.custom("Poppins-Medium", size: 14))
							}
						}
					}
				} header: {
					Text("Message Center")
						.font(Font.custom("Poppins-Bold", size: 16))
						.foregroundStyle(Color.init(hex: "#07263B"))
						
				}
			}
			.listStyle(.plain)
		} else {
			Text("Sorry There are No Updates Yet.\nCheck back again Soon! 🙂")
				.padding()
				.multilineTextAlignment(.center)
				.font(Font.custom("Poppins-Medium", size: 14))
		}
	}
}


#Preview {
	MessagesView()
		.environmentObject(Network())
}

//
//  MessagesView.swift
//  RoomsToGoMessageCenter
//
//  Created by Norris Wise Jr on 5/9/24.
//

import Foundation
import SwiftUI

struct MessagesView: View {
	@State var textViewID: String = "\(UUID())"
	
	
	let emailAddress: String
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
			.refreshable {
				if emailAddress != "" {
					network.getMessages(emailAddress: emailAddress)
				}
			}
		} else {
			ScrollView {
				
				Text("Sorry There are No Updates Yet.\nCheck back again Soon! 🙂")
					.padding()
					.multilineTextAlignment(.center)
					.font(Font.custom("Poppins-Medium", size: 14))
					.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
					.id(textViewID)
			}
			.refreshable {
				if emailAddress != "" {
					network.getMessages(emailAddress: emailAddress)
				}
			}
		}
	}
}


#Preview {
	MessagesView(emailAddress: "mtaylor@gmail.com")
		.environmentObject(Network())
}





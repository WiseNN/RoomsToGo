//
//  Network.swift
//  RoomsToGoMessageCenter
//
//  Created by Norris Wise Jr on 5/9/24.
//

import Foundation


class Network: ObservableObject {
	
	@Published var messages: Messages = .init(msgAry: [])
	var error: NetworkError! = nil {
		didSet {
			if let _ = error{
				hasError = true
			}
		}
	}
	@Published var hasError: Bool = false
	@Published var shouldPresent: Bool = false
	
	var dataTask: URLSessionDataTask?
	
	func getMessages(emailAddress: String) {
		dataTask?.cancel()
		let matcher = /[aA0-zZ9]+@[aA0-zZ9]+\.[aA0-zZ9]+/
		
		guard emailAddress.wholeMatch(of: matcher) != nil  else {
			self.error = NetworkError.client("Please enter a valid email address")
			return
		}
		
		guard let url = URL(string: "https://vcp79yttk9.execute-api.us-east-1.amazonaws.com/messages/users/\(emailAddress)") else {
			fatalError("Malformed URL")
		}
		
		let urlRequest = URLRequest(url: url)
		
		self.dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self] data, resp, err in
			DispatchQueue.main.async {
				
				if let err = err {
					self?.error = NetworkError.client(err.localizedDescription)
					return
				}
				guard let httpResp = resp as? HTTPURLResponse, (200...300).contains(httpResp.statusCode) else {
					self?.error = NetworkError.server
					return
				}
				let messages: Messages
				do {
					if let data = data {
						let msgAry = try JSONDecoder().decode([Message].self, from: data).compactMap { $0 }.filter { $0.message != "" }
						messages = Messages(msgAry: [msgAry.sorted()])
					} else {
						messages = .init(msgAry: [[]])
					}
					self?.messages = messages
					self?.hasError = false
					self?.shouldPresent = true
				} catch let err {
					print("Error: \(err)")
					self?.error = NetworkError.client(err.localizedDescription)
				}
			}
		})
		self.dataTask?.resume()
	}
	
	
}


enum NetworkError: Error {
	case client(String)
	case server
	
	var msg: String {
		switch self {
			case .client(let errMsg): return errMsg
			case .server: return "Server Error. Missing Data"
		}
	}
	var hasError: Bool {
		switch self {
			case .client(_), .server: true
		}
	}
}

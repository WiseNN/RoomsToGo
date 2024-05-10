//
//  Models.swift
//  RoomsToGoMessageCenter
//
//  Created by Norris Wise Jr on 5/9/24.
//

import Foundation

struct Messages {
	var msgAry: [[Message]]
}

struct Message: Codable, Hashable {
	var name: String?
	var date: String?
	var message: String?
}


extension Message {
	func getUTCDate() -> Date? {
		let trimmmedDate = self.date?.replacingOccurrences(of: "\\.\\d+.", with: "", options: .regularExpression, range: nil) ?? ""
		let parsingDf = DateFormatter()
		parsingDf.timeZone = TimeZone(abbreviation: "UTC")
		parsingDf.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		guard let parsedDate = parsingDf.date(from: trimmmedDate) else {
			return nil
		}
		return parsedDate
	}
	func getFormattedDate() -> String? {
		
		let ddF = DateFormatter()
		ddF.locale = .current
		ddF.timeZone = .current
		ddF.calendar = .current
		ddF.dateFormat = "MM/d/yyyy"
		guard let parsedDate = getUTCDate() else {
			return nil
		}
		let strLocalizedDate = ddF.string(from: parsedDate)
		guard let localizedDate = ddF.date(from: strLocalizedDate) else {
			return "N/A"
		}
		
		return ddF.string(from: localizedDate)
	}
}

extension Message: Comparable {
	static func < (lhs: Message, rhs: Message) -> Bool {
		guard let lhsDate = lhs.getUTCDate(), let rhsDate = rhs.getUTCDate() else { return false }
		return lhsDate < rhsDate
	}
	
	
}

extension Messages {
	#if DEBUG
	 func generateJSONTest() -> Self? {
		let jsonSTR =
		"""
		 [{
		   "name": "Michael Taylor",
		   "date": "2022-02-22T05:00:00.000Z",
		   "message": "Your order has been shipped. Track now!"
		   }]
		"""
		
		
		let jsonData = jsonSTR.data(using: .utf8)!
		do {
			let msgsAry = try JSONDecoder().decode([Message].self, from: jsonData)
			return Self(msgAry: [msgsAry])
		} catch let err {
			print("Cannot Generate \(String(describing: Self.self)) data. Error: \(err)")
			return nil
		}
	}
	#endif
}





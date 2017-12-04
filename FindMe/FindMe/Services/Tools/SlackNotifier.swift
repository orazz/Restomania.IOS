//
//  Slack.swift
//  FindMe
//
//  Created by Алексей on 29.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class SlackNotifier {

    public static func notify(_ message: String) {

        do {
            let payload = [
                "text": message
            ]
            let address = "https://hooks.slack.com/services/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"

            if let url = NSURL(string: address)
            {
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "POST"
                request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
                let session = URLSession.shared
                let task = session.dataTask(with: request as URLRequest) {
                    (data, response, error) -> Void in
                    if error != nil {
                        print("error: \(String(describing: error?.localizedDescription))")
                    }
                }
                task.resume()
            }
        }
        catch {}
    }
}

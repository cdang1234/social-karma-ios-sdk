import SwiftUI
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct SocialKarma: View {
    @State var apiKey: String
    @State var report: String = ""
    @State var placeholder: String = "Additional information (optional)"
    
    var body: some View {
        VStack {
            ZStack {
                if self.report.isEmpty {
                        TextEditor(text: $placeholder)
                            .font(.body)
                            .foregroundColor(.gray)
                            .disabled(true)
                            .padding()
                            .frame(height:250)
                }
                TextEditor(text: $report)
                    .font(.body)
                    .opacity(self.report.isEmpty ? 0.25 : 1)
                    .padding()
                    .frame(height:250)
            }
            
            Button(action: {
                let semaphore = DispatchSemaphore (value: 0)

                let parameters = "{\"ReportedUserId\": \"127\", \"ReportingUserId\": \"20\", \"Offense\": 1, \"Title\": \"Test\", \"Description\": \"our moderation team caught chris performing an imposter scam through X means with Y victim\", \"Status\": 1, \"Priority\": 1}"
                let postData = parameters.data(using: .utf8)

                var request = URLRequest(url: URL(string: "https://api.socialkarma.xyz/api/v1/report")!,timeoutInterval: Double.infinity)
                request.addValue("22f30b08-b169-11ec-b909-0242ac120002", forHTTPHeaderField: "Auth")
                request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

                request.httpMethod = "POST"
                request.httpBody = postData

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                  guard let data = data else {
                    print(String(describing: error))
                    semaphore.signal()
                    return
                  }
                  print(String(data: data, encoding: .utf8)!)
                  semaphore.signal()
                }

                task.resume()
                semaphore.wait()
            }) {
                Text("Submit")
                    .padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                    )
            }
            
            Text("Powered by Social Karma")
                .font(.system(size: 12.0))
                .padding(10)
        }
    }
}

struct SocialKarmaPreview: PreviewProvider {
    static var previews: some View {
        SocialKarma(apiKey: "Test")
    }
}

import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var canvasView = PKCanvasView()
    @State private var processedText: String = ""
    @State private var processedImage: UIImage? = nil
    @State private var showProcessedView = false
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    // OpenAI API Key
    private let openAIAPIKey = "YOUR_OPENAI_API_KEY"
    
    var body: some View {
        NavigationView {
            VStack {
                drawingCanvasSection()
                actionButtonsSection()
                if isLoading {
                    ProgressView("Processing...")
                } else {
                    aiGeneratedTextSection()
                    aiGeneratedImageSection()
                }
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Tabula AI")
        }
    }
    
    // MARK: - View Builders
    
    @ViewBuilder
    private func drawingCanvasSection() -> some View {
        CanvasView(canvasView: $canvasView)
            .frame(height: 400)
            .border(Color.gray, width: 1)
            .padding(.bottom, 10)
    }
    
    @ViewBuilder
    private func actionButtonsSection() -> some View {
        HStack(spacing: 20) {
            Button(action: processDrawing) {
                Text("Process Drawing")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isLoading)
            
            Button(action: clearCanvas) {
                Text("Clear Canvas")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isLoading)
        }
        .padding()
    }
    
    @ViewBuilder
    private func aiGeneratedTextSection() -> some View {
        if !processedText.isEmpty {
            VStack {
                Text("AI Interpretation:")
                    .font(.headline)
                    .padding(.top)
                
                Text(processedText)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    private func aiGeneratedImageSection() -> some View {
        if let img = processedImage {
            VStack {
                Text("Generated Image:")
                    .font(.headline)
                    .padding(.top)
                
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300, maxHeight: 300)
                    .padding()
            }
        }
    }
    
    // MARK: - Canvas View
    struct CanvasView: UIViewRepresentable {
        @Binding var canvasView: PKCanvasView
        
        func makeUIView(context: Context) -> PKCanvasView {
            canvasView.tool = PKInkingTool(.pen, color: .black, width: 1)
            canvasView.drawingPolicy = .anyInput
            canvasView.backgroundColor = .clear
            return canvasView
        }
        
        func updateUIView(_ canvasView: PKCanvasView, context: Context) {}
    }
    
    // MARK: - Functions
    
    func processDrawing() {
        guard !canvasView.drawing.bounds.isEmpty else {
            errorMessage = "Please draw something first"
            return
        }
        
        let image = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
        isLoading = true
        errorMessage = nil
        sendImageToAI(image: image)
    }
    
    func sendImageToAI(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Image conversion failed"
            isLoading = false
            return
        }
        
        let base64String = imageData.base64EncodedString()
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Use a valid Chat Completions format.
        let requestBody: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                [
                    "role": "user",
                    "content": """
                    Analyze the following base64-encoded image data and describe what you see:
                    \(base64String)
                    """
                ]
            ],
            "max_tokens": 300
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            DispatchQueue.main.async {
                errorMessage = "Failed to encode request body: \(error.localizedDescription)"
                isLoading = false
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("API Response: \(responseString)")
                }
                
                do {
                    let result = try JSONDecoder().decode(AIResponse.self, from: data)
                    if let content = result.choices.first?.message.content {
                        processedText = content
                    } else {
                        errorMessage = "No interpretation found in response"
                    }
                } catch {
                    errorMessage = "Response parsing error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func clearCanvas() {
        canvasView.drawing = PKDrawing()
        processedText = ""
        processedImage = nil
        errorMessage = nil
    }
}

// MARK: - Response Models
struct AIResponse: Codable {
    let id: String
    let choices: [Choice]
    let created: Int
    let model: String
    let usage: Usage?
}

struct Choice: Codable {
    let index: Int
    let message: Message
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }
}

struct Message: Codable {
    let role: String
    let content: String
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

# Tabula

# AI-Driven Illustration Application

## Overview
AI-Driven Illustration App is an innovative drawing application that transforms user sketches into high-quality illustrations using state-of-the-art AI models. Inspired by apps like Doodle Minds, this project leverages deep learning to continuously refine and personalize illustration generation. Users can draw freehand sketches using a natural drawing interface and upload their past sketches or images to receive dynamic outputs—ranging from static illustrations to experimental animations, music, or even 3D visuals.

## Features
- **Intuitive Drawing Interface:**  
  - Utilizes native Apple frameworks for a fluid drawing experience.
  - Supports real-time sketch capture with precise pencil input.
- **AI-Powered Illustration:**  
  - Converts sketches into high-quality illustrations using generative models.
  - Continuously refines its output by learning from user-generated data.
- **Cross-Platform Compatibility:**  
  - Designed for iOS and iPadOS, ensuring a seamless experience across devices.
- **On-Device Inference:**  
  - Employs Core ML for fast, efficient, and private AI processing directly on Apple hardware.

## Technologies
### Frontend (User Interface)
- **Xcode:**  
  - Primary IDE for building the iOS/iPadOS application.
- **SwiftUI:**  
  - Declarative framework for creating responsive, modern interfaces.
- **PencilKit:**  
  - Enables a natural drawing interface that captures detailed sketch inputs.
- **Core ML:**  
  - Integrates AI models into the app for on-device inference, ensuring speed and data privacy.

### Backend (AI Model Development)
- **Python:**  
  - Main programming language for developing and training the AI model.
- **PyTorch:**  
  - Deep learning framework used for creating generative models (e.g., conditional GANs like pix2pix or diffusion models).
- **coremltools:**  
  - Converts trained PyTorch models into Core ML format for seamless integration into the iOS app.
- **Optional API Frameworks:**  
  - **Flask/FastAPI:** Can be used for creating RESTful APIs if server-side model updates or remote processing are required.

### Development Tools
- **VSCode:**  
  - Ideal for Python development and managing AI model training.
- **Anaconda (Optional):**  
  - Provides an environment manager for handling dependencies and package versions efficiently.

## Project Architecture
1. **User Interface Layer:**  
   - Developed in Xcode using SwiftUI and PencilKit.
   - Captures user sketches and facilitates seamless interaction.
2. **AI Model Layer:**  
   - Developed using Python and PyTorch to generate illustrations from sketches.
   - Continuously improves through user feedback and transfer learning.
3. **Model Integration:**  
   - The trained model is converted to Core ML format using coremltools.
   - Integrated into the iOS app for on-device inference, ensuring low latency and preserving user privacy.
4. **Data Flow:**  
   - Sketches and images are processed locally.
   - Optionally, a backend API (via Flask or FastAPI) can manage aggregated data for continuous model training and improvement.

## Development Roadmap
1. **Initial Setup:**  
   - Configure development environments in Xcode and VSCode.
   - Set up a Git repository and CI/CD pipeline.
2. **User Interface Development:**  
   - Design the drawing interface with SwiftUI and PencilKit.
   - Implement core UI components and integrate local storage for user sketches.
3. **AI Model Development:**  
   - Develop a prototype generative model (e.g., conditional GAN or diffusion model) using PyTorch.
   - Train the model with sample datasets and refine its performance.
4. **Model Conversion & Integration:**  
   - Convert the trained model to Core ML using coremltools.
   - Integrate the model into the Xcode project and test on-device inference.
5. **Testing & Iteration:**  
   - Perform extensive testing on both iOS and iPadOS devices.
   - Collect user feedback and iterate on both UI and AI model performance.
6. **Deployment:**  
   - Finalize optimizations and prepare the app for App Store submission.

## Usage Instructions
1. **Frontend Setup (Xcode):**  
   - Open the project in Xcode.
   - Build and run the app on an iOS simulator or a physical device.
2. **Backend Setup (Python):**  
   - Navigate to the `ai-model` directory.
   - Create a Python virtual environment (using virtualenv or Anaconda).
   - Install dependencies via `pip install -r requirements.txt`.
   - Execute training scripts to generate the AI model.
3. **Model Integration:**  
   - Convert the trained model to Core ML format.
   - Import the Core ML model file into the Xcode project.
   - Validate the model’s performance through on-device inference tests.

## Contributing
Contributions are welcome. Please open an issue to discuss any significant changes before submitting a pull request. Adhere to the established coding standards and ensure comprehensive testing accompanies all contributions.

## License
MIT License

## Contact
For any questions or feedback, please contact Hakan Yorganci at hakanyorganci@gmail.com.

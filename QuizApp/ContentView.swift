import SwiftUI
import WebKit

struct ContentView: View {
   
    @State var selectedAnswerIndex: Int? = nil
    @State var showAlert = false
    @State var showWinScreen = false
    @State var showStartScreen = true
    @State private var time = 10
    @State private var start  = false;
    @State private var hasStarted = false;
    
    func startTimer(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if(start){
                time -= 1
            }
            
            if(time < 0){
                // time = 10
                goToNextQuestion()
            }
        }
    }
    
    var body: some View {
        
        VStack {
            if !showWinScreen && !showStartScreen{
                
                Text("\(time)")
                    .font(.largeTitle)
                    .onAppear {
                        if(!hasStarted){
                            startTimer()
                            hasStarted = true;
                        }
                        start = true;
                    }.onDisappear{
                        start = false;
                    }
                
                Text("Question \(quiz.currentQuestion + 1) of \(quiz.questions.count)")
                    .font(.headline.weight(.bold))
                    .padding()
                Text(quiz.questions[quiz.currentQuestion].text)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                ForEach(0..<quiz.questions[quiz.currentQuestion].answers.count) { index in
                    Button(action: {
                        selectedAnswerIndex = index
                        checkAnswer(index)
                        showAlert = true
                    }) {
                        Text(quiz.questions[quiz.currentQuestion].answers[index])
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .disabled(selectedAnswerIndex != nil)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(quiz.currentAnswerIsCorrect ? "Correct!" : "Wrong!"),
                        message: Text(quiz.currentAnswerIsCorrect ? "Good job!" : "The correct answer was \(quiz.questions[quiz.currentQuestion].answers[quiz.currentQuestionCorrectAnswerIndex])"),
                        dismissButton: .default(Text("OK")) {
                            goToNextQuestion()
                        }
                    )
                    
                }
                
                .padding()
                
            }else if showStartScreen{
                
                //     var body: some View{
                VStack{
                    Text("Let's Begin the Capitals Quiz!")
                        .font(.largeTitle.weight(.bold))
                    //  .frame(maxHeight: .infinity, alignment: .top)
                    //  .padding()
                    Text("Are you ready?")
                        .font(.headline)
                    // .frame(maxHeight: .infinity, alignment: .top)
                    //   .multilineTextAlignment(.center)
                    // .padding()
                    
                    Image("worldmap2022")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Button(action: {
                        showStartScreen = false
                        start = true
                    }) {
                        Text("Play")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                }
            }else {
                
                ZStack{
                   
                //    GeometryReader { geometry in
                    GIFView(gifName: "confetti")
                       // .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        .frame(width: 1000, height: 3000, alignment: .bottomLeading)
               //             .aspectRatio(contentMode: .fit)
              //              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
              //      }
                           
                   
                    VStack{
                        Text("Quiz complete!")
                            .font(.largeTitle.weight(.bold))
                            .padding()
                        
                        Text("You got \(quiz.score) out of \(quiz.questions.count) correct!")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Play Again") {
                            quiz = Quiz(questions: quiz.questions)
                            selectedAnswerIndex = nil
                            showWinScreen = false
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                }
                
            }
        }
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }

    func checkAnswer(_ selectedAnswerIndex: Int) {
        if selectedAnswerIndex == quiz.currentQuestionCorrectAnswerIndex {
            quiz.score += 1
            quiz.currentAnswerIsCorrect = true
        } else {
            quiz.currentAnswerIsCorrect = false
        }
    }

    func goToNextQuestion() {
        let hasNextQuestion = quiz.nextQuestion()
        selectedAnswerIndex = nil
        if !hasNextQuestion {
            showWinScreen = true
        }
        time=10
    }
    }

    struct Question {
    var text: String
    var answers: [String]
    var correctAnswerIndex: Int


    init(text: String, answers: [String], correctAnswerIndex: Int) {
        self.text = text
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
    }
    }

var quiz = Quiz(questions: [
   Question(text: "What is the capital of Italy?", answers: ["Rome", "Paris", "Berlin", "Madrid"], correctAnswerIndex: 0),
        Question(text: "What is the capital of Spain?", answers: ["London", "Paris", "Berlin", "Madrid"], correctAnswerIndex: 3),
    Question(text: "What is the capital of Japan?", answers: ["Tokyo", "Beijing", "Seoul", "Hanoi"], correctAnswerIndex: 0),
      Question(text: "What is the capital of France?", answers: ["Rome", "Paris", "Berlin", "Madrid"], correctAnswerIndex: 1),
       Question(text: "What is the capital of Germany?", answers: ["London", "Paris", "Berlin", "Madrid"], correctAnswerIndex: 2),
      Question(text: "What is the capital of Brazil?", answers: ["Brasília", "Rio de Janeiro", "São Paulo", "Buenos Aires"], correctAnswerIndex: 0),
      Question(text: "What is the capital of Australia?", answers: ["Sydney", "Melbourne", "Canberra", "Perth"], correctAnswerIndex: 2),
      Question(text: "What is the capital of India?", answers: ["Delhi", "Mumbai", "Kolkata", "Chennai"], correctAnswerIndex: 0),
       Question(text: "What is the capital of Canada?", answers: ["Toronto", "Vancouver", "Ottawa", "Montreal"], correctAnswerIndex: 2),
      Question(text: "What is the capital of Egypt?", answers: ["Cairo", "Alexandria", "Giza", "Luxor"], correctAnswerIndex: 0),
       Question(text: "Who is teh greatest coder on Earth?", answers: ["Shiven", "Joe", "Shrey", "Steve Jobs"], correctAnswerIndex: 2),
        Question(text: "Who is the best teacher", answers: ["Mr. Lein", "Mrs. Puff", "Albus Dumbledore", "Ms. Frizzle"], correctAnswerIndex: 0),
])




    class Quiz {
    var questions: [Question]
    var currentQuestion: Int = 0
    var score: Int = 0


    var currentQuestionCorrectAnswerIndex: Int {
        questions[currentQuestion].correctAnswerIndex
    }

    var currentAnswerIsCorrect: Bool = false

    init(questions: [Question]) {
        self.questions = questions.shuffled()
    }

    func nextQuestion() -> Bool {
        currentQuestion += 1
        if currentQuestion < questions.count {
            return true
        } else {
            currentQuestion = 0
            return false
        }
    }
    }


struct GIFView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let gifURL = Bundle.main.url(forResource: gifName, withExtension: "gif") {
            webView.loadFileURL(gifURL, allowingReadAccessTo: gifURL)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

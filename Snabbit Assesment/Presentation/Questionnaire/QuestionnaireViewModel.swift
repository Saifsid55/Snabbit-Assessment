
import Foundation


final class QuestionnaireViewModel: QuestionnaireViewModelProtocol {
    
    var onQuestionsLoaded: (([QuestionnaireQuestion]) -> Void)?
    var onSubmitSuccess: (() -> Void)?
    var onProgressChanged: ((Float) -> Void)?
    var isContinueEnabled: ((Bool) -> Void)?
    
    private var questions: [QuestionnaireQuestion] = []
    private var progress: Float = 0
    
    private let fetchUseCase: FetchQuestionnaireUseCaseProtocol
    private let submitUseCase: SubmitQuestionnaireUseCaseProtocol
    
    private var state = QuestionnaireState()
    
    init(
        fetchUseCase: FetchQuestionnaireUseCaseProtocol,
        submitUseCase: SubmitQuestionnaireUseCaseProtocol
    ) {
        self.fetchUseCase = fetchUseCase
        self.submitUseCase = submitUseCase
    }
    
    
    private var isFormValid: Bool {
        progress >= 1.0
    }
    
    func loadQuestions() {
        
        fetchUseCase.execute { [weak self] result in
            
            switch result {
                
            case .success(let questions):
                self?.questions = questions
                self?.onQuestionsLoaded?(questions)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func submit() {
        
        guard isFormValid else { return }
        
        submitUseCase.execute(state: state) { [weak self] result in
            
            switch result {
                
            case .success:
                self?.onSubmitSuccess?()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateProgress() {
        
        var completed = 0
        let total = max(questions.count, 1)
        
        if !state.selectedSkills.isEmpty { completed += 1 }
        
        if state.smartphoneAnswer != nil { completed += 1 }
        
        if state.smartphoneAnswer == "Yes" || state.phoneRequirementAnswer != nil {
            completed += 1
        }
        
        if state.googleMapsAnswer != nil { completed += 1 }
        
        if state.dobDay.count == 2 &&
            state.dobMonth.count == 2 &&
            state.dobYear.count == 4 {
            completed += 1
        }
        
        progress = Float(completed) / Float(total)
        
        onProgressChanged?(progress)
    }
    
    private func validate() {
        
        guard !state.selectedSkills.isEmpty else {
            isContinueEnabled?(false)
            return
        }
        
        guard let smartphoneAnswer = state.smartphoneAnswer else {
            isContinueEnabled?(false)
            return
        }
        
        if smartphoneAnswer == "No" && state.phoneRequirementAnswer == nil {
            isContinueEnabled?(false)
            return
        }
        
        guard state.googleMapsAnswer != nil else {
            isContinueEnabled?(false)
            return
        }
        
        guard state.dobDay.count == 2,
              state.dobMonth.count == 2,
              state.dobYear.count == 4 else {
            isContinueEnabled?(false)
            return
        }
        
        isContinueEnabled?(true)
    }
    
    func toggleSkill(_ skill: String) {
        
        if state.selectedSkills.contains(skill) {
            state.selectedSkills.remove(skill)
        } else {
            state.selectedSkills.insert(skill)
        }
        
        updateProgress()
        validate()
    }
    
    func selectSingleOption(questionId: String, value: String) {
        
        switch questionId {
            
        case "smartphone":
            state.smartphoneAnswer = value
            
        case "phone_requirement":
            state.phoneRequirementAnswer = value
            
        case "google_maps":
            state.googleMapsAnswer = value
            
        default:
            break
        }
        
        updateProgress()
        validate()
    }
    
    func updateDOB(day: String, month: String, year: String) {
        
        state.dobDay = day
        state.dobMonth = month
        state.dobYear = year
        
        updateProgress()
        validate()
    }
}

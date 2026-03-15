
import Foundation


// MARK: - Constants
enum QuestionnaireConstants {
    enum QuestionID {
        static let smartphone = "smartphone"
        static let phoneRequirement = "phone_requirement"
        static let googleMaps = "google_maps"
    }
    
    enum SmartphoneAnswer {
        static let yes = "Yes"
        static let no = "No"
    }
    
    enum DOB {
        static let dayLength = 2
        static let monthLength = 2
        static let yearLength = 4
    }
}

// MARK: - ViewModel
final class QuestionnaireViewModel: QuestionnaireViewModelProtocol {
    
    // MARK: - Delegate
    weak var delegate: QuestionnaireViewModelDelegate?
    
    // MARK: - Dependencies
    private let fetchUseCase: FetchQuestionnaireUseCaseProtocol
    private let submitUseCase: SubmitQuestionnaireUseCaseProtocol
    
    // MARK: - State
    
    private var questions: [QuestionnaireQuestion] = []
    private var progress: Float = 0
    private var state = QuestionnaireState()
    
    // MARK: - Init
    init(
        fetchUseCase: FetchQuestionnaireUseCaseProtocol,
        submitUseCase: SubmitQuestionnaireUseCaseProtocol
    ) {
        self.fetchUseCase = fetchUseCase
        self.submitUseCase = submitUseCase
    }
    
    // MARK: - Validation
    private var isFormValid: Bool { progress >= 1.0 }
    
    // MARK: - Load
    
    func loadQuestions() async {
        do {
            let questions = try await fetchUseCase.execute()
            self.questions = questions
            delegate?.didLoadQuestions(questions)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Submit
    
    func submit() async {
        guard isFormValid else { return }
        do {
            try await submitUseCase.execute(state: state)
            delegate?.didSubmitSuccess()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Input Handlers
    
    func toggleSkill(_ skill: String) {
        if state.selectedSkills.contains(skill) {
            state.selectedSkills.remove(skill)
        } else {
            state.selectedSkills.insert(skill)
        }
        updateProgressAndValidate()
    }
    
    func selectSingleOption(questionId: String, value: String) {
        switch questionId {
        case QuestionnaireConstants.QuestionID.smartphone:
            state.smartphoneAnswer = value
        case QuestionnaireConstants.QuestionID.phoneRequirement:
            state.phoneRequirementAnswer = value
        case QuestionnaireConstants.QuestionID.googleMaps:
            state.googleMapsAnswer = value
        default:
            break
        }
        updateProgressAndValidate()
    }
    
    func updateDOB(day: String, month: String, year: String) {
        state.dobDay = day
        state.dobMonth = month
        state.dobYear = year
        updateProgressAndValidate()
    }
    
    // MARK: - Private Helpers
    
    private func updateProgressAndValidate() {
        updateProgress()
        validate()
    }
    
    private func updateProgress() {
        let dob = QuestionnaireConstants.DOB.self
        var completed = 0
        let total = max(questions.count, 1)
        
        if !state.selectedSkills.isEmpty { completed += 1 }
        if state.smartphoneAnswer != nil { completed += 1 }
        if state.smartphoneAnswer == QuestionnaireConstants.SmartphoneAnswer.yes || state.phoneRequirementAnswer != nil { completed += 1 }
        if state.googleMapsAnswer != nil { completed += 1 }
        if state.dobDay.count == dob.dayLength &&
            state.dobMonth.count <= dob.monthLength &&
            state.dobYear.count == dob.yearLength { completed += 1 }
        
        progress = Float(completed) / Float(total)
        delegate?.didUpdateProgress(progress)
    }
    
    private func validate() {
        let dob = QuestionnaireConstants.DOB.self
        
        guard !state.selectedSkills.isEmpty else { return delegate?.didUpdateContinueEnabled(false) ?? () }
        guard let smartphoneAnswer = state.smartphoneAnswer else { return delegate?.didUpdateContinueEnabled(false) ?? () }
        if smartphoneAnswer == QuestionnaireConstants.SmartphoneAnswer.no && state.phoneRequirementAnswer == nil {
            return delegate?.didUpdateContinueEnabled(false) ?? ()
        }
        guard state.googleMapsAnswer != nil else { return delegate?.didUpdateContinueEnabled(false) ?? () }
        guard state.dobDay.count == dob.dayLength,
              state.dobMonth.count == dob.monthLength,
              state.dobYear.count == dob.yearLength else { return delegate?.didUpdateContinueEnabled(false) ?? () }
        
        delegate?.didUpdateContinueEnabled(true)
    }
}

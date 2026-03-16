import Foundation

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
        static let maxDay = 31
        static let maxMonth = 12
        static let minDay = 1
        static let minMonth = 1
    }
}

final class QuestionnaireViewModel: QuestionnaireViewModelProtocol {
    weak var delegate: QuestionnaireViewModelDelegate?
    
    private let fetchUseCase: FetchQuestionnaireUseCaseProtocol
    private let submitUseCase: SubmitQuestionnaireUseCaseProtocol
    private var questions: [QuestionnaireQuestion] = []
    private var progress: Float = 0
    private var state = QuestionnaireState()
    
    private var isFormValid: Bool { progress >= 1.0 }
    
    init(
        fetchUseCase: FetchQuestionnaireUseCaseProtocol,
        submitUseCase: SubmitQuestionnaireUseCaseProtocol
    ) {
        self.fetchUseCase = fetchUseCase
        self.submitUseCase = submitUseCase
    }
    
    func loadQuestions() async {
        do {
            let questions = try await fetchUseCase.execute()
            self.questions = questions
            delegate?.didLoadQuestions(questions)
        } catch {
            print(error)
        }
    }
    
    func submit() async {
        guard isFormValid else { return }
        do {
            try await submitUseCase.execute(state: state)
            delegate?.didSubmitSuccess()
        } catch {
            print(error)
        }
    }
    
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
        let paddedDay = padded(day, maxLength: QuestionnaireConstants.DOB.dayLength)
        let paddedMonth = padded(month, maxLength: QuestionnaireConstants.DOB.monthLength)
        state.dobDay = paddedDay
        state.dobMonth = paddedMonth
        state.dobYear = year
        delegate?.didUpdateDOBFields(day: paddedDay, month: paddedMonth, year: year)
        updateProgressAndValidate()
    }
}

private extension QuestionnaireViewModel {
    func updateProgressAndValidate() {
        updateProgress()
        validate()
    }
    
    func updateProgress() {
        let dob = QuestionnaireConstants.DOB.self
        var completed = 0
        let total = max(questions.count, 1)
        if !state.selectedSkills.isEmpty { completed += 1 }
        if state.smartphoneAnswer != nil { completed += 1 }
        if state.smartphoneAnswer == QuestionnaireConstants.SmartphoneAnswer.yes || state.phoneRequirementAnswer != nil { completed += 1 }
        if state.googleMapsAnswer != nil { completed += 1 }
        if isDOBLengthValid(dob: dob) { completed += 1 }
        progress = Float(completed) / Float(total)
        delegate?.didUpdateProgress(progress)
    }
    
    func validate() {
        let dob = QuestionnaireConstants.DOB.self
        guard !state.selectedSkills.isEmpty else { return delegate?.didUpdateContinueEnabled(false) ?? () }
        guard let smartphoneAnswer = state.smartphoneAnswer else { return delegate?.didUpdateContinueEnabled(false) ?? () }
        if smartphoneAnswer == QuestionnaireConstants.SmartphoneAnswer.no && state.phoneRequirementAnswer == nil {
            return delegate?.didUpdateContinueEnabled(false) ?? ()
        }
        guard state.googleMapsAnswer != nil else { return delegate?.didUpdateContinueEnabled(false) ?? () }
        guard isDOBLengthValid(dob: dob) else { return delegate?.didUpdateContinueEnabled(false) ?? () }
        guard isDOBRangeValid() else { return delegate?.didUpdateContinueEnabled(false) ?? () }
        delegate?.didUpdateContinueEnabled(true)
    }
    
    func isDOBLengthValid(dob: QuestionnaireConstants.DOB.Type) -> Bool {
        state.dobDay.count == dob.dayLength &&
        state.dobMonth.count == dob.monthLength &&
        state.dobYear.count == dob.yearLength
    }
    
    func isDOBRangeValid() -> Bool {
        let dob = QuestionnaireConstants.DOB.self
        guard
            let day = Int(state.dobDay),
            let month = Int(state.dobMonth)
        else { return false }
        return day >= dob.minDay && day <= dob.maxDay
        && month >= dob.minMonth && month <= dob.maxMonth
    }
    
    func padded(_ value: String, maxLength: Int) -> String {
        guard let number = Int(value), value.count == maxLength - 1 else { return value }
        return String(format: "%0\(maxLength)d", number)
    }
}

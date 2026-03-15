
import Foundation

protocol QuestionnaireViewModelProtocol {
    
    // MARK: - Outputs
    
    var onQuestionsLoaded: (([QuestionnaireQuestion]) -> Void)? { get set }
    
    var onSubmitSuccess: (() -> Void)? { get set }
    
    var onProgressChanged: ((Float) -> Void)? { get set }
    
    var isContinueEnabled: ((Bool) -> Void)? { get set }
    // MARK: - Lifecycle
    
    func loadQuestions()
    
    func toggleSkill(_ skill: String)
    
    // MARK: - Submit
    
    func submit()
    
    func selectSingleOption(questionId: String, value: String)
    func updateDOB(day: String, month: String, year: String)
}

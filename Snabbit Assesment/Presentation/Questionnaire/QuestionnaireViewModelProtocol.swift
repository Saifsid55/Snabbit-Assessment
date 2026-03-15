
import Foundation

// MARK: - Delegate Protocol
protocol QuestionnaireViewModelDelegate: AnyObject {
    func didLoadQuestions(_ questions: [QuestionnaireQuestion])
    func didSubmitSuccess()
    func didUpdateProgress(_ progress: Float)
    func didUpdateContinueEnabled(_ enabled: Bool)
}
 
// MARK: - ViewModel Protocol
protocol QuestionnaireViewModelProtocol: AnyObject {
    var delegate: QuestionnaireViewModelDelegate? { get set }
    func loadQuestions() async
    func submit() async
    func toggleSkill(_ skill: String)
    func selectSingleOption(questionId: String, value: String)
    func updateDOB(day: String, month: String, year: String)
}

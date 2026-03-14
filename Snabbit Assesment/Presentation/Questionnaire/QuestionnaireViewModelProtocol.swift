
import Foundation

protocol QuestionnaireViewModelProtocol {
    
    var isContinueEnabled: ((Bool) -> Void)? { get set }
    
    var onProgressChanged: ((Float) -> Void)?  { get set }
    
    var onFormCompleted: (() -> Void)? { get set }

    func submit()
    
    func toggleSkill(_ skill: String)
    
    func selectSmartphone(_ value: Bool)
    
    func selectCanGetPhone(_ value: Bool)
    
    func selectGoogleMaps(_ value: Bool)
    
    func updateDOB(day: String, month: String, year: String)
    
}


import Foundation

final class QuestionnaireViewModel: QuestionnaireViewModelProtocol {
    
    var isContinueEnabled: ((Bool) -> Void)?
    
    private var selectedSkills: Set<String> = []
    
    private var hasSmartphone: Bool?
    private var canGetPhone: Bool?
    
    private var usedGoogleMaps: Bool?
    
    private var dobDay = ""
    private var dobMonth = ""
    private var dobYear = ""
    
    func toggleSkill(_ skill: String) {
        
        if selectedSkills.contains(skill) {
            selectedSkills.remove(skill)
        } else {
            selectedSkills.insert(skill)
        }
        
        validate()
    }
    
    func selectSmartphone(_ value: Bool) {
        hasSmartphone = value
        
        if value == true {
            canGetPhone = nil
        }
        
        validate()
    }
    
    func selectCanGetPhone(_ value: Bool) {
        canGetPhone = value
        validate()
    }
    
    func selectGoogleMaps(_ value: Bool) {
        usedGoogleMaps = value
        validate()
    }
    
    func updateDOB(day: String, month: String, year: String) {
        
        dobDay = day
        dobMonth = month
        dobYear = year
        
        validate()
    }
    
    private func validate() {
        
        guard !selectedSkills.isEmpty else {
            isContinueEnabled?(false)
            return
        }
        
        guard let hasSmartphone else {
            isContinueEnabled?(false)
            return
        }
        
        if hasSmartphone == false && canGetPhone == nil {
            isContinueEnabled?(false)
            return
        }
        
        guard usedGoogleMaps != nil else {
            isContinueEnabled?(false)
            return
        }
        
        guard !dobDay.isEmpty,
              !dobMonth.isEmpty,
              !dobYear.isEmpty else {
            isContinueEnabled?(false)
            return
        }
        
        isContinueEnabled?(true)
    }
}

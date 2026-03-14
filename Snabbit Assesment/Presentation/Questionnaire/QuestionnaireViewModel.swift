
import Foundation



final class QuestionnaireViewModel: QuestionnaireViewModelProtocol {
    
    var isContinueEnabled: ((Bool) -> Void)?
    var onProgressChanged: ((Float) -> Void)?
    
    private var selectedSkills: Set<String> = []
    
    private var hasSmartphone: Bool?
    private var canGetPhone: Bool?
    private var googleMapsAnswer: Bool?
    
    private var dobDay = ""
    private var dobMonth = ""
    private var dobYear = ""
    
    // MARK: - Skills
    
    func toggleSkill(_ skill: String) {
        
        if selectedSkills.contains(skill) {
            selectedSkills.remove(skill)
        } else {
            selectedSkills.insert(skill)
        }
        
        updateProgress()
        validate()
    }
    
    // MARK: - Smartphone
    
    func selectSmartphone(_ value: Bool) {
        
        hasSmartphone = value
        
        if value == true {
            canGetPhone = nil
        }
        
        updateProgress()
        validate()
    }
    
    func selectCanGetPhone(_ value: Bool) {
        
        canGetPhone = value
        
        updateProgress()
        validate()
    }
    
    // MARK: - Google Maps
    
    func selectGoogleMaps(_ value: Bool) {
        
        googleMapsAnswer = value
        
        updateProgress()
        validate()
    }
    
    // MARK: - DOB
    
    func updateDOB(day: String, month: String, year: String) {
        
        dobDay = day
        dobMonth = month
        dobYear = year
        
        updateProgress()
        validate()
    }
    
    // MARK: - Progress
    
    private func updateProgress() {
        
        var completed = 0
        let total = 5
        
        if !selectedSkills.isEmpty { completed += 1 }
        if hasSmartphone != nil { completed += 1 }
        if canGetPhone != nil || hasSmartphone == true { completed += 1 }
        if googleMapsAnswer != nil { completed += 1 }
        
        if dobDay.count == 2 && dobMonth.count == 2 && dobYear.count == 4 {
            completed += 1
        }
        
        let progress = Float(completed) / Float(total)
        
        onProgressChanged?(progress)
    }
    
    // MARK: - Validation
    
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
        
        guard googleMapsAnswer != nil else {
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

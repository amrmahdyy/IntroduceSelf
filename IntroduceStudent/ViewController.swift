import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberOfPets: UITextField!
    @IBOutlet weak var universityImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var schoolName: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var collegeYears: UISegmentedControl!

    private var morePetsSwitch = true {
        didSet {
            // Save morePetsSwitch state to UserDefaults when it changes
            UserDefaults.standard.set(morePetsSwitch, forKey: "morePetsSwitch")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.minimumValue = 0.0
        // Adding additional segments
        collegeYears.insertSegment(withTitle: "Third", at: 2, animated: false)
        collegeYears.insertSegment(withTitle: "Fourth", at: 3, animated: false)

        // Load saved data from UserDefaults
        loadSavedData()
    }

    // Function to load data from UserDefaults
    private func loadSavedData() {
        firstName.text = UserDefaults.standard.string(forKey: "firstName")
        lastName.text = UserDefaults.standard.string(forKey: "lastName")
        schoolName.text = UserDefaults.standard.string(forKey: "schoolName")
        if let numberOfPetsValue = UserDefaults.standard.string(forKey: "numberOfPets") {
            numberOfPets.text = numberOfPetsValue
            stepper.value = Double(numberOfPetsValue) ?? 0.0
        }
        morePetsSwitch = UserDefaults.standard.bool(forKey: "morePetsSwitch")
        if let selectedSegmentIndex = UserDefaults.standard.object(forKey: "selectedYear") as? Int {
            collegeYears.selectedSegmentIndex = selectedSegmentIndex
        }
    }

    @IBAction func stepperTapped(_ sender: UIStepper) {
        numberOfPets.text = Int(sender.value).description
        // Save the number of pets when stepper is tapped
        UserDefaults.standard.set(numberOfPets.text, forKey: "numberOfPets")
    }

    @IBAction private func switchTapped(_ sender: UISwitch) {
        // Update and save morePetsSwitch state when switch is tapped
        self.morePetsSwitch = sender.isOn
    }

    @IBAction private func textFieldEditingDidEnd(_ sender: UITextField) {
        // Save text field data when editing ends
        UserDefaults.standard.set(firstName.text, forKey: "firstName")
        UserDefaults.standard.set(lastName.text, forKey: "lastName")
        UserDefaults.standard.set(schoolName.text, forKey: "schoolName")
    }

    @IBAction private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Save the selected year when the segmented control value changes
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "selectedYear")
    }

    @IBAction private func introduceSelfTapped(_ sender: UIButton) {
        // Create introduction string using saved and current data
        let selectedYear = collegeYears.selectedSegmentIndex != UISegmentedControl.noSegment ?
            collegeYears.titleForSegment(at: collegeYears.selectedSegmentIndex) ?? "a year" :
            "a year"

        let introduction = """
        My name is \(firstName.text ?? "first name") \(lastName.text ?? "last name") and I attend \(schoolName.text ?? "school").
        I am currently in my \(selectedYear) year and I own \(numberOfPets.text ?? "some") pets.
        It is \(morePetsSwitch ? "true" : "not true") that I want more pets.
        """

        // Display introduction in an alert
        let alert = UIAlertController(title: "My introduction", message: introduction, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    var health = HealthKitManager.shared
    var ss = DataForSevenDay.shared
    
    private lazy var avatarImageView: UIImageView = {
        let iamge = UIImage(named: "avatar")
        let avatarImage = UIImageView(image: iamge)
        return avatarImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sadny"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello!"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var squer: UIView = {
        let views = UIView()
        views.translatesAutoresizingMaskIntoConstraints = false
        views.heightAnchor.constraint(equalToConstant: 100).isActive = true
        views.layer.borderWidth = 3
        views.layer.cornerRadius = 10
        return views
    }()
    
    private lazy var squerr: UIView = {
        let views = UIView()
        views.translatesAutoresizingMaskIntoConstraints = false
        views.heightAnchor.constraint(equalToConstant: 100).isActive = true
        views.layer.borderWidth = 3
        views.layer.cornerRadius = 10
        return views
    }()
    
    private lazy var squer1: UIView = {
        let views = UIView()
        views.translatesAutoresizingMaskIntoConstraints = false
        views.heightAnchor.constraint(equalToConstant: 130).isActive = true
        views.widthAnchor.constraint(equalToConstant: 170).isActive = true
        views.layer.borderWidth = 3
        views.layer.cornerRadius = 10
        return views
    }()
    
    private lazy var squer2: UIView = {
        let views = UIView()
        views.translatesAutoresizingMaskIntoConstraints = false
        views.heightAnchor.constraint(equalToConstant: 130).isActive = true
        views.widthAnchor.constraint(equalToConstant: 170).isActive = true
        views.layer.cornerRadius = 10
        views.layer.borderWidth = 3
        return views
    }()
    
    private lazy var textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var imageRunView:UIImageView = {
        let iamge = UIImage(named: "run")
        let avatarImage = UIImageView(image: iamge)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        return avatarImage
    }()
    
    private lazy var stepps:UILabel = {
        let label = UILabel()
        label.text = "\(HealthKitManager.shared.stepsToday)"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    private lazy var km:UILabel = {
        let label = UILabel()
        label.text = "\(HealthKitManager.shared.km)"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    private lazy var buttonHistory: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See all", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self,
                         action: #selector(showPres),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //MARK: - Override func
    
    override func loadView() {
        super.loadView()
        setup()
        settext()
    }
    
    override func viewDidLoad() {
        ss.fetchSteps2()
        ss.fetchSteps3()
        ss.fetchSteps4()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        km.text = "\(health.km)"
        stepps.text = "\(health.stepsToday)"
    }
    
    //MARK: - Funcs
    
    func setup(){
        
        [avatarImageView,nameLabel,helloLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            helloLabel.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,constant: 55),
            helloLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 6),
            nameLabel.leadingAnchor.constraint(equalTo: helloLabel.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 6),
        ])
    }
    
    func settext(){
        view.addSubview(textStack)
        view.addSubview(squerr)
        textStack.distribution = .equalSpacing

        let textStep = createLabel(size: 15, weight: .bold, text: "steps")
        let textKm = createLabel(size: 15, weight: .bold, text: "m")
        let textStep1 = createLabel(size: 16, weight: .bold, text: "\(HealthKitManager.shared.stepsToday) steps")
        let textKm1 = createLabel(size: 16, weight: .bold, text: "\(HealthKitManager.shared.km) m")
        let dateLable = createLabel(size: 16, weight: .bold, text: "\(getDate())")
        let kcal = createLabel(size: 16, weight: .bold, text: "\(HealthKitManager.shared.activity) kcal")
        let history = createLabel(size: 30, weight: .bold, text: "History")
        let activitys = createLabel(size: 30, weight: .bold, text: "Activity")
        let dataToday = createLabel(size: 16, weight: .medium, text: "\(getDate())")
        let lableToday = createLabel(size: 18, weight: .bold, text: "Today")
        
        view.addSubview(history)
        view.addSubview(buttonHistory)
        view.addSubview(activitys)
        view.addSubview(squer)
        
        squer.addSubview(imageRunView)
        squer.addSubview(textStackView)
        
        textStack.addArrangedSubview(squer1)
        textStack.addArrangedSubview(squer2)
        
        textStackView.addArrangedSubview(dataToday)
        textStackView.addArrangedSubview(lableToday)
        
        
        
        squer1.addSubview(stepps)
        squer1.addSubview(textStep)
        
        squer2.addSubview(km)
        squer2.addSubview(textKm)
        
        squerr.addSubview(dateLable)
        squerr.addSubview(textKm1)
        squerr.addSubview(textStep1)
        squerr.addSubview(kcal)
        
        
        NSLayoutConstraint.activate([
            
            textStackView.centerYAnchor.constraint(equalTo: squer.centerYAnchor),
            textStackView.leadingAnchor.constraint(equalTo: imageRunView.trailingAnchor, constant: 10),
            
            imageRunView.centerYAnchor.constraint(equalTo: squer.centerYAnchor),
            imageRunView.leadingAnchor.constraint(equalTo: squer.leadingAnchor, constant: 16),
            imageRunView.widthAnchor.constraint(equalToConstant: 40),
            imageRunView.heightAnchor.constraint(equalToConstant: 40),
            
            squer.topAnchor.constraint(equalTo: activitys.bottomAnchor, constant: 14),
            squer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            squer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            textStack.topAnchor.constraint(equalTo: squer.bottomAnchor, constant: 16),
            textStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            history.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 16),
            history.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            activitys.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            activitys.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            buttonHistory.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 16),
            buttonHistory.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            stepps.topAnchor.constraint(equalTo: squer1.topAnchor, constant: 30),
            stepps.centerXAnchor.constraint(equalTo: squer1.centerXAnchor),
            textStep.topAnchor.constraint(equalTo: stepps.bottomAnchor, constant: 5),
            textStep.centerXAnchor.constraint(equalTo: squer1.centerXAnchor),
            
            km.topAnchor.constraint(equalTo: squer2.topAnchor, constant: 30),
            km.centerXAnchor.constraint(equalTo: squer2.centerXAnchor),
            textKm.topAnchor.constraint(equalTo: km.bottomAnchor, constant: 5),
            textKm.centerXAnchor.constraint(equalTo: squer2.centerXAnchor),
            
            squerr.topAnchor.constraint(equalTo: history.bottomAnchor, constant: 14),
            squerr.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            squerr.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLable.topAnchor.constraint(equalTo: squerr.topAnchor,constant: 25),
            dateLable.leadingAnchor.constraint(equalTo: squerr.leadingAnchor,constant: 16),
            
            textKm1.topAnchor.constraint(equalTo: dateLable.bottomAnchor, constant: 8),
            textKm1.leadingAnchor.constraint(equalTo: squerr.leadingAnchor,constant: 16),
            
            kcal.leadingAnchor.constraint(equalTo: textKm1.trailingAnchor,constant: 10),
            kcal.topAnchor.constraint(equalTo: dateLable.bottomAnchor, constant: 8),
            
            textStep1.trailingAnchor.constraint(equalTo: squerr.trailingAnchor,constant: -16),
            textStep1.centerYAnchor.constraint(equalTo: squerr.centerYAnchor)
        ])
        
    }
    
    private func createLabel(size: CGFloat, weight: UIFont.Weight, text: String) -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        return label
    }

    @objc func showPres(){
        let vc = TableViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}


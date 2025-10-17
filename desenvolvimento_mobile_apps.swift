// MARK: - Projeto 1: UIKit, ViewCode, XIB e Cocoapods

// --- Podfile (Exemplo de como seria) ---
// platform :ios, '14.0'
// target 'Projeto1' do
//   use_frameworks!
//   pod 'Alamofire', '~> 5.0'
// end

import UIKit
import Alamofire // Dependência do Cocoapods

// --- Tela 1: ViewCode ---

class FirstViewController: UIViewController {

    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ir para Tela 2 (XIB)", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Tela 1 (ViewCode)"
        setupViews()
    }

    func setupViews() {
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func didTapNextButton() {
        let secondVC = SecondViewController()
        navigationController?.pushViewController(secondVC, animated: true)
    }
}

// --- Tela 2: Carregando um XIB ---
// Você precisaria criar um MyCustomXIBView.xib

class MyCustomXIBView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!

    // Conecta o .swift com o .xib
    class func fromNib() -> MyCustomXIBView {
        return UINib(nibName: "MyCustomXIBView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! MyCustomXIBView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "View Carregada do XIB"
    }
}

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Tela 2 (XIB)"
        
        let customView = MyCustomXIBView.fromNib()
        customView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customView.widthAnchor.constraint(equalToConstant: 300),
            customView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Botão para a próxima tela (feito com Storyboard ou ViewCode)
        let nextButton = UIButton(type: .system, primaryAction: UIAction(title: "Ir para Tela 3 (Cocoapods)", handler: { _ in
            self.goToThirdScreen()
        }))
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: customView.bottomAnchor, constant: 20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func goToThirdScreen() {
        // Se estivesse usando Storyboard:
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // let thirdVC = storyboard.instantiateViewController(withIdentifier: "ThirdViewController")
        
        // Sem Storyboard:
        let thirdVC = ThirdViewController()
        navigationController?.pushViewController(thirdVC, animated: true)
    }
}

// --- Tela 3: Usando Cocoapods (Alamofire) ---

class ThirdViewController: UIViewController {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = .systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Tela 3 (Cocoapods)"
        
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        fetchDataWithAlamofire()
    }

    func fetchDataWithAlamofire() {
        textView.text = "Carregando dados com Alamofire..."
        
        AF.request("https://jsonplaceholder.typicode.com/todos/1").responseDecodable(of: Todo.self) { response in
            switch response.result {
            case .success(let todo):
                self.textView.text = """
                Sucesso!
                
                UserID: \(todo.userId)
                ID: \(todo.id)
                Title: \(todo.title)
                Completed: \(todo.completed)
                """
            case .failure(let error):
                self.textView.text = "Erro: \(error.localizedDescription)"
            }
        }
    }
}

// Modelo de dados usado na Tela 3 e Projeto 2
struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}


// MARK: - Projeto 2: SwiftUI, Combine e SPM

// --- Pacote SPM (Exemplo de como adicionar) ---
// Em Xcode: File > Add Packages...
// Cole a URL: https://github.com/some-spm-package (Ex: https://github.com/apple/swift-algorithms)

import SwiftUI
import Combine
// import Algorithms // Exemplo de dependência SPM

// --- ViewModel com Combine ---

class TodoViewModel: ObservableObject {
    @Published var todo: Todo?
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    func fetchData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return }
        
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Todo.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    print("Erro ao buscar dados: \(error.localizedDescription)")
                }
            }, receiveValue: { todo in
                self.todo = todo
            })
            .store(in: &cancellables)
    }
}

// --- View com SwiftUI ---

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                    Text("Carregando dados...")
                } else if let todo = viewModel.todo {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(todo.title)
                            .font(.headline)
                        Text("Status: \(todo.completed ? "Completo" : "Pendente")")
                            .font(.subheadline)
                        Text("ID do Usuário: \(todo.userId)")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                } else {
                    Text("Nenhum dado")
                }
                
                Button("Buscar Dados (Combine)") {
                    viewModel.fetchData()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Projeto 2 (SwiftUI)")
        }
    }
}


// MARK: - Projeto 3: Modulação com Cocoapods

// --- 1. Código do Módulo (Ex: MySimpleModule.swift) ---
// Este arquivo estaria dentro do seu Pod (criado com `pod lib create MySimpleModule`)

// public final class MySimpleModule {
//
//     public static func sayHello(to name: String) -> String {
//         return "Olá, \(name)! Este é o seu módulo."
//     }
//
//     public static func add(_ a: Int, _ b: Int) -> Int {
//         return a + b
//     }
// }

// --- 2. Código do App que usa o Módulo ---
// O App principal teria no seu Podfile:
// pod 'MySimpleModule', :path => '../MySimpleModule'

import SwiftUI
// import MySimpleModule // Importa o módulo criado

struct ModularAppView: View {
    
    @State private var name: String = "Usuário"
    @State private var greeting: String = ""
    @State private var sumResult: String = ""
    
    var body: some View {
        Form {
            Section("Teste do Módulo") {
                TextField("Digite seu nome", text: $name)
                
                Button("Gerar Saudação") {
                    // --- USANDO O MÓDULO ---
                    // self.greeting = MySimpleModule.sayHello(to: name)
                    
                    // (Simulação já que o módulo não existe)
                    self.greeting = "Olá, \(name)! Este é o seu módulo."
                }
                
                Text(greeting)
                    .font(.headline)
                
                Button("Calcular 5 + 3") {
                    // --- USANDO O MÓDULO ---
                    // let result = MySimpleModule.add(5, 3)
                    
                    // (Simulação)
                    let result = 5 + 3
                    self.sumResult = "O resultado é: \(result)"
                }
                
                Text(sumResult)
                    .font(.headline)
            }
        }
        .navigationTitle("Projeto 3 (Modulação)")
    }
}
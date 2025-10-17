# Desafio de Projeto: Apps Nativos iOS 📱

Este repositório contém a implementação do "Desafio de Projeto: Desenvolvimento de Apps Nativos para iOS", demonstrando o uso de diferentes frameworks, padrões de arquitetura e gerenciadores de dependência no ecossistema Apple

## Projetos 🚀

O desafio é composto por três projetos distintos, cada um focado em um conjunto específico de tecnologias

---

### 1. Projeto UIKit (ViewCode, XIB & Cocoapods)

Um aplicativo de navegação com 3 telas construído inteiramente com **UIKit**

* **Tela 1 (ViewCode):** Interface construída programaticamente usando Auto Layout (ViewCode)
* **Tela 2 (XIB):** Carrega e exibe uma `UIView` customizada projetada em um arquivo `.xib`
* **Tela 3 (Cocoapods):** Utiliza a dependência **Alamofire** (gerenciada pelo **Cocoapods**) para realizar uma requisição de rede e exibir os dados de uma API JSON

**Tecnologias:**
* Swift
* UIKit
* ViewCode (Auto Layout)
* XIB (Interface Builder)
* Cocoapods
* Alamofire

---

### 2. Projeto SwiftUI (Combine & SPM)

Um aplicativo moderno de tela única construído com **SwiftUI**

* **UI Declarativa:** A interface é totalmente construída com SwiftUI
* **Gerenciamento de Estado:** Utiliza `@StateObject` e `ObservableObject` (`TodoViewModel`) para gerenciar o estado da view
* **Programação Reativa:** Usa o framework **Combine** (`URLSession.dataTaskPublisher`) para buscar dados de uma API de forma assíncrona
* **Dependências:** Gerenciamento de dependências feito via **Swift Package Manager (SPM)**

**Tecnologias:**
* Swift
* SwiftUI
* Combine
* Swift Package Manager (SPM)

---

### 3. Projeto Modulação (Framework com Cocoapods)

Um exemplo de arquitetura modularizada

* **App Host:** Um aplicativo simples (em SwiftUI) que consome um módulo externo
* **Módulo (Framework):** Um módulo local (`MySimpleModule`) criado como um **Cocoapod** separado, contendo a lógica de negócio (ex: `sayHello`, `add`)
* **Integração:** O App Host importa o módulo e utiliza suas funções públicas, demonstrando a separação de responsabilidades

**Tecnologias:**
* Swift
* SwiftUI (para o App Host)
* Cocoapods (para criação e linkagem do módulo)
* Arquitetura Modular

## Como Executar 🛠️

Cada projeto é independente

### Pré-requisitos
* Xcode 13+
* Cocoapods instalado (`sudo gem install cocoapods`)

### Projeto 1 (UIKit)
1
Navegue até a pasta `Projeto1/`
2
Execute `pod install` no terminal para instalar o Alamofire
3
Abra o arquivo `Projeto1.xcworkspace`
4
Compile e execute (Build & Run)

### Projeto 2 (SwiftUI)
1
Navegue até a pasta `Projeto2/`
2
Abra o arquivo `Projeto2.xcodeproj`
3
O Xcode resolverá as dependências do SPM automaticamente
4
Compile e execute (Build & Run)

### Projeto 3 (Modulação)
1
Navegue até a pasta `Projeto3App/` (o app host)
2
Execute `pod install` no terminal para linkar o módulo local `MySimpleModule`
3
Abra o arquivo `Projeto3App.xcworkspace`
4
Compile e execute (Build & Run)# Desenvolva-Seu-Portf-lio-Mobile-Criando-Apps-iOS

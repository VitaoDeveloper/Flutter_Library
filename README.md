# Biblioteca Simples

Aplicativo desenvolvido em Flutter que simula um sistema básico de gerenciamento de biblioteca.
Este projeto tem como objetivo servir como base para aprendizado, explorando conceitos de desenvolvimento mobile, organização de código e boas práticas.

---

## Introdução

Este app funciona como uma plataforma simples para gerenciar uma biblioteca, permitindo:

* Cadastro de livros
* Listagem e organização de itens
* Estrutura inicial para controle de dados

O foco principal não é ser uma solução completa, mas sim um projeto didático para fins acadêmicos e de ensino.

---

## Tecnologias Utilizadas

* Flutter
* Dart
* (Opcional) Firebase ou outro backend, caso implementado

---

## Como Rodar o Projeto Localmente

### Pré-requisitos

* Flutter instalado (>= 3.x)
* Dart (>= 3.x)
* Emulador Android/iOS ou dispositivo físico

### Passos

```bash
# Clone o repositório
git clone https://github.com/VitaoDeveloper/Biblioteca_Flutter.git

# Acesse a pasta do projeto
cd Biblioteca_Flutter

# Instale as dependências
flutter pub get

# Execute o projeto
flutter run
```

---

## Estrutura do Projeto

``` bash
lib/
├── main.dart                          # Entrada mínima
├── app.dart                           # BibliotecaApp (MaterialApp)
├── controllers/
│   └── biblioteca_controller.dart     # Toda lógica de estado
└── screens/
    └── biblioteca_home/
        ├── biblioteca_home.dart       # StatefulWidget + State
        └── widgets/
            ├── main_dropdown.dart
            └── livro_list_tile.dart   # Regras de negócio / integração
```

---

## Contribuição

Mesmo sendo um projeto acadêmico, contribuições são bem-vindas!

### Como contribuir:

1. Faça um fork do projeto
2. Crie uma branch:

   ```bash
   git checkout -b minha-feature
   ```
3. Commit suas mudanças:

   ```bash
   git commit -m "feat: Nova Feature"
   ```
4. Envie para o repositório:

   ```bash
   git push origin minha-feature
   ```
5. Abra um Pull Request

### Boas práticas:

* Use nomes de variáveis claros
* Siga o padrão de organização do projeto
* Prefira commits descritivos

---

## Aviso

Este projeto **não possui licença** e foi desenvolvido **exclusivamente para fins acadêmicos e de ensino**.
Não deve ser utilizado em produção.

---

## Issue Relacionada

**Melhorar a documentação no README do projeto**

Este README foi estruturado com base na necessidade de tornar a documentação mais clara e acessível para novos desenvolvedores, incluindo:

* Melhor descrição do projeto
* Guia de execução local
* Organização do código
* Diretrizes de contribuição

---
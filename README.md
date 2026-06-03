# Biblioteca Flutter

Aplicativo mobile desenvolvido em **Flutter** para gerenciamento de uma biblioteca pessoal, permitindo organizar livros por gêneros com operações completas de CRUD.

---

## Funcionalidades

| Recurso | Descrição |
|---------|-----------|
| **Gerenciar Livros** | Adicionar, editar, excluir e buscar livros |
| **Gerenciar Gêneros** | Criar, renomear e remover categorias |
| **Busca em Tempo Real** | Filtrar livros por nome instantaneamente |
| **Design Moderno** | Interface com Material 3 e tema personalizado |
| **Sincronização com API** | Dados persistidos em backend REST |

---

## Tecnologias

- **Flutter** >= 3.x
- **Dart** >= 3.6.2
- **Dio** - Cliente HTTP para comunicação com a API
- **Material 3** - Design system moderno

---

## Como Executar

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado
- Emulador Android/iOS ou dispositivo físico conectado

### Instalação

```bash
# Clone o repositório
git clone https://github.com/VitaoDeveloper/Flutter_Library.git

# Acesse a pasta do projeto
cd Flutter_Library

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

---

## Estrutura do Projeto

```
lib/
├── main.dart                          # Ponto de entrada
├── app.dart                           # Configuração do MaterialApp
├── api/
│   └── api_client.dart                # Cliente HTTP (Dio)
├── controllers/
│   └── library_controller.dart        # Lógica de negócio e estado
├── screens/
│   └── home/
│       ├── home.dart                  # Tela principal
│       └── widgets/                   # Widgets da home
├── services/
│   └── library_service.dart           # Camada de serviço (API)
└── utils/
    ├── api/
    │   ├── api_errors.dart            # Tratamento de erros
    │   └── api_result.dart            # Wrapper de resultado
    └── widgets/
        └── app_loading.dart           # Widget de loading
```

---

## API

O app se comunica com uma API REST hospedada em:
```
https://library-api-service.vercel.app
```

Código-Fonte da API disponível no repositório GitHub:
```
https://github.com/VitaoDeveloper/Library_API_Service
```

### Endpoints

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/getall` | Buscar todos os gêneros e livros |
| `POST` | `/create/{table}` | Criar livro ou gênero |
| `PATCH` | `/edit/{table}/{id}` | Editar livro ou gênero |
| `DELETE` | `/delete/{table}/{id}` | Excluir livro ou gênero |

---

## Arquitetura

O projeto segue o padrão **MVC adaptado**:

- **Controllers** → Gerenciam estado com `ChangeNotifier`
- **Services** → Comunicação com a API
- **Screens** → Interface do usuário
- **Utils** → Helpers e utilitários

---

## Contribuir

1. Faça um fork do projeto
2. Crie uma branch (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'feat: Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request
# Rota-Oeste-FrontEnd

Este é o frontend do projeto Rota-Oeste, desenvolvido em Flutter. O projeto adota uma estrutura modular que visa facilitar a manutenção e a extensibilidade, separando responsabilidades entre diferentes camadas como controle, serviços e componentes visuais.

## Estrutura do Projeto

O projeto está organizado da seguinte forma:

- **lib/**
  - **componentes/**: Contém componentes visuais reutilizáveis, como a Sidebar.
  - **controller/**: Gerencia a lógica de navegação e coordena ações entre a interface do usuário e os serviços.
  - **service/**: Lida com requisições HTTP, como as operações de comunicação com o backend.
  - **telas/**: Contém as telas principais do aplicativo, como a tela de login.

### Estrutura de Pastas

- **service/**: Esta pasta contém os serviços que são responsáveis por enviar e receber dados do backend. Cada serviço é independente e apenas lida com a comunicação com a API.
  
- **controller/**: Esta pasta contém os controladores que se ocupam da lógica de navegação e coordenação de ações. Os controladores utilizam os serviços e coordenam o fluxo das telas, garantindo que a navegação esteja alinhada com as respostas do backend.
  
- **telas/**: Contém as interfaces visuais (telas) do aplicativo. Cada tela é responsável pela interação com o usuário e comunica-se com os controladores para realizar ações.

## Testando Sem um Backend Real

Para testar a aplicação sem um backend real, utilizamos URLs fake para simular respostas da API. Recomendamos o uso de ferramentas como [Mocky](https://mocky.io/) para criar URLs que simulem o comportamento do backend.

### Passos para Criar uma URL Fake com Mocky

1. Acesse [mocky.io](https://mocky.io/).
2. Crie uma resposta com os dados que você precisa, como um JSON simulando sucesso ou erro.
3. Utilize a URL gerada no serviço que precisa ser testado, substituindo temporariamente a URL do backend real.

**Exemplo de URL Fake no `LoginService`**:
```dart
final url = Uri.parse('https://run.mocky.io/v3/seu-endereco-unico');
```

Com isso, é possível testar as funcionalidades e fluxos do projeto sem precisar de um backend ativo, garantindo que as integrações estejam funcionando como esperado.

## Como Contribuir

Para contribuir com o projeto, siga os passos abaixo:

1. **Crie uma branch**: Baseado na branch `main`, crie uma nova branch para suas modificações. Nomeie a branch de forma que ela reflita as mudanças que você está propondo. Utilize o seguinte comando:

    ```bash
    git checkout -b nome-da-sua-branch
    ```

2. **Faça suas alterações**: Implemente as modificações propostas em sua branch. Certifique-se de seguir as diretrizes de codificação e os padrões do projeto.

3. **Commit suas mudanças**: Após realizar suas alterações, faça o commit delas. Use mensagens de commit claras e descritivas que expliquem suas alterações. Você pode fazer isso com:

    ```bash
    git add .
    git commit -m "fix: modificação em x item"
    ```
    Leia mais sobre como fazer uma mensagem de commit em: [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)

4. **Abra um Pull Request no Github**: Após subir suas alterações, abra um pull request e aguarde a revisão 🎉. Lembre-se de colocar uma mensagem na pull request e adicionar uma label para melhor identificação.

    ![image](./assets/pr.png)

## Links Úteis

### Documentações

Seguem os links de todas as documentações das tecnologias usadas nesse projeto:

- [Engenharia de Requisitos](https://pt.overleaf.com/read/frtcrbrscwgs#5915a5)
- [Modelagem de Banco de Dados](https://pt.overleaf.com/read/vdwdjvqvtwwr#5cba88)
- [WireFrame](https://miro.com/app/board/uXjVKgPil_Q=/?share_link_id=476697909317)
- [Figma](https://www.figma.com/design/nwaVccYxXjauVKnK2g10S5/Prototipagem---Desafio-da-Rota-Oeste?node-id=0-1&t=mXpimYtfWCtENctq-1)

---


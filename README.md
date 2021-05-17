# King Investor - Acompanhamento de carteira de renda variável.

Projeto produzido pelo aluno [Michel Hanzen Scheeren](https://github.com/MichelHanzenScheeren) como parte da complementação de carga horária da disciplina de Tecnologia em Desenvolvimento de Sistemas do 6º período do Curso de Ciência da Computação, da Universidade Tecnológica Federal do Paraná - UTFPR Medianeira, sob a orientação do professor [Everton Coimbra de Araújo](https://github.com/evertonfoz).

O aplicativo foi desenvolvido utilizando o Flutter (versão 2.1.0-12.2.pre - channel beta), o UI toolkit para desenvolvimento híbrido do Google. A versão do Dart utilizada foi a 2.13.0. Por fim, foi utilizada a IDE Visual Studio Code (v1.55).

## Começando
Para utilizar o aplicativo, algumas ferramentas serão necessárias:
* [SDK flutter](https://flutter.dev/docs/get-started/install): Necessário para obtenção de pacotes e compilação do código para o ambiente nativo;
* [Android Studio](https://developer.android.com/studio): Flutter depende de uma instalação completa das dependências do Androis Studio para funcionar;
* Um emulador ou dispositivo físico para executar a aplicação;
  * Se preferir um emulador, pode usar o do próprio Adroid Studio: [Android Emulator](https://developer.android.com/studio/run/emulator?hl=pt-br);
  * Se for utilizar o seu dispositivo, [esse tutorial pode ser útil](https://developer.android.com/studio/run/device?hl=pt-br).

## Executando
* [Clone o repositório](https://github.com/MichelHanzenScheeren/king_investor.git) do projeto ou [baixe o arquivo zip](https://github.com/MichelHanzenScheeren/king_investor/archive/refs/heads/master.zip);
* Abra-o projeto com o editor de código que preferir (Visual Code recomendado) ou no prompt de comandos do seu computador;
* Se ainda não tiver inicializado o emulador ou conectado seu celular (em modo de depuração) ao computador, faça isso;
* Se o visual Studio Code ou o Android Studio solicitarem permissão para baixar "arquivos faltando", permita;
* Execute a aplicação (F5 ou comando "flutter run" no prompt de comando - com o cmd aberto na pasta do projeto).

## Funcionalidades
* Gerenciamento de carteiras de ativos financeiros:
  * Permite criação e gerenciamento carteiras de ativos de renda variável;
  * Gerenciamento de ativos financeiros;
  * Acompanhamento das variações de preços dos ativos.
* Acompanhamento da evolução da carteira:
  * Consolidação de resultados gerais;
  * Consolidação por categorias (ações, FIIs...);
  * Consolidação dos ativos individualmente.
* Sugestão de rebalanceamento:
  * Baseia-se nas “notas” atribuídas aos ativos e categorias (ações, FIIS…);
  * Sugestão de ativos para compra a partir do valor desejado do aporte;
  * Controle do número de ativos e categorias sugeridos;
  * Possibilidade de aplicar o aporte a carteira.

## Arquitetura
* O projeto é dividido em 4 pastas principais (encontradas dentro da pasta "lib"):
  * Data: Gerencia a transformação de classes do domínio para dados manipuláveis pelo banco de dados e API financeira (e vice versa). Também é responsável pela comunicação efetiva com o "mundo exterior" (banco de dados, APIs...);
  * Domain: Onde se encontram as regras de negócio da aplicação (modelos e casos de uso), bem como a definição dos contratos implementados pela camada de Data;
  * Presentation: Cuida da interação com o usuário: telas, widgets, notificações...
  * Shared: Define Notifications, Contracts e classes genéricas utilizadas por diversas outras camadas da aplicação.
* Há ainda a pasta "resources", onde são definidos mocks e arquivos estáticos para simular os retornos de apis e do banco de dados, muito útil no ambiente de desenvolvimento ou para testar a aplicação.



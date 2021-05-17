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

## Executando (Ambiente local) 
* [Clone o repositório](https://github.com/MichelHanzenScheeren/king_investor.git) do projeto ou [baixe o arquivo zip](https://github.com/MichelHanzenScheeren/king_investor/archive/refs/heads/master.zip);
* Abra-o projeto com o editor de código que preferir (Visual Code recomendado) ou no prompt de comandos do seu computador;
* Se ainda não tiver inicializado o emulador ou conectado seu celular (em modo de depuração) ao computador, faça isso;
* Se o visual Studio Code ou o Android Studio solicitarem permissão para baixar "arquivos faltando", permita;
* Execute a aplicação (F5 ou comando "flutter run" no prompt de comando - com o cmd aberto na pasta do projeto).
* Neste cenário, a aplicação será executada em "ambiente de desenvolvimento", com dados simulados e estáticos que estão salvos na pasta "resources". Nesta modalidade, nenhum dado é persistido e nenhuma chamada a API é feita.
* Para executar o aplicativo em "ambiente de produção", com os dados sendo persistidos e chamadas a APIs sendo executadas, consulte o tópico a seguir.

## Executando (Ambiente real)
* 1 - Primeiro, srá preciso criar uma conta no ParseServer do Back4App.com, que foi o BaaS utilizado para persistência de dados e autenticação do usuário;
  * Vá até o site oficial do [Parse Server](<https://www.back4app.com/>) e crie uma conta.
  * Após criar sua conta, na tela seguinte que se abre, clique em "Build new app", escolha um nome qualquer para o aplicativo ("King Investor", no meu caso), e escolha a versão do Pase que será utilizada (fortemente recomendado utilizar a versão 4.2.0, para garantir que não haverão problemas de compatibilidade com o aplicativo);
  * Depois que o app for gerado, você pode apagar qualquer tabela (chamadas no Parse Server de "Class") extra gerada automaticamente pelo Parse (NÃO apague as tabelas "Role" e "User).
  * Agora, vá até a opção "Server Settings" (canto inferior esquerdo do fim da pagina de dashboard), e no Card "Core Settings" clique em "Settings". Reserve as chaves "App Id", "Parse API Address" e "Client key", pois elas serão usadas daqui a pouco.
  * Volte até "Server Settings" e agora selecione o card "Custom Parse Options". Dentro da caixa de texto, cole o json de configuração abaixo. Ele permite que o app crie seus próprios ids dos objetos, e isso vem desabilitado por padrão. Depois, salve as configurações (pode levar alguns minutos até que a configuração seja efetivamente aplicada. 
  
        {"allowCustomObjectId": true}
  * Para o correto funcionamento do aplicativo, será necessário ainda criar uma tabela chamada "Category" (exatamente desse jeito!). Depois de criar a tabela no Parse, selecione-a e clique na opção "import a file", depois "upload a file". No menu de seleção aberto, vá até a página deste projeto no seu computador e depois entre em "lib\resources\development\static", e nessa pasta selecione o arquivo "Category.json", confirme selecionando a opção "import". Aguarde alguns instantes e atualize a página. Se nada aparecer, cheque seu email para verificar qual foi o problema.
* 2 - Também é preciso criar uma conta na api financeira que foi utilizada para obter as atualizaçãos de preço.
  * Vá até o site da [API Bloomberg](<https://rapidapi.com/pt/apidojo/api/Bloomberg%20Market%20and%20Financial%20News/?endpoint=apiendpoint_fe0f5da7-39e3-4920-89f3-8be55dd83304>), clique em "preços", escolha a opção "Basic" (que é gratuita e dá direito a 500 requisições grátis por mês), e faça o login com o método de sua preferência.
  * Depois vá em "Meus aplicativos", selecione o aplicativo criado quando você se cadastrou na api (alguma coisa próxima de "default_application..."), aí em "segurança" e copie a "application key", que ela será será usada daqui a pouco.
* 3 - Por fim, será necessário criar um arquivo chamado "keys.dart" dentro da pasta "resources". Neste arquivo, preencha como no exemplo abaixo substituindo as respectivas chaves dos pontos "1" e "2" nos locais corretos:  
  
        const kBloombergKey = 'YOUR_BLOOMBERG_KEY_HERE';  
        const kAppId = 'YOUR_PARSE_APP_ID_HERE';  
        const kServerUrl = 'YOUR_SERVER_URL_HERE';  
        const kClientKey = 'YOUR_PARSE_CLIENT_KEY_HERE';  
* 4 - Por último, vá até o arquivo "main.dart", localizado dentro de "lib", e, logo no início do arquivo, altere o parâmetro passado para a função "DependenciesInjection.init" de "Environments.development" para "Environments.production". Agora, basta executar o projeto.

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



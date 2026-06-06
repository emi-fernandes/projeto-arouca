# Relatorio de Scouting - Arouca x Botafogo Sub-6

## 1. Introducao

Este trabalho teve como objetivo realizar o scout de uma partida de futsal da categoria Sub-6 com foco exclusivo na equipe Arouca, a partir da analise de video disponibilizado no YouTube. A proposta da atividade envolveu a coleta, organizacao e estruturacao de eventos da partida, a producao de um dataset pronto para analise em R, a elaboracao de estatistica descritiva, a geracao de graficos e a aplicacao de uma tecnica introdutoria de Machine Learning.

O jogo analisado foi **Botafogo x Arouca**, com scout voltado apenas para os eventos do Arouca.

## 2. Metodologia

A coleta foi realizada manualmente a partir da observacao do video da partida. Os eventos registrados buscaram seguir a padronizacao de nomenclaturas inspirada no modelo LNFStats, com foco principalmente em:

- finalizacoes;
- escanteios;
- faltas cometidas;
- identificacao dos jogadores envolvidos;
- tempo aproximado de cada lance no video.

Os dados foram organizados em dois arquivos principais:

- `eventos_arouca.csv`: base principal contendo os eventos do jogo;
- `jogadores_arouca.csv`: base auxiliar com os atletas observados e suas caracteristicas.

Posteriormente, os dados foram tratados no R para padronizacao textual, organizacao dos eventos, contagem de frequencias e construcao de visualizacoes graficas.

## 3. Estrutura dos Dados

Cada linha da base `eventos_arouca.csv` representa um evento da equipe Arouca. As principais variaveis utilizadas foram:

- periodo da partida;
- tempo do video;
- tipo de evento;
- jogador envolvido;
- resultado da finalizacao;
- pe utilizado;
- regiao da quadra;
- lado do escanteio;
- tipo de infracao.

Essa organizacao permite filtrar eventos especificos e aplicar tecnicas de analise exploratoria e modelagem.

## 4. Analise Exploratoria

### 4.1 Resumo geral

Foram registrados:

- 31 eventos no total;
- 19 finalizacoes;
- 8 escanteios;
- 4 faltas cometidas;
- 0 cartoes registrados na base.

### 4.2 Finalizacoes por resultado

Entre as 19 finalizacoes observadas:

- 9 terminaram em gol;
- 4 foram para fora;
- 3 foram defendidas;
- 3 foram interceptadas.

Esses numeros indicam um aproveitamento ofensivo relativamente alto para a amostra observada, com destaque para a quantidade de gols em relacao ao total de finalizacoes.

### 4.3 Participacao dos jogadores nas finalizacoes

Os atletas com maior numero de finalizacoes foram:

- Mateu: 8 finalizacoes;
- Josue: 6 finalizacoes;
- Ze Coutinho: 4 finalizacoes;
- Luca Gabriel: 1 finalizacao.

Em gols marcados, os destaques foram:

- Josue: 3 gols;
- Mateu: 3 gols;
- Ze Coutinho: 2 gols;
- Luca Gabriel: 1 gol.

Esses dados mostram concentracao ofensiva principalmente em Mateu e Josue, tanto no volume de chutes quanto na conversao em gols.

### 4.4 Aproveitamento por jogador

Considerando a proporcao entre gols e finalizacoes:

- Mateu apresentou taxa de gol de 37,5%;
- Josue apresentou taxa de gol de 50,0%;
- Ze Coutinho apresentou taxa de gol de 50,0%;
- Luca Gabriel apresentou 100,0%, embora com apenas uma observacao.

Como a base e pequena, esses percentuais devem ser interpretados com cautela.

### 4.5 Escanteios

Os escanteios ficaram igualmente distribuidos:

- 4 pelo lado direito;
- 4 pelo lado esquerdo.

Isso sugere equilibrio espacial nas coberturas de linha de fundo e nas situacoes de bola parada ofensiva.

### 4.6 Faltas cometidas

Foram observadas 4 faltas cometidas:

- Mateu: 3 faltas;
- Joaquim: 1 falta.

Na amostra coletada, Mateu aparece como o jogador com maior participacao defensiva mais agressiva ou mais exposta a contatos faltosos.

### 4.7 Distribuicao por periodo

No primeiro tempo foram observados:

- 10 finalizacoes;
- 5 escanteios;
- 3 faltas cometidas.

No segundo tempo foram observados:

- 9 finalizacoes;
- 3 escanteios;
- 1 falta cometida.

Isso mostra uma producao ofensiva relativamente equilibrada entre os tempos, com maior numero de escanteios e faltas no primeiro tempo.

## 5. Graficos Produzidos

Foram gerados os seguintes graficos para apoio ao relatorio:

- `finalizacoes_por_resultado.png`;
- `finalizacoes_por_jogador.png`;
- `gols_por_jogador.png`;
- `finalizacoes_por_regiao.png`;
- `escanteios_por_lado.png`;
- `faltas_por_jogador.png`.

Esses graficos permitem visualizar de forma objetiva o perfil ofensivo e disciplinar da equipe analisada.

## 6. Aplicacao de Machine Learning

Como a base de dados e pequena, a etapa de Machine Learning foi tratada como **exploratoria**. O objetivo foi prever se uma finalizacao resultaria em `gol` ou `nao_gol`, utilizando como variaveis explicativas:

- jogador;
- pe da finalizacao;
- regiao da quadra;
- periodo da partida.

Foram testadas duas abordagens:

- regressao logistica;
- arvore de decisao.

### 6.1 Regressao logistica

A regressao logistica apresentou acuracia de 100% na propria base de treino. No entanto, esse resultado nao deve ser interpretado como prova de generalizacao, pois a quantidade de observacoes e muito reduzida e ha forte possibilidade de sobreajuste.

### 6.2 Arvore de decisao

A arvore de decisao nao encontrou divisao util com a base disponivel e permaneceu apenas no no raiz. Na pratica, isso indica que o conjunto de dados e pequeno demais para que o modelo encontre regras robustas de separacao.

### 6.3 Interpretacao

A etapa de ML cumpre o objetivo pedagogico de aplicar um algoritmo pertinente, mas os resultados devem ser apresentados como uma demonstracao introdutoria, e nao como um modelo preditivo consolidado.

## 7. Limitacoes

Algumas limitacoes do trabalho devem ser registradas:

- a base contem apenas uma partida;
- o numero de observacoes e pequeno;
- algumas informacoes mais detalhadas, como regiao da baliza, nao estavam completamente disponiveis no scout inicial;
- variaveis como posicao aproximada e pe dominante foram tratadas de forma simplificada.

Essas limitacoes nao invalidam o trabalho, mas ajudam a contextualizar o alcance dos resultados.

## 8. Conclusao

O scout do Arouca na partida contra o Botafogo permitiu transformar observacoes de video em uma base estruturada e adequada para analise em R. A equipe apresentou 19 finalizacoes, com 9 gols registrados, e teve participacao ofensiva concentrada principalmente em Mateu e Josue. Alem disso, os dados possibilitaram gerar estatisticas descritivas, visualizacoes graficas e uma aplicacao exploratoria de Machine Learning.

Como continuidade futura, seria interessante ampliar a base para varias partidas, registrar mais variaveis espaciais e detalhar ainda mais os eventos tecnicos. Isso permitiria analises mais robustas e modelos preditivos com maior confiabilidade.

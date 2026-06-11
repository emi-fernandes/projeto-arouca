# Relatório de Scouting - Arouca x Botafogo Sub-6
## 1. Introdução
Este trabalho teve como objetivo realizar o scout de uma partida de futsal da categoria Sub-6 com foco exclusivo na equipe Arouca, a partir da análise de vídeo disponibilizado no YouTube. A proposta da atividade envolveu a coleta, organização e estruturação de eventos da partida, a produção de um dataset pronto para análise em R, a elaboração de estatística descritiva, a geração de gráficos e a aplicação de uma técnica introdutória de Machine Learning.
O jogo analisado foi **Botafogo x Arouca**, com scout voltado apenas para os eventos do Arouca.
## 2. Metodologia
A coleta foi realizada manualmente a partir da observação do vídeo da partida. Os eventos registrados buscaram seguir a padronização de nomenclaturas inspirada no modelo LNFStats, com foco principalmente em:
- finalizações;
- escanteios;
- faltas cometidas;
- identificação dos jogadores envolvidos;
- tempo aproximado de cada lance no vídeo.

Os dados foram organizados em dois arquivos principais:
- `eventos_arouca.csv`: base principal contendo os eventos do jogo;
- `jogadores_arouca.csv`: base auxiliar com os atletas observados e suas características.

Posteriormente, os dados foram tratados no R para padronização textual, organização dos eventos, contagem de frequências e construção de visualizações gráficas.
## 3. Estrutura dos Dados
Cada linha da base `eventos_arouca.csv` representa um evento da equipe Arouca. As principais variáveis utilizadas foram:
- período da partida;
- tempo do vídeo;
- tipo de evento;
- jogador envolvido;
- resultado da finalização;
- pé utilizado;
- região da quadra;
- lado do escanteio;
- tipo de infração.

Essa organização permite filtrar eventos específicos e aplicar técnicas de análise exploratória e modelagem.
## 4. Análise Exploratória
### 4.1 Resumo geral
Foram registrados:
- 31 eventos no total;
- 19 finalizações;
- 8 escanteios;
- 4 faltas cometidas;
- 0 cartões registrados na base.
### 4.2 Finalizações por resultado
Entre as 19 finalizações observadas:
- 9 terminaram em gol;
- 4 foram para fora;
- 3 foram defendidas;
- 3 foram interceptadas.

Esses números indicam um aproveitamento ofensivo relativamente alto para a amostra observada, com destaque para a quantidade de gols em relação ao total de finalizações.
### 4.3 Participação dos jogadores nas finalizações
Os atletas com maior número de finalizações foram:
- Matteo: 8 finalizações;
- Josué: 6 finalizações;
- Zé Coutinho: 4 finalizações;
- Luca Gabriel: 1 finalização.

Em gols marcados, os destaques foram:
- Josué: 3 gols;
- Matteo: 3 gols;
- Zé Coutinho: 2 gols;
- Luca Gabriel: 1 gol.

Esses dados mostram concentração ofensiva principalmente em Matteo e Josué, tanto no volume de chutes quanto na conversão em gols.
### 4.4 Aproveitamento por jogador
Considerando a proporção entre gols e finalizações:
- Matteo apresentou taxa de gol de 37,5%;
- Josué apresentou taxa de gol de 50,0%;
- Zé Coutinho apresentou taxa de gol de 50,0%;
- Luca Gabriel apresentou 100,0%, embora com apenas uma observação.

Como a base é pequena, esses percentuais devem ser interpretados com cautela.
### 4.5 Escanteios
Os escanteios ficaram igualmente distribuídos:
- 4 pelo lado direito;
- 4 pelo lado esquerdo.

Isso sugere equilíbrio espacial nas coberturas de linha de fundo e nas situações de bola parada ofensiva.
### 4.6 Faltas cometidas
Foram observadas 4 faltas cometidas:
- Matteo: 3 faltas;
- Joaquim: 1 falta.

Na amostra coletada, Matteo aparece como o jogador com maior participação defensiva mais agressiva ou mais exposta a contatos faltosos.
### 4.7 Distribuição por período
No primeiro tempo foram observados:
- 10 finalizações;
- 5 escanteios;
- 3 faltas cometidas.

No segundo tempo foram observados:
- 9 finalizações;
- 3 escanteios;
- 1 falta cometida.

Isso mostra uma produção ofensiva relativamente equilibrada entre os tempos, com maior número de escanteios e faltas no primeiro tempo.
## 5. Gráficos Produzidos
Foram gerados os seguintes gráficos para apoio ao relatório:
- `finalizacoes_por_resultado.png`;
- `finalizacoes_por_jogador.png`;
- `gols_por_jogador.png`;
- `finalizacoes_por_regiao.png`;
- `escanteios_por_lado.png`;
- `faltas_por_jogador.png`.

Esses gráficos permitem visualizar de forma objetiva o perfil ofensivo e disciplinar da equipe analisada.
## 6. Aplicação de Machine Learning
Como a base de dados é pequena, a etapa de Machine Learning foi tratada como **exploratória**. O objetivo foi prever se uma finalização resultaria em `gol` ou `nao_gol`, utilizando como variáveis explicativas:
- jogador;
- pé da finalização;
- região da quadra;
- período da partida.

Foram testadas duas abordagens:
- regressão logística;
- árvore de decisão.
### 6.1 Regressão logística
A regressão logística apresentou acurácia de 100% na própria base de treino. No entanto, esse resultado não deve ser interpretado como prova de generalização, pois a quantidade de observações é muito reduzida e há forte possibilidade de sobreajuste.
### 6.2 Árvore de decisão
A árvore de decisão não encontrou divisão útil com a base disponível e permaneceu apenas no nó raiz. Na prática, isso indica que o conjunto de dados é pequeno demais para que o modelo encontre regras robustas de separação.
### 6.3 Interpretação
A etapa de ML cumpre o objetivo pedagógico de aplicar um algoritmo pertinente, mas os resultados devem ser apresentados como uma demonstração introdutória, e não como um modelo preditivo consolidado.
## 7. Limitações
Algumas limitações do trabalho devem ser registradas:
- a base contém apenas uma partida;
- o número de observações é pequeno;
- algumas informações mais detalhadas, como região da baliza, não estavam completamente disponíveis no scout inicial;
- variáveis como posição aproximada e pé dominante foram tratadas de forma simplificada.

Essas limitações não invalidam o trabalho, mas ajudam a contextualizar o alcance dos resultados.
## 8. Conclusão
O scout do Arouca na partida contra o Botafogo permitiu transformar observações de vídeo em uma base estruturada e adequada para análise em R. A equipe apresentou 19 finalizações, com 9 gols registrados, e teve participação ofensiva concentrada principalmente em Matteo e Josué. Além disso, os dados possibilitaram gerar estatísticas descritivas, visualizações gráficas e uma aplicação exploratória de Machine Learning.
Como continuidade futura, seria interessante ampliar a base para várias partidas, registrar mais variáveis espaciais e detalhar ainda mais os eventos técnicos. Isso permitiria análises mais robustas e modelos preditivos com maior confiabilidade.

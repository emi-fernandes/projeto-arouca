# Dicionario de Dados - Scout Arouca Sub-6

## Arquivo `eventos_arouca.csv`

- `id_evento`: identificador numerico unico do evento.
- `equipe`: nome da equipe analisada.
- `periodo`: periodo da partida. Valores esperados: `primeiro_tempo`, `segundo_tempo`.
- `tempo_video`: tempo aproximado no video.
- `tempo_segundos`: tempo do video convertido para segundos.
- `tipo_evento`: tipo do evento. Valores esperados: `finalizacao`, `escanteio`, `falta_cometida`, `penalti_cometido`, `cartao`.
- `jogador`: atleta principal envolvido no evento.
- `descricao_evento`: descricao textual resumida do lance.
- `resultado_finalizacao`: resultado da finalizacao. Valores esperados: `gol`, `fora`, `interceptado`, `trave`, `defendido`.
- `pe_finalizacao`: pe usado na finalizacao. Valores esperados: `direito`, `esquerdo`, `ambidestro`, `desconhecido`.
- `regiao_quadra`: regiao aproximada da quadra em que ocorreu a acao.
- `regiao_baliza`: quadrante aproximado da baliza. Pode ficar vazio quando nao identificavel.
- `lado_escanteio`: lado da cobranca do escanteio. Valores esperados: `direito`, `esquerdo`.
- `tipo_infracao`: tipo de infracao. Valores esperados: `falta`, `penalti`.
- `jogador_adversario_sofreu`: nome do adversario que sofreu a infracao.
- `tipo_cartao`: tipo do cartao. Valores esperados: `amarelo`, `vermelho`.
- `motivo_cartao`: motivo observado para o cartao.

## Arquivo `jogadores_arouca.csv`

- `equipe`: nome da equipe analisada.
- `jogador`: nome do atleta.
- `posicao_aproximada`: posicao aproximada no futsal. Valores esperados: `goleiro`, `fixo`, `ala`, `pivo`.
- `pe_dominante`: pe dominante do atleta. Valores esperados: `direito`, `esquerdo`, `ambidestro`, `desconhecido`.

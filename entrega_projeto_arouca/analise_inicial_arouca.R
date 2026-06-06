suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(ggplot2)
})

# Ajusta o diretório de trabalho para a pasta do script quando rodado no RStudio.
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  script_path <- rstudioapi::getSourceEditorContext()$path
  if (nzchar(script_path)) {
    setwd(dirname(script_path))
  }
}

dir.create("graficos", showWarnings = FALSE)

eventos <- read_csv(
  "eventos_arouca.csv",
  col_types = cols(
    id_evento = col_integer(),
    equipe = col_character(),
    periodo = col_character(),
    tempo_video = col_character(),
    tempo_segundos = col_double(),
    tipo_evento = col_character(),
    jogador = col_character(),
    descricao_evento = col_character(),
    resultado_finalizacao = col_character(),
    pe_finalizacao = col_character(),
    regiao_quadra = col_character(),
    regiao_baliza = col_character(),
    lado_escanteio = col_character(),
    tipo_infracao = col_character(),
    jogador_adversario_sofreu = col_character(),
    tipo_cartao = col_character(),
    motivo_cartao = col_character()
  ),
  show_col_types = FALSE
)

jogadores <- read_csv(
  "jogadores_arouca.csv",
  col_types = cols(
    equipe = col_character(),
    jogador = col_character(),
    posicao_aproximada = col_character(),
    pe_dominante = col_character()
  ),
  show_col_types = FALSE
)

# Padronizacao basica para evitar inconsistencias em texto.
eventos <- eventos %>%
  mutate(
    across(where(is.character), ~trimws(.x)),
    tipo_evento = tolower(tipo_evento),
    periodo = tolower(periodo),
    resultado_finalizacao = tolower(resultado_finalizacao),
    pe_finalizacao = tolower(pe_finalizacao),
    regiao_quadra = tolower(regiao_quadra),
    lado_escanteio = tolower(lado_escanteio),
    tipo_infracao = tolower(tipo_infracao),
    tipo_cartao = tolower(tipo_cartao)
  )

jogadores <- jogadores %>%
  mutate(
    across(where(is.character), ~trimws(.x)),
    posicao_aproximada = tolower(posicao_aproximada),
    pe_dominante = tolower(pe_dominante)
  )

finalizacoes <- eventos %>%
  filter(tipo_evento == "finalizacao")

escanteios <- eventos %>%
  filter(tipo_evento == "escanteio")

faltas <- eventos %>%
  filter(tipo_evento == "falta_cometida")

cartoes <- eventos %>%
  filter(tipo_evento == "cartao")

cat("\n===== DIMENSOES DOS DADOS =====\n")
cat("Eventos:", nrow(eventos), "linhas e", ncol(eventos), "colunas\n")
cat("Jogadores:", nrow(jogadores), "linhas e", ncol(jogadores), "colunas\n")

cat("\n===== RESUMO GERAL =====\n")
cat("Total de finalizacoes:", nrow(finalizacoes), "\n")
cat("Total de escanteios:", nrow(escanteios), "\n")
cat("Total de faltas cometidas:", nrow(faltas), "\n")
cat("Total de cartoes:", nrow(cartoes), "\n")

resumo_finalizacoes <- finalizacoes %>%
  count(resultado_finalizacao, name = "quantidade") %>%
  arrange(desc(quantidade))

cat("\n===== FINALIZACOES POR RESULTADO =====\n")
print(resumo_finalizacoes)

finalizacoes_por_jogador <- finalizacoes %>%
  count(jogador, name = "total_finalizacoes") %>%
  arrange(desc(total_finalizacoes))

cat("\n===== FINALIZACOES POR JOGADOR =====\n")
print(finalizacoes_por_jogador)

gols_por_jogador <- finalizacoes %>%
  filter(resultado_finalizacao == "gol") %>%
  count(jogador, name = "gols") %>%
  arrange(desc(gols))

cat("\n===== GOLS POR JOGADOR =====\n")
print(gols_por_jogador)

aproveitamento_jogador <- finalizacoes %>%
  group_by(jogador) %>%
  summarise(
    finalizacoes = n(),
    gols = sum(resultado_finalizacao == "gol", na.rm = TRUE),
    chutes_no_gol = sum(resultado_finalizacao %in% c("gol", "defendido"), na.rm = TRUE),
    taxa_gol = round(100 * gols / finalizacoes, 1),
    taxa_no_gol = round(100 * chutes_no_gol / finalizacoes, 1),
    .groups = "drop"
  ) %>%
  arrange(desc(gols), desc(finalizacoes))

cat("\n===== APROVEITAMENTO POR JOGADOR =====\n")
print(aproveitamento_jogador)

resumo_escanteios <- escanteios %>%
  count(lado_escanteio, name = "quantidade") %>%
  arrange(desc(quantidade))

cat("\n===== ESCANTEIOS POR LADO =====\n")
print(resumo_escanteios)

resumo_faltas <- faltas %>%
  count(jogador, name = "faltas_cometidas") %>%
  arrange(desc(faltas_cometidas))

cat("\n===== FALTAS COMETIDAS POR JOGADOR =====\n")
print(resumo_faltas)

eventos_por_periodo <- eventos %>%
  count(periodo, tipo_evento, name = "quantidade") %>%
  arrange(periodo, desc(quantidade))

cat("\n===== EVENTOS POR PERIODO =====\n")
print(eventos_por_periodo)

write_csv(resumo_finalizacoes, "resumo_finalizacoes.csv")
write_csv(finalizacoes_por_jogador, "finalizacoes_por_jogador.csv")
write_csv(gols_por_jogador, "gols_por_jogador.csv")
write_csv(aproveitamento_jogador, "aproveitamento_por_jogador.csv")
write_csv(resumo_escanteios, "resumo_escanteios.csv")
write_csv(resumo_faltas, "resumo_faltas.csv")
write_csv(eventos_por_periodo, "eventos_por_periodo.csv")

grafico_resultado <- ggplot(resumo_finalizacoes, aes(x = reorder(resultado_finalizacao, quantidade), y = quantidade, fill = resultado_finalizacao)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Finalizacoes do Arouca por resultado",
    x = "Resultado da finalizacao",
    y = "Quantidade"
  ) +
  theme_minimal(base_size = 12)

print(grafico_resultado)
ggsave("graficos/finalizacoes_por_resultado.png", grafico_resultado, width = 8, height = 5, dpi = 300)

grafico_finalizacoes_jogador <- ggplot(finalizacoes_por_jogador, aes(x = reorder(jogador, total_finalizacoes), y = total_finalizacoes, fill = jogador)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Finalizacoes por jogador",
    x = "Jogador",
    y = "Quantidade"
  ) +
  theme_minimal(base_size = 12)

print(grafico_finalizacoes_jogador)
ggsave("graficos/finalizacoes_por_jogador.png", grafico_finalizacoes_jogador, width = 8, height = 5, dpi = 300)

grafico_gols_jogador <- ggplot(gols_por_jogador, aes(x = reorder(jogador, gols), y = gols, fill = jogador)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Gols por jogador",
    x = "Jogador",
    y = "Gols"
  ) +
  theme_minimal(base_size = 12)

print(grafico_gols_jogador)
ggsave("graficos/gols_por_jogador.png", grafico_gols_jogador, width = 8, height = 5, dpi = 300)

grafico_regiao <- finalizacoes %>%
  count(regiao_quadra, name = "quantidade") %>%
  ggplot(aes(x = reorder(regiao_quadra, quantidade), y = quantidade, fill = regiao_quadra)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Finalizacoes por regiao da quadra",
    x = "Regiao da quadra",
    y = "Quantidade"
  ) +
  theme_minimal(base_size = 12)

print(grafico_regiao)
ggsave("graficos/finalizacoes_por_regiao.png", grafico_regiao, width = 8, height = 5, dpi = 300)

grafico_escanteios <- ggplot(resumo_escanteios, aes(x = lado_escanteio, y = quantidade, fill = lado_escanteio)) +
  geom_col(show.legend = FALSE) +
  labs(
    title = "Escanteios por lado",
    x = "Lado da cobranca",
    y = "Quantidade"
  ) +
  theme_minimal(base_size = 12)

print(grafico_escanteios)
ggsave("graficos/escanteios_por_lado.png", grafico_escanteios, width = 7, height = 5, dpi = 300)

grafico_faltas <- ggplot(resumo_faltas, aes(x = reorder(jogador, faltas_cometidas), y = faltas_cometidas, fill = jogador)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Faltas cometidas por jogador",
    x = "Jogador",
    y = "Quantidade"
  ) +
  theme_minimal(base_size = 12)

print(grafico_faltas)
ggsave("graficos/faltas_por_jogador.png", grafico_faltas, width = 8, height = 5, dpi = 300)

cat("\nArquivos gerados com sucesso:\n")
cat("- resumo_finalizacoes.csv\n")
cat("- finalizacoes_por_jogador.csv\n")
cat("- gols_por_jogador.csv\n")
cat("- aproveitamento_por_jogador.csv\n")
cat("- resumo_escanteios.csv\n")
cat("- resumo_faltas.csv\n")
cat("- eventos_por_periodo.csv\n")
cat("- pasta graficos/ com os PNGs\n")

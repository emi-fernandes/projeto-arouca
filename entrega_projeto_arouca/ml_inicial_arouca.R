suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
})

# Ajusta o diretório de trabalho para a pasta do script quando rodado no RStudio.
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  script_path <- rstudioapi::getSourceEditorContext()$path
  if (nzchar(script_path)) {
    setwd(dirname(script_path))
  }
}

dir.create("modelos", showWarnings = FALSE)
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

finalizacoes_ml <- eventos %>%
  filter(tipo_evento == "finalizacao") %>%
  mutate(
    across(where(is.character), ~trimws(tolower(.x))),
    eh_gol = if_else(resultado_finalizacao == "gol", 1, 0),
    jogador = factor(jogador),
    pe_finalizacao = factor(pe_finalizacao),
    regiao_quadra = factor(regiao_quadra),
    periodo = factor(periodo)
  )

cat("\n===== BASE DE ML =====\n")
cat("Total de observacoes:", nrow(finalizacoes_ml), "\n")
cat("Gols:", sum(finalizacoes_ml$eh_gol), "\n")
cat("Nao gols:", sum(finalizacoes_ml$eh_gol == 0), "\n")

if (nrow(finalizacoes_ml) < 10) {
  stop("Base muito pequena para a modelagem proposta.")
}

# Regressao logistica simples para estimar probabilidade de gol.
modelo_logistico <- suppressWarnings(
  glm(
    eh_gol ~ jogador + pe_finalizacao + regiao_quadra + periodo,
    data = finalizacoes_ml,
    family = binomial()
  )
)

finalizacoes_ml <- finalizacoes_ml %>%
  mutate(
    prob_gol_logistico = predict(modelo_logistico, type = "response"),
    previsao_logistica = if_else(prob_gol_logistico >= 0.5, 1, 0)
  )

acuracia_logistica <- mean(finalizacoes_ml$previsao_logistica == finalizacoes_ml$eh_gol)

matriz_logistica <- table(
  Real = finalizacoes_ml$eh_gol,
  Previsto = finalizacoes_ml$previsao_logistica
)

coeficientes_logisticos <- summary(modelo_logistico)$coefficients %>%
  as.data.frame() %>%
  tibble::rownames_to_column("variavel")

write_csv(finalizacoes_ml, "modelos/predicoes_finalizacoes.csv")
write_csv(coeficientes_logisticos, "modelos/coeficientes_logisticos.csv")

capture.output(summary(modelo_logistico), file = "modelos/resumo_modelo_logistico.txt")
capture.output(matriz_logistica, file = "modelos/matriz_confusao_logistica.txt")

cat("\n===== REGRESSAO LOGISTICA =====\n")
cat("Acuracia na propria base:", round(acuracia_logistica * 100, 1), "%\n")
print(matriz_logistica)

# Arvore de decisao como modelo interpretavel.
if (requireNamespace("rpart", quietly = TRUE)) {
  modelo_arvore <- rpart::rpart(
    eh_gol ~ jogador + pe_finalizacao + regiao_quadra + periodo,
    data = finalizacoes_ml,
    method = "class"
  )

  prob_arvore <- predict(modelo_arvore, type = "prob")[, "1"]
  previsao_arvore <- ifelse(prob_arvore >= 0.5, 1, 0)
  acuracia_arvore <- mean(previsao_arvore == finalizacoes_ml$eh_gol)

  matriz_arvore <- table(
    Real = finalizacoes_ml$eh_gol,
    Previsto = previsao_arvore
  )

  importancia_arvore <- modelo_arvore$variable.importance
  if (is.null(importancia_arvore)) {
    importancia_df <- data.frame(variavel = character(), importancia = numeric())
  } else {
    importancia_df <- data.frame(
      variavel = names(importancia_arvore),
      importancia = as.numeric(importancia_arvore)
    ) %>%
      arrange(desc(importancia))
  }

  write_csv(importancia_df, "modelos/importancia_arvore.csv")
  capture.output(summary(modelo_arvore), file = "modelos/resumo_modelo_arvore.txt")
  capture.output(matriz_arvore, file = "modelos/matriz_confusao_arvore.txt")

  if (nrow(modelo_arvore$frame) > 1) {
    png("graficos/arvore_decisao_finalizacoes.png", width = 1200, height = 900, res = 150)
    plot(modelo_arvore, uniform = TRUE, margin = 0.1)
    text(modelo_arvore, use.n = TRUE, cex = 0.9)
    dev.off()
  } else {
    cat("\nA arvore de decisao nao encontrou divisao util e permaneceu apenas no no raiz.\n")
  }

  cat("\n===== ARVORE DE DECISAO =====\n")
  cat("Acuracia na propria base:", round(acuracia_arvore * 100, 1), "%\n")
  print(matriz_arvore)
} else {
  cat("\nPacote 'rpart' nao encontrado. A parte de arvore de decisao foi pulada.\n")
}

cat("\nArquivos de ML gerados com sucesso:\n")
cat("- modelos/predicoes_finalizacoes.csv\n")
cat("- modelos/coeficientes_logisticos.csv\n")
cat("- modelos/resumo_modelo_logistico.txt\n")
cat("- modelos/matriz_confusao_logistica.txt\n")
cat("- modelos/importancia_arvore.csv (se rpart estiver disponivel)\n")
cat("- modelos/resumo_modelo_arvore.txt (se rpart estiver disponivel)\n")
cat("- modelos/matriz_confusao_arvore.txt (se rpart estiver disponivel)\n")
cat("- graficos/arvore_decisao_finalizacoes.png (se rpart estiver disponivel)\n")
cat("\nObservacao: como a base tem poucas observacoes, os resultados devem ser tratados como exploratorios.\n")

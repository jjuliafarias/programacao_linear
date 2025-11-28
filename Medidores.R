#-----------------------------------------------------------------------
# Modelagem e Otimizacao de Sistemas Produtivos
# Prof. Guilherme Cassel
# Problema: Calibracao de Medidores
# Tipo: Programacao Inteira
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Modelagem do problema
#-----------------------------------------------------------------------
# Variáveis de decisão
# Xi: quantidade calibrada do medidor i
# i ∈ {1, 2, 3, 4, 5}
#
# i=1 → G25
# i=2 → G65
# i=3 → G100
# i=4 → G160 Rotativo
# i=5 → G160 Turbina
#
# Funcao objetivo (maximizar lucro total)
# MAX: 300X1 + 400X2 + 400X3 + 3000X4 + 3500X5
#
# Restricoes:
# 1X1 + 1.5X2 + 5X3 + 5X4 + 1.5X5 <= 80 [horas/2 operadores]
# X1                              <= 12 [demanda]
#          X2                     <= 8  [demanda]
#                X3               <= 5  [demanda]
#                      X4         <= 14 [demanda]
#                              X5 <= 1  [demanda]
#
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Implementacao do modelo
#-----------------------------------------------------------------------
library(lpSolve)

# Funcao objetivo (lucro)
funcao_objetivo = c(300, 
                    400, 
                    400, 
                    3000, 
                    3500)

# Matriz de restricoes
restricoes = matrix(c(  1,1.5,  5,   5, 1.5,
                        1,  0,  0,   0,   0,      # X1 
                        0,  1,  0,   0,   0,      # X2 
                        0,  0,  1,   0,   0,      # X3 
                        0,  0,  0,   1,   0,      # X4 
                        0,  0,  0,   0,   1       # X5 
                      ), ncol = 5, byrow = TRUE)

restricoes_dir = c("<=",
                   "<=",
                   "<=",
                   "<=", 
                   "<=",
                   "<=")

restricoes_rhs = c(110,
                   12,
                   8,
                   5,
                   14,
                   1)

# Rodando o modelo
res_modelo = lp(
  "max",                 # maximizar funcao objetivo
  funcao_objetivo,       # funcao objetivo
  restricoes,            # matriz de restricoes (lhs)
  restricoes_dir,        # sinais
  restricoes_rhs,        # rhs
  all.int = TRUE,        # variaveis inteiras
  compute.sens = TRUE    # sensibilidade
)

#-----------------------------------------------------------------------
# Resultados
#-----------------------------------------------------------------------
res_modelo                             # lucro máximo
res_modelo$solution                    # quantos medidores calibrar
res_modelo$sens.coef.from              # valores min dos parametros
res_modelo$sens.coef.to                # valores max dos parametros
res_modelo$duals                       # preco sombra
res_modelo$duals.from
res_modelo$duals.to
#-----------------------------------------------------------------------

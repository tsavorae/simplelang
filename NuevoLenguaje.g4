grammar NuevoLenguaje;

program
    : expr EOF
    ;

expr
    : 'RETORNA' IDENTIFICADOR                                 # Retorno
    | IDENTIFICADOR '=' expr                         # Asignacion
    | funcionLlamada                                 # FuncionExpr
    | expr '+' expr                                  # Suma
    | expr '-' expr                                  # Resta
    | expr '*' expr                                  # Multiplicacion
    | expr '/' expr                                  # Division
    | expr 'ES IGUAL A' expr                         # Igual
    | expr 'ES MAYOR QUE' expr                       # MayorQue
    | expr 'ES MENOR QUE' expr                       # MenorQue
    | 'SI' expr 'ENTONCES' expr 'SINO' expr          # SiCondicional
    | 'BUSCAR' STRING 'EN' IDENTIFICADOR             # Buscar
    | 'FILTRAR' '(' IDENTIFICADOR ',' expr ')'       # Filtrar
    | 'DIAS_ENTRE' '(' expr ',' expr ')'             # DiasEntre
    | 'CONTAR_SI' IDENTIFICADOR 'CON' expr           # ContarSi
    | 'TABLA_DINAMICA' IDENTIFICADOR 'POR' IDENTIFICADOR 'SUMA' IDENTIFICADOR  # TablaDinamica
    | 'VARIANZA' '(' expr (',' expr)* ')'            # FuncionVarianza
    | 'DESVEST' '(' expr (',' expr)* ')'             # FuncionDesvest
    | 'MATRIZ_MULT' '(' expr ',' expr ')'            # MatrizMultiplicacion
    | 'TRANSPONER' '(' expr ')'                     # FuncionTransponer
    | 'SI.ERROR' '(' expr ',' expr ')'               # FuncionSiError
    | 'LARGO' '(' IDENTIFICADOR ')'                  # FuncionLargo
    | 'ORDENAR' '(' IDENTIFICADOR ')'                # FuncionOrdenar
    | 'RANGO' '(' expr ',' expr ',' expr ')'         # FuncionRangoConPaso
    | 'APLICAR' '(' IDENTIFICADOR ',' IDENTIFICADOR ')' # FuncionAplicar
    | 'REDUCIR' '(' IDENTIFICADOR ',' IDENTIFICADOR ')' # FuncionReducir
    | 'MOSTRAR' '(' expr ')'                         # FuncionMostrar
    | 'DEFINIR' IDENTIFICADOR '(' IDENTIFICADOR* ')' 'COMO' bloque  # DefinirFuncion
    | 'PEDIR' '(' STRING ')'                         # FuncionPedir
    | 'JUNTAR' '(' IDENTIFICADOR ',' IDENTIFICADOR ')' # FuncionJuntar
    | 'ENUMERAR' '(' IDENTIFICADOR ')'               # FuncionEnumerar
    | 'MIENTRAS' expr 'HACER' bloque                 # MientrasLoop
    | 'PARA' IDENTIFICADOR 'DESDE' expr 'HASTA' expr 'PASO' expr 'HACER' bloque # ParaLoopConPaso
    | 'TAMANIO' '(' IDENTIFICADOR ')'                # FuncionTamanio
    | 'VECTOR' '(' expr ')'                          # FuncionVector
    | 'PUSH' '(' IDENTIFICADOR ',' expr ')'          # FuncionPush
    | 'POP' '(' IDENTIFICADOR ')'                    # FuncionPop
    | 'POTENCIA' '(' expr ',' expr ')'               # FuncionPotencia
    | 'RAIZ' '(' expr ')'                            # FuncionRaiz
    | NUMERO                                         # Numero
    ;

bloque
    : '{' (expr)* '}'                                # BloqueInstrucciones
    ;

funcionLlamada
    : 'SUMA' '(' expr (',' expr)* ')'                # FuncionSuma
    | 'PROMEDIO' '(' expr (',' expr)* ')'            # FuncionPromedio
    | 'MINIMO' '(' expr (',' expr)* ')'              # FuncionMinimo
    | 'MAXIMO' '(' expr (',' expr)* ')'              # FuncionMaximo
    ;

// Reglas léxicas
NUMERO : [0-9]+ ;

IDENTIFICADOR : [a-zA-Z]+ ;

STRING : '\'' (~[\r\n'] | '\\\'')* '\'';

ESPACIOS : [ \t\r\n]+ -> skip ;

COMENTARIO_LINEA : '//' .*? '\n' -> skip ;

COMENTARIO_BLOQUE : '/*' .*? '*/' -> skip ;

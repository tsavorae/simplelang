grammar NuevoLenguaje;

program
    : expr EOF
    ;

expr
    : funcionLlamada                                 # FuncionExpr
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
    | 'LARGO' '(' IDENTIFICADOR ')'                  # FuncionLargo  // Reemplaza len() en Python
    | 'ORDENAR' '(' IDENTIFICADOR ')'                # FuncionOrdenar  // Reemplaza sorted() en Python
    | 'RANGO' '(' expr ',' expr ',' expr ')'         # FuncionRangoConPaso  // Reemplaza range(start, end, step) en Python
    | 'APLICAR' '(' IDENTIFICADOR ',' IDENTIFICADOR ')' # FuncionAplicar  // Reemplaza map() en Python
    | 'REDUCIR' '(' IDENTIFICADOR ',' IDENTIFICADOR ')' # FuncionReducir  // Reemplaza reduce() en Python
    | 'MOSTRAR' '(' expr ')'                         # FuncionMostrar  // Reemplaza print() en Python
    | 'DEFINIR' IDENTIFICADOR '(' IDENTIFICADOR* ')' 'COMO' bloque  # DefinirFuncion  // Reemplaza def en Python
    | 'PEDIR' '(' STRING ')'                         # FuncionPedir  // Reemplaza input() en Python
    | 'JUNTAR' '(' IDENTIFICADOR ',' IDENTIFICADOR ')' # FuncionJuntar  // Reemplaza zip() en Python
    | 'ENUMERAR' '(' IDENTIFICADOR ')'               # FuncionEnumerar  // Reemplaza enumerate() en Python
    | 'MIENTRAS' expr 'HACER' bloque                 # MientrasLoop
    | 'PARA' IDENTIFICADOR 'DESDE' expr 'HASTA' expr 'PASO' expr 'HACER' bloque # ParaLoopConPaso
    | 'TAMANIO' '(' IDENTIFICADOR ')'                # FuncionTamanio  // Reemplaza sizeof() en C++
    | 'VECTOR' '(' expr ')'                          # FuncionVector  // Reemplaza std::vector en C++
    | 'PUSH' '(' IDENTIFICADOR ',' expr ')'          # FuncionPush  // Reemplaza vector.push_back() en C++
    | 'POP' '(' IDENTIFICADOR ')'                    # FuncionPop  // Reemplaza vector.pop_back() en C++
    | 'POTENCIA' '(' expr ',' expr ')'               # FuncionPotencia  // Reemplaza pow() en C++
    | 'RAIZ' '(' expr ')'                            # FuncionRaiz  // Reemplaza sqrt() en C++
    | NUMERO                                         # Numero
    ;

bloque
    : '{' (expr)* '}'                                # BloqueInstrucciones
    ;

funcionLlamada
    : 'SUMA' '(' expr (',' expr)* ')'                # FuncionSuma  // Reemplaza sum() en Python
    | 'PROMEDIO' '(' expr (',' expr)* ')'            # FuncionPromedio  // Similar a mean() de la librería statistics en Python
    | 'MINIMO' '(' expr (',' expr)* ')'              # FuncionMinimo  // Reemplaza min() en Python
    | 'MAXIMO' '(' expr (',' expr)* ')'              # FuncionMaximo  // Reemplaza max() en Python
    ;

// Reglas léxicas
NUMERO : [0-9]+ ;

IDENTIFICADOR : [a-zA-Z]+ ;

// Reglas para reconocer cadenas de texto
STRING : '\'' (~[\r\n'] | '\\\'')* '\'';

// Ignorar espacios en blanco
ESPACIOS : [ \t\r\n]+ -> skip ;

// Comentarios de línea
COMENTARIO_LINEA : '//' .*? '\n' -> skip;

// Comentarios de bloque
COMENTARIO_BLOQUE : '/*' .*? '*/' -> skip;



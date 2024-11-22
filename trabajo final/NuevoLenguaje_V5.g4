grammar NuevoLenguaje;

// Estructura Principal del Programa
program: (
		declaracion
		| expr
		| controlFlujo
		| operacionesBasicas
		| manejoDatos
		| manejoErrores
		| temporizadores
		| funcionesUtiles
		| bloque
	)* EOF; // No requiere etiqueta, se maneja de forma general

// Declaración de Variables y Constantes
declaracion:
	'DECLARAR' IDENTIFICADOR 'COMO' TIPO '.'	# declararvariable
	| 'FIJAR' IDENTIFICADOR 'COMO' expr '.'		# fijarconstante;

// Tipos de Datos Soportados
TIPO: 'NUMERO' | 'TEXTO' | 'LOGICO' | 'LISTA' | 'DICCIONARIO';

// Expresiones y Operaciones Principales
expr:
	elementoBase (operador elementoBase)*			# expresioncompuesta
	| expr ('MENOR_QUE' | 'MAYOR_QUE' | 'ES') expr	# expresioncomparacion
	| 'MOSTRAR_TEXTO' '(' expr ')' '.'				# imprimirtexto
	| diccionarioLiteral							# diccionarioexpresion;

// Elemento Base
elementoBase:
	'(' expr ')'					# expresionenparentesis
	| IDENTIFICADOR '=' expr '.'	# asignarValor
	| NUMERO						# literalnumero
	| STRING						# literaltexto
	| IDENTIFICADOR					# usovariable;

// Operadores Soportados
operador:
	'+'
	| '-'
	| '*'
	| '/'
	| 'ES'
	| '='
	| 'MENOR_QUE'
	| 'MAYOR_QUE'
	| 'Y'
	| 'O'; // No se necesitan etiquetas

// Control de Flujo
controlFlujo:
	'CUANDO' expr 'HACER' bloque '.'									# condicionalcuando
	| 'MIENTRAS' expr 'HACER' bloque '.'								# buclemientras
	| 'PARA_CADA' IDENTIFICADOR 'EN' IDENTIFICADOR 'HACER' bloque '.'	# bucleparacada
	| 'REPETIR' bloque 'HASTA_QUE' expr '.'								# buclerepetir
	| 'DETENER' '.'														# detener
	| 'CONTINUAR' '.'													# continuar;

// Operaciones Básicas
operacionesBasicas:
	'SUMAR' '(' expr ',' expr ')' '.'			# operacionSuma
	| 'RESTAR' '(' expr ',' expr ')' '.'		# operacionresta
	| 'MULTIPLICAR' '(' expr ',' expr ')' '.'	# operacionmultiplicacion
	| 'DIVIDIR' '(' expr ',' expr ')' '.'		# operaciondivision
	| 'ABSOLUTO' '(' expr ')' '.'				# operacionabsoluto
	| 'REDONDEAR' '(' expr ')' '.'				# operacionredondear
	| 'MODULO' '(' expr ',' expr ')' '.'		# operacionmodulo
	| 'POTENCIA' '(' expr ',' expr ')' '.'		# operacionpotencia;

// Manejo de Datos Básico
manejoDatos:
	'CREAR_LISTA' '(' IDENTIFICADOR ')' '.'				# crearlista
	| 'AGREGAR_A' '(' IDENTIFICADOR ',' expr ')' '.'	# agregarelemento
	| 'ELIMINAR_DE' '(' IDENTIFICADOR ',' expr ')' '.'	# eliminarelemento
	| 'MOSTRAR' '(' IDENTIFICADOR ')' '.'				# mostrarlista
	| 'LONGITUD' '(' IDENTIFICADOR ')' '.'				# longitudlista
	| 'INVERTIR' '(' IDENTIFICADOR ')' '.'				# invertirlista
	| 'ORDENAR_ASC' '(' IDENTIFICADOR ')' '.'			# ordenarascendente
	| 'ORDENAR_DESC' '(' IDENTIFICADOR ')' '.'			# ordenardescendente;

// Manejo de Errores
manejoErrores:
	'INTENTAR' bloque 'SI_ERROR' bloque '.' # bloquemanejoerrores;

// Temporizadores
temporizadores:
	'ESPERAR' '(' expr ')' '.'	# temporizadoresperar
	| 'TIEMPO_ACTUAL' '.'		# tiempoactual;

// Funciones Útiles para Adaptación
funcionesUtiles:
	'MOSTRAR_TEXTO' '(' STRING ')' '.'						# imprimirtextofunc
	| 'LEER_ENTRADA' '(' STRING ')' '.'						# leerentrada
	| 'CONVERTIR_A_TEXTO' '(' expr ')' '.'					# convertiratexto
	| 'CONVERTIR_A_NUMERO' '(' STRING ')' '.'				# convertiranumero
	| 'ALEATORIO' '(' expr ',' expr ')' '.'					# generaraleatorio
	| 'ES_PRIMO' '(' expr ')' '.'							# verificarprimo
	| 'RAIZ_CUADRADA' '(' expr ')' '.'						# raizcuadrada
	| 'MAYUSCULA' '(' STRING ')' '.'						# convertirmayuscula
	| 'MINUSCULA' '(' STRING ')' '.'						# convertirminuscula
	| 'REEMPLAZAR' '(' expr ',' STRING ',' STRING ')' '.'	# reemplazartexto;

// Bloques de Código
bloque: (
		declaracion
		| expr
		| controlFlujo
		| operacionesBasicas
		| manejoDatos
		| manejoErrores
		| temporizadores
		| funcionesUtiles
	)+;

// Reglas Léxicas
NUMERO: [0-9]+;
IDENTIFICADOR: [a-zA-Z][a-zA-Z0-9_]*;
STRING: '\'' (~[\r\n'] | '\\\'')* '\'';
DOS_PUNTOS: ':';
ESPACIOS: [ \t\r\n]+ -> skip;
COMENTARIO_LINEA: '//' .*? '\n' -> skip;
COMENTARIO_BLOQUE: '/*' .*? '*/' -> skip;

// Reglas para Diccionario
diccionarioLiteral:
	'{' (claveValor (',' claveValor)*)? '}' # diccionariodefinido;

claveValor: STRING DOS_PUNTOS expr; // Sin etiqueta específica

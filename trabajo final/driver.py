import sys
from antlr.NuevoLenguajeLexer import NuevoLenguajeLexer
from antlr.NuevoLenguajeParser import NuevoLenguajeParser
from antlr4 import InputStream, CommonTokenStream
import llvmlite.ir as ir

# Clase que implementa la acción cuando se detectan ciertos nodos en el árbol de sintaxis
class NuevoLenguajeVisitor:
    variables = {}
    globales = {}
    builder = ir.IRBuilder()

    # Se agrega un módulo IR donde se acumulan las instrucciones
    module = ir.Module(name="nuevo_lenguaje_programa")

    def visit(self, node):
        if isinstance(node, NuevoLenguajeParser.ImprimirtextoContext):
            return self.visitImprimirtexto(node)
        if isinstance(node, NuevoLenguajeParser.ImprimirtextoidentificadorContext):
            return self.visitImprimirtextoidentificador(node)
        elif isinstance(node, NuevoLenguajeParser.DeclararvariableContext):
            return self.visitDeclararvariable(node)
        elif isinstance(node, NuevoLenguajeParser.FijarconstanteContext):
            return self.visitFijarconstante(node)
        elif isinstance(node, NuevoLenguajeParser.AsignarValorContext):
            return self.visitAsignarValor(node)
        elif isinstance(node, NuevoLenguajeParser.ExpresioncompuestaContext):
            return self.visitExpresioncompuesta(node)
        elif isinstance(node, NuevoLenguajeParser.ExpresioncomparacionContext):
            return self.visitExpresioncomparacion(node)
        elif isinstance(node, NuevoLenguajeParser.ListaliteralContext):
            return self.visitListaLiteral(node)
        elif isinstance(node, NuevoLenguajeParser.DiccionarioLiteralContext):
            return self.visitDiccionarioLiteral(node)
        return self.visitChildren(node)

    def visitChildren(self, node):
        if hasattr(node, 'children'):
            for i in range(len(node.children)):
                child = node.getChild(i)
                self.visit(child)

    def visitDeclararvariable(self, ctx):
        nombre = ctx.IDENTIFICADOR().getText()
        tipo = ctx.TIPO().getText()
        print(f"Declarando variable {nombre} de tipo {tipo}")
        if tipo == 'NUMERO':
            self.variables[nombre] = 0.0
        elif tipo == 'TEXTO':
            self.variables[nombre] = ''
        elif tipo == 'LOGICO':
            self.variables[nombre] = False
        elif tipo == 'LISTA':
            self.variables[nombre] = []
        elif tipo == 'DICCIONARIO':
            self.variables[nombre] = {}
        return self.visitChildren(ctx)
    
    def visitAsignarValor(self, ctx):
        identificador = ctx.IDENTIFICADOR().getText()
        tipo = self.variables[identificador]._class.name_
        valor = ctx.expr().getText()

        # Si el valor contiene una operación aritmética, evaluamos la expresión primero
        if '+' in valor or '-' in valor or '*' in valor or '/' in valor:
            valor = eval(valor)  # Evaluamos la expresión

        # Ahora procesamos el tipo de valor y lo almacenamos en la variable
        if tipo == 'float':
            try:
                valor_convertido = float(valor)  # Convertir el valor a flotante
                var_type = ir.FloatType()
                valor_convertido = ir.Constant(ir.FloatType(), valor_convertido)
            except ValueError:
                print(f"Error al convertir el valor {valor} a float.")
                valor_convertido = ir.Constant(ir.FloatType(), 0.0)  # Valor por defecto si hay error

        elif tipo == 'str':
            var_type = ir.IntType(8)
            valor_convertido = ir.Constant(ir.IntType(8), ord(valor[0]))  # Convertimos solo el primer carácter

        elif tipo == 'bool':
            var_type = ir.IntType(1)
            valor_convertido = ir.Constant(ir.IntType(1), 1 if valor.lower() == 'true' else 0)

        elif tipo == 'list':
            var_type = ir.ArrayType(ir.IntType(32), 10)
            valor_convertido = ir.Constant(var_type, [0] * 10)

        else:  # Para enteros por defecto
            var_type = ir.IntType(32)
            try:
                valor_convertido = ir.Constant(ir.IntType(32), int(valor))  # Convertir valor a entero
            except ValueError:
                print(f"Error al convertir el valor {valor} a entero.")
                valor_convertido = ir.Constant(ir.IntType(32), 0)  # Valor por defecto en caso de error

        # Crear una variable global en el módulo IR con el tipo y valor correspondiente
        var = ir.GlobalVariable(self.module, var_type, identificador)
        var.initializer = valor_convertido


    def generate_ir_for_assignment(self, identificador, valor):
        # Obtener el tipo de la variable
        tipo = self.variables[identificador]._class.name_.lower()

        if tipo == 'float':
            var_type = ir.FloatType()
            valor_convertido = ir.Constant(ir.FloatType(), float(valor))

        elif tipo == 'str':
            var_type = ir.IntType(8)
            valor_convertido = ir.Constant(ir.IntType(8), ord(valor[0]))  # Solo el primer carácter

        elif tipo == 'bool':
            var_type = ir.IntType(1)
            valor_convertido = ir.Constant(ir.IntType(1), 1 if valor.lower() == 'true' else 0)

        elif tipo == 'list':
            var_type = ir.ArrayType(ir.IntType(32), 10)
            valor_convertido = ir.Constant(var_type, [0] * 10)

        elif tipo == 'dict':
            var_type = ir.IntType(8)  # Como string
            valor_convertido = ir.Constant(ir.IntType(8), ord(valor[0]))  # Asumir el primer carácter como ejemplo

        else:
            var_type = ir.IntType(32)
            valor_convertido = ir.Constant(ir.IntType(32), int(valor))

        # Crear una variable global en el módulo IR con el tipo y valor correspondiente
        var = ir.GlobalVariable(self.module, var_type, identificador)
        var.initializer = valor_convertido



    def visitImprimirtexto(self, ctx):
        print("Imprimiendo texto")
        texto = ctx.getChild(2).getText().strip("'")
        print(texto)
        return self.visitChildren(ctx)

    def visitImprimirtextoidentificador(self, ctx):
        identificador = ctx.IDENTIFICADOR().getText()
        if identificador in self.globales:
            print(self.globales[identificador])
        elif identificador in self.variables:
            print(self.variables[identificador])
        else:
            print(f"Variable {identificador} no encontrada")

    def visitListaLiteral(self, ctx):
        lista = []
        for expr in ctx.expr():
            lista.append(self.visit(expr))
        return lista

    def visitDiccionarioLiteral(self, ctx):
        diccionario = {}
        for clave_valor in ctx.claveValor():
            clave = clave_valor.getChild(0).getText()
            valor = self.visit(clave_valor.getChild(2))
            diccionario[clave] = valor
        return diccionario

    def visitFijarconstante(self, ctx):
        identificador = ctx.IDENTIFICADOR().getText()
        valor = ctx.expr().getText()
        self.globales[identificador] = valor

    def visitExpresioncompuesta(self, ctx):
        print("Visiting expression node")
        elementoBase = ctx.elementoBase()
        operadores = ctx.operador()
        valores = [self.visit(elemento) for elemento in elementoBase]

        if not operadores:
            return valores[0]

        # Inicializar el resultado con el primer valor en la lista
        resultado = valores[0]

        # Mapeamos las operaciones a instrucciones LLVM
        for i in range(len(operadores)):
            operador = operadores[i].getText()
            valor = valores[i + 1]

            if operador == '+':
                # Sumar: result = result + valor
                resultado = ir.Add(resultado, valor, name="temp_add")
            elif operador == '-':
                # Restar: result = result - valor
                resultado = ir.Sub(resultado, valor, name="temp_sub")
            elif operador == '*':
                # Multiplicar: result = result * valor
                resultado = ir.Mul(resultado, valor, name="temp_mul")
            elif operador == '/':
                # Dividir: result = result / valor
                resultado = ir.SDiv(resultado, valor, name="temp_div")

        return resultado


    def visitExpresioncomparacion(self, ctx):
        # Obtener los operandos de la expresión de comparación
        operando1 = self.variables.get(ctx.expr(0).getChild(0).getText())
        operando2 = self.variables.get(ctx.expr(1).getChild(0).getText())
        
        # Obtener el operador de comparación
        operador = ctx.getChild(1).getText()
        
        # Realizar la comparación
        if operador == 'MENOR_QUE':
            return operando1 < operando2
            #return print(operando1 < operando2)
        elif operador == 'MAYOR_QUE':
            return operando1 > operando2
            #return print(operando1 > operando2)
        elif operador == 'IGUAL_QUE':
            return operando1 == operando2
            #return print(operando1 == operando2)
        
        # Si no se reconoce el operador, lanzar una excepción
        raise Exception(f"Operador de comparación no reconocido: {operador}")




    def generate_ir(self, filename='codigo_ir.ll'):
        # Guardar el código IR en un archivo
        with open(filename, 'w') as file:
            file.write(str(self.module))
        print(f"Código IR guardado en {filename}")


# Función principal que inicializa el análisis
def main(input_text):
    input_stream = InputStream(input_text)
    lexer = NuevoLenguajeLexer(input_stream)
    token_stream = CommonTokenStream(lexer)
    parser = NuevoLenguajeParser(token_stream)
    tree = parser.program()

    visitor = NuevoLenguajeVisitor()
    visitor.visit(tree)

    # Asegurarse de que se genere el IR después del procesamiento
    visitor.generate_ir('codigo_ir.ll')
    return visitor


# Función para cargar un archivo de entrada o texto
def load_input(file_path=None):
    if file_path:
        with open(file_path, 'r') as file:
            return file.read()
    else:
        return input("Ingresa tu código: ")  # Si no hay archivo, solicitamos entrada


if _name_ == '_main_':
    input_text = load_input('codigo_fuente.txt')  # O usa un archivo con tu código fuente
    visitor = main(input_text)

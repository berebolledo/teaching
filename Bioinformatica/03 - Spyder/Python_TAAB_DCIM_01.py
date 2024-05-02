#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 26 16:27:12 2024

@author: boris
"""

# Imprimir Hola Mundo en Python
print("Hola Mundo")

# Variables y tipos de datos
entero = 5 #integer
decimal = 3.14 #float
texto = "Curso de Python" #string
booleano = True #boolean

# Mostrar los valores y tipos
print(type(entero), entero)
print(type(decimal), decimal)
print(type(texto), texto)
print(type(booleano), booleano)

# Operaciones aritméticas
suma           = 5 + 3
resta          = 5 - 3
multiplicacion = 5 * 3
division       = 5 / 3

# Mostrar resultados
print("Suma:", suma)
print("Resta:", resta)
print("Multiplicación:", multiplicacion)
print("División:", division)

# Concatenación de strings
saludo = "Hola " + "Mundo"
print(saludo)

print('\t'.join(  ["Hola", "Mundo", "Estoy", "Bien"] ))



# Lista de números
numeros = [1, 2, 3, 4, 5]

uno_como_string = str(1)
uno_como_string

''.join(numeros)
''.join([str(i) for i in numeros])

# Imprimir cada número usando un bucle for
for numero in numeros:
    print(numero)

# Agregar un elemento a la lista
numeros.append(6)
print(numeros)

# Definir una función que sume dos números
def sumar(a, b):
    return a + b

# Llamar a la función y mostrar el resultado
resultado = sumar(5, 3)
print("El resultado de la suma es:", resultado)

# Ejemplo de estructura condicional
edad = 20

if edad >= 18:
    print("Eres mayor de edad")
else:
    print("Eres menor de edad")

# Diccionario de un estudiante
estudiante = {
    "nombre": "Juan",
    "edad": 21,
    "curso": "Python básico"
}

# Acceder a elementos del diccionario
print(estudiante["nombre"])
print(estudiante.get("edad"))

# Agregar un nuevo par clave-valor
estudiante["promedio"] = 6.5
print(estudiante)

# Crear una tupla con algunos elementos
mi_tupla = (1, 2, 3, 4, 5)

# Acceder a elementos de la tupla
print("Primer elemento:", mi_tupla[0])
print("Último elemento:", mi_tupla[-1])

# Intentar cambiar un elemento de la tupla (esto causará un error)
try:
    mi_tupla[0] = 10
except TypeError:
    print("Error: No puedes modificar una tupla")

# Tuplas pueden contener diferentes tipos de datos
tupla_variada = ("Hola", 100, 3.14, True)
print("Tupla variada:", tupla_variada)

# Desempaquetar una tupla en variables
a, b, c, d = tupla_variada
print("Desempaquetado:", a, b, c, d)

# Uso de tuplas en funciones
def min_max_elementos(nums):
    return min(nums), max(nums)  # Retorna una tupla con el mínimo y máximo

# Llamar a la función y usar el resultado
numeros = (50, 10, 30, 40, 20)
minimo, maximo = min_max_elementos(numeros)
print("Mínimo:", minimo, "Máximo:", maximo)

# -------------------------------------------------------------------------


L1 = ['a', 'b', 'c', 'd']
L2 = [1,2]

L1.append(1)
L1.extend(L2) 
L1.remove('a')
L1.reverse()
L1

T1 = ('a', 'b', 'c', 'd')
T1.index('c')

estudiante['nombre']
estudiante['altura']

bioinfo = {"camila": {"notas":"camila"}, "profesor":{"nombre":"boris"} }

bioinfo["estudiante"]["nombre"]

bioinfo["asistente"] = {"nombre":"cancino"}


for key,value in bioinfo.items():
    print(key)


nombres = ["nombre1", "nombre2"]
edades = [23, 35]

dict(zip(nombres, edades))









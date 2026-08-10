#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 26 17:09:10 2024

@author: boris
"""

# SOLUCION EJERCICIO 1
# Solicitar dos números al usuario
numero1 = float(input("Ingrese el primer número: "))
numero2 = float(input("Ingrese el segundo número: "))

# Operaciones aritméticas
suma = numero1 + numero2
resta = numero1 - numero2
multiplicacion = numero1 * numero2
division = numero1 / numero2 if numero2 != 0 else "No se puede dividir por cero"

# Mostrar resultados
print("Suma:", suma)
print("Resta:", resta)
print("Multiplicación:", multiplicacion)
print("División:", division)

# -----------------------------------------------------------------------------

# SOLUCION EJERCICIO 2
# Lista de precios de frutas
precios = [120, 80, 150, 30]

# Agregar precio de las naranjas
precios.append(90)

# Eliminar el precio de las bananas
precios.remove(80)

# Imprimir la lista resultante
print("Precios actualizados:", precios)

# Imprimir el precio más alto y el más bajo
print("Precio más alto:", max(precios))
print("Precio más bajo:", min(precios))

# -----------------------------------------------------------------------------

# SOLUCION EJERCICIO 3
# Definir la función
def describe_persona(nombre, edad, ciudad):
    print(f"{nombre} tiene {edad} años y vive en {ciudad}.")

# Llamar a la función con datos de ejemplo
describe_persona("Juan", 28, "Madrid")

# -----------------------------------------------------------------------------

# SOLUCION EJERCICIO 4
# Solicitar la edad al usuario
edad = int(input("Ingrese su edad: "))

# Estructura condicional para determinar la mayoría de edad
if edad >= 18:
    print("Eres mayor de edad")
else:
    print("Eres menor de edad")

# -----------------------------------------------------------------------------
# SOLUCIÓN EJERCICIO 5

# Crear un diccionario con información sobre un libro
libro = {
    "título": "Cien años de soledad",
    "autor": "Gabriel García Márquez",
    "año de publicación": 1967
}

# Agregar el número de páginas
libro["número de páginas"] = 295

# Crear una tupla con los valores del diccionario
informacion_libro = tuple(libro.values())

# Imprimir la tupla
print("Información del libro:", informacion_libro)

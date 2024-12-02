package com.exercici0104;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        
        Scanner scanner = new Scanner(System.in);

        // Demanar un float a l'usuari
        System.out.print("Escriu un número decimal: ");
        float numeroDecimal = scanner.nextFloat();

        // float a int (valor0)
        int valor0 = (int) numeroDecimal;

        // int a String
        String valor0String = Integer.toString(valor0);

        // Demanar un sol caràcter numèric
        System.out.print("Escriu un sol caràcter numèric: ");
        char caracter = scanner.next().charAt(0);

        // char a int (valor1)
        int valor1 = Character.getNumericValue(caracter);

        // Sumar valor0 i valor1, mostrar el resultat
        int suma = valor0 + valor1;

        System.out.println("Float convertit a Int (valor0): " + valor0);
        System.out.println("Int convertit a String: \"" + valor0String + "\"");
        System.out.println("Caràcter llegit: '" + caracter + "'");
        System.out.println("Char convertit a Int: " + valor1);
        System.out.println("La suma de valor0 i valor1 és: " + suma);
        scanner.close();
    }
}

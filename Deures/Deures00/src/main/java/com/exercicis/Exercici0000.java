package com.exercicis;

import java.util.Scanner;

public class Exercici0000 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        // Demanar els dos números a l'usuari
        System.out.print("Escriu el primer número: ");
        int primerNumero = scanner.nextInt();
        
        System.out.print("Escriu el segon número: ");
        int segonNumero = scanner.nextInt();
        
        // Calcular la resta
        int resultat = primerNumero - segonNumero;
        
        // Mostrar el resultat
        System.out.println("El resultat de calcular " + primerNumero + " - " + segonNumero + " és " + resultat);
        
        scanner.close();
    }
}

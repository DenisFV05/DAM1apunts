package com.exercicis;

import java.util.Scanner;

public class Exercici0000 {

    /**
     * Fes anar l'exercici amb:
     * ./run.sh com.exercicis.Exercici0000
     * 
     * Passa el test de l'exercici amb:
     * ./runTest.sh com.exercicis.TestExercici0000
     * 
     * Fes anar la solució amb:
     * ./run.sh com.exercicis.Resolt0001
     * 
     */
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Escriu el primer número: ");
        int a = scanner.nextInt();

        System.out.print("Escriu el segon número: ");
        int b = scanner.nextInt();

        int rst = a - b;

        System.out.println(String.format("El resultat de calcular %d - %d és %d", a, b, rst));

        /*
            TODO: Resol aquí l'exercici
         */

        scanner.close();
    }
}

package com.exercici0202;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("El preu original del producte: ");
        double preuOriginal = scanner.nextDouble();

        System.out.println("Quin % vols aplicar: ");
        double descompte = scanner.nextDouble();

        double preuFinal = preuOriginal - (preuOriginal * descompte / 100);
        System.out.println("El preu final es de: "+preuFinal);

        scanner.close();
    }
}

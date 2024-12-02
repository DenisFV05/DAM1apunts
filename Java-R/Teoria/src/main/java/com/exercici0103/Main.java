package com.exercici0103;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        
        Scanner scanner = new Scanner(System.in);

        System.out.print("Escriu un nom d'un país: ");
        String pais = scanner.nextLine();

        System.out.print("Escriu el nom d'una ciutat: ");
        String ciutat = scanner.nextLine();

        System.out.print("Escriu el número d'habitants: ");
        String habitants = scanner.nextLine();
        Double personas = Double.parseDouble(habitants);


        System.out.println(ciutat + " es una ciutat situada a " + pais + " amb " + personas + " habitants");

        scanner.close();
    }
}

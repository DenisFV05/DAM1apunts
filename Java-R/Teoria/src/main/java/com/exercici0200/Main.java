package com.exercici0200;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        double pi = Math.PI;
        System.out.println("El valor de π és: " + pi);

        System.out.print("Escriu un radi: ");
        String Sradi = scanner.nextLine();
        double radi = Double.parseDouble(Sradi);
        double area = pi * radi * radi;

        System.out.println("El area és: " + area);

        scanner.close();
    }
}

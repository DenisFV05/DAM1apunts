package com.exercici0102;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        
        Scanner scanner = new Scanner(System.in);

        System.out.print("Escriu un nombre: ");
        String numString = scanner.nextLine();
        double numero = Integer.parseInt(numString);

        System.out.println("El doble és: " + numero * 2);
        System.out.println("El triple és: " + numero * 3);
        System.out.println("La meitat és: " + numero / 2);

        scanner.close();
    }
}

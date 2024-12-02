package com.exercici0201;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Introdueix un valor en Celsius: ");
        double celsius = scanner.nextDouble();
        double fahrenheit = (celsius * 9/5) + 32;
    
        System.out.println("Celsius: " + celsius + "°C");
        System.out.println("Fahrenheit: " + fahrenheit + "°F");

        scanner.close();
    }
}


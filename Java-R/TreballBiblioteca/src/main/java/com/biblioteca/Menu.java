package com.biblioteca;

import java.util.Scanner;

public class Menu {

    // Función para mostrar el menú principal
    public static void mostrarMenuPrincipal(Scanner scanner) {
        int optMain = 0;

        // MENÚ PRINCIPAL
        do {
            System.out.println("""
                -- Gestio de biblioteca --
                1. Llibres
                2. Usuaris
                3. Prestecs
                0. Sortir
                Escull una opcio: """);
            if (scanner.hasNextInt()) {
                optMain = scanner.nextInt();

                switch (optMain) {
                    case 1:
                        limpiarPantalla();
                        menuLibros(scanner);
                        break;
                    case 2:
                        limpiarPantalla();
                        menuUsuarios(scanner);
                        break;
                    case 3:
                        limpiarPantalla();
                        menuPrestecs(scanner);
                        break;
                    case 0:
                        limpiarPantalla();
                        break;
                    default:
                        System.out.println("Opcio no valida. Torna-ho a intentar.\n");
                }
            } else {
                System.out.println("Si us plau, ingressa un número valid.\n ");
                scanner.next();
                optMain = -1;
            }
        } while (optMain != 0);
    }

    // Función para limpiar la pantalla
    public static void limpiarPantalla() {
        for (int i = 0; i < 50; i++) {
            System.out.println();
        }
    }

    // MENÚ LIBROS
    public static void menuLibros(Scanner scanner) {
        int optLibros;

        do {
            System.out.println("""
                -- Gestio de llibres --
                1. Afegir
                2. Modificar
                3. Eliminar
                4. Llistar
                0. Tornar al menu principal
                Escull una opcio: """);
            if (scanner.hasNextInt()) {
                optLibros = scanner.nextInt();

                switch (optLibros) {
                    case 1:
                        Llibres.afegirLlibre();
                        break;
                    case 2:
                        limpiarPantalla();
                        menuModificarLibros(scanner);
                        break;
                    case 3:
                        Llibres.eliminarLlibre();
                        break;
                    case 4:
                        limpiarPantalla();
                        menuListarLibros(scanner);
                        break;
                    case 0:
                        limpiarPantalla();
                        break;
                    default:
                        System.out.println("Opcio no valida. Torna-ho a intentar.\n");
                }
            } else {
                System.out.println("Si us plau, ingressa un número valid.\n");
                scanner.next();
                optLibros = -1;
            }
        } while (optLibros != 0);
    }

    // MENÚ LISTAR LIBROS
    public static void menuListarLibros(Scanner scanner) {
        int optListarLibros;

        do {
            System.out.println("""
                -- Llistar Llibres --
                1. Tots
                2. En prestec
                3. Per autor
                4. Cercar titol
                0. Tornar al menu de llibres
                Escull una opcio: """);
            if (scanner.hasNextInt()) {
                optListarLibros = scanner.nextInt();

                switch (optListarLibros) {
                    case 1:
                        limpiarPantalla();
                        Llibres.llistatLlibres();
                        break;
                    case 2:
                        limpiarPantalla();
                        Llibres.llistatLlibresPrestec();
                        break;
                    case 3:
                        limpiarPantalla();
                        Llibres.llistatLlibresAutor();
                        break;
                    case 4:
                        limpiarPantalla();
                        Llibres.llistatLlibresTitol();
                        break;
                    case 0:
                        limpiarPantalla();
                        break;
                    default:
                        System.out.println("Opcio no valida. Torna-ho a intentar.\n");
                }
            } else {
                System.out.println("Si us plau, ingressa un numero valid.\n");
                scanner.next();
                optListarLibros = -1;
            }
        } while (optListarLibros != 0);
    }

    // MENÚ MODIFICAR LIBROS
    public static void menuModificarLibros(Scanner scanner) {
        int optModificarLibros;

        do {
            System.out.println("""
                -- Modificar Llibres --
                1. Titol
                2. Autor
                0. Tornar al menu de llibres
                Escull una opcio: """);
            if (scanner.hasNextInt()) {
                optModificarLibros = scanner.nextInt();

                switch (optModificarLibros) {
                    case 1:
                        Llibres.modificarTitolLlibre();
                        break;
                    case 2:
                        Llibres.modificarAutorLlibre();
                        break;
                    case 0:
                        limpiarPantalla();
                        break;
                    default:
                        System.out.println("Opcio no valida. Torna-ho a intentar.\n");
                }
            } else {
                System.out.println("Si us plau, ingressa un numero valid.\n");
                scanner.next();
                optModificarLibros = -1;
            }
        } while (optModificarLibros != 0);
    }

    // MENÚ USUARIOS
    public static void menuUsuarios(Scanner scanner) {
        int optUsuarios;

        do {
            System.out.println("""
                -- Gestio d'usuaris --
                1. Afegir
                2. Modificar
                3. Eliminar
                4. Llistar
                0. Tornar al menu principal
                Escull una opcio: """);
            if (scanner.hasNextInt()) {
                optUsuarios = scanner.nextInt();

                switch (optUsuarios) {
                    case 1:
                        Usuari.crearUsuari();
                        break;
                    case 2:
                        limpiarPantalla();
                        Usuari.modificarUsuari();
                        break;
                    case 3:
                        Usuari.eliminarUsuari();
                        break;
                    case 4:
                        limpiarPantalla();
                        menuListarUsuaris(scanner);
                        break;
                    case 0:
                        limpiarPantalla();
                        break;
                    default:
                        System.out.println("Opcio no valida. Torna-ho a intentar.\n");
                }
            } else {
                System.out.println("Si us plau, ingressa un número valid.\n");
                scanner.next();
                optUsuarios = -1;
            }
        } while (optUsuarios != 0);
    }

    // MENÚ MODIFICAR USUARIOS
    public static void menuModificarUsuarios(Scanner scanner) {
        int optModificarUsuario;

        do {
            System.out.println("""
                -- Modificar Usuari --
                1. Nom
                2. Cognom
                3. Telefon
                0. Tornar al menu d'usuaris
                Escull una opcio: """);
            if (scanner.hasNextInt()) {
                optModificarUsuario = scanner.nextInt();

                switch (optModificarUsuario) {
                    case 1:
                        break;
                    case 2:
                        limpiarPantalla();
                        menuModificarCognoms(scanner);
                        break;
                    case 3:
                        break;
                    case 0:
                        limpiarPantalla();
                        break;
                    default:
                        System.out.println("Opcio no valida. Torna-ho a intentar.\n");
                }
            } else {
                System.out.println("Si us plau, ingressa un numero valid.\n");
                scanner.next();
                optModificarUsuario = -1;
            }
        } while (optModificarUsuario != 0);
    }

    // MENÚ MODIFICAR APELLIDOS
    public static void menuModificarCognoms(Scanner scanner) {
        int optListarUsuaris;

        do {
            System.out.println("""
                -- Modificar Cognoms --
                1. Primer cognom
                2. Segon cognom
                0. Tornar al menu d'usuaris
                Escull una opcio: """);
            if (scanner.hasNextInt()) {
                optListarUsuaris = scanner.nextInt();

                switch (optListarUsuaris) {
                    case 1:
                        break;
                    case 2:
                        break;
                    case 0:
                        limpiarPantalla();
                        break;
                    default:
                        System.out.println("Opcio no valida. Torna-ho a intentar.\n");
                }
            } else {
                System.out.println("Si us plau, ingressa un numero valid.\n");
                scanner.next();
                optListarUsuaris = -1;
            }
        } while (optListarUsuaris != 0);
    }

    // MENÚ LISTAR USUARIOS
    public static void menuListarUsuaris(Scanner scanner) {
        int optListarLibros;

        do {
            System.out.println("""
                -- Llistar Usuaris --
                1. Tots
                2. Usuaris amb prestecs actius
                3. Usuaris amb prestecs fora de termini
                0. Tornar al menu d'usuaris
                Escull una opcio: """);
            if (scanner.hasNextInt()) {
                optListarLibros = scanner.nextInt();

                switch (optListarLibros) {
                    case 1:
                        Usuari.llistatUsuaris();
                        break;
                    case 2:
                        Usuari.llistatUsuarisPrestecsActius();
                        break;
                    case 3:
                        Usuari.llistatUsuarisPrestecsForaDeTermini();
                        break;
                    case 0:
                        limpiarPantalla();
                        break;
                    default:
                        System.out.println("Opcio no valida. Torna-ho a intentar.\n");
                }
            } else {
                System.out.println("Si us plau, ingressa un numero valid.\n");
                scanner.next();
                optListarLibros = -1;
            }
        } while (optListarLibros != 0);
    }

    public static void menuPrestecs(Scanner scanner){
        int optPrestecs;
        
        do { 
            System.out.println("""
                -- Gestionar Prestecs --
                1. Agafar un nou llibre
                2. Retornar un llibre
                0. Tornar al menu principal
                    """);
            if (scanner.hasNextInt()){
                optPrestecs = scanner.nextInt();
                
                switch (optPrestecs) {
                    case 1:
                        limpiarPantalla();
                        Prestec.prestecFuncionAgafarNouLlibre(scanner);
                        break;
                    case 2:
                        limpiarPantalla();
                        Prestec.prestecFuncionRetornarLlibre(scanner);
                        break;
                    case 0:
                        limpiarPantalla();
                        break;
                    default:
                        System.out.println("Opcio no valida. Torna-ho a intentar.\n");
                }
            } else {
                System.out.println("Si us plau, ingressa un numero valid.\n");
                scanner.next();
                optPrestecs = -1;
            }
        } while (optPrestecs != 0);
    }
}

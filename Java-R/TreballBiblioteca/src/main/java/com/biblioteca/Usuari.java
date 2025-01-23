package com.biblioteca;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;

import org.json.JSONArray;
import org.json.JSONObject;

public class Usuari {
    private static final String FILE_PATH = "src\\main\\json\\usuaris.json"; // Ruta del json

    // Llegeix el fitxer JSON i retorna un JSONArray
    public static JSONArray llegirFitxerJson() {
        try {
            String contingut = new String(Files.readAllBytes(Paths.get(FILE_PATH))); // Lee el archivo
            return new JSONArray(contingut);
        } catch (IOException e) {
            System.out.println("Error en llegir el fitxer JSON: " + e.getMessage()); // Error si no lo lee
            return new JSONArray();
        }
    }

    // Escriu un JSONArray al fitxer JSON
    public static void escriureFitxerJson(JSONArray jsonArray) {
        try {
            Files.write(Paths.get(FILE_PATH), jsonArray.toString(4).getBytes()); // Escribe en el archivo
        } catch (IOException e) {
            System.out.println("Error en escriure al fitxer JSON: " + e.getMessage()); // Error si no puede
        }
    }

    // Crea un nou usuari i l’afegeix al fitxer JSON
    public static void crearUsuari() {
        Scanner scanner = new Scanner(System.in); // Start del input
        try {
            JSONArray usuaris = llegirFitxerJson();

            System.out.print("\nIntrodueix el nom de l'usuari: "); // Pregunta y valida
            String nom = validarNom(scanner);

            System.out.print("\nIntrodueix el primer cognom: "); // Pregunta y valida
            String primerCognom = validarNom(scanner);

            System.out.print("\nIntrodueix el segon cognom: "); // Pregunta y valida
            String segonCognom = validarNom(scanner);

            System.out.print("\nIntrodueix el telèfon de l'usuari: "); // Pregunta y valida
            String telefon = validarTelefon(scanner);

            System.out.print("\nVols guardar aquest usuari? (s/n): ");
            String confirmacio = scanner.nextLine().trim().toLowerCase(); // Se confirma los datos del scanner

            if (confirmacio.equals("s")) { // Si la respuesta es si
                int nouId = obtenirSeguentId(usuaris); // id nueva teniendo en cuenta las que ya hay

                JSONObject nouUsuari = new JSONObject(); // Se crea el usuari nuevo
                nouUsuari.put("idUsuari", nouId);
                nouUsuari.put("nom", nom);
                nouUsuari.put("cognoms", primerCognom + " " + segonCognom);
                nouUsuari.put("telefon", telefon);

                usuaris.put(nouUsuari); // Se introducen en el json
                escriureFitxerJson(usuaris); // Se escribe en el json

                System.out.println("\nUsuari afegit correctament.");
            } else { // Si escribimos no o lo que sea
                System.out.println("\nUsuari no desat.");
            }
        } finally {
            // NO SE CIERRA EL SCANNER QUE DA PROBLEMAS
        }
    }

    // Valida el nom o cognom introduït per l'usuari
    private static String validarNom(Scanner scanner) {
        String entrada;
        System.out.print("Introdueix el nom (mínim 4 caràcters, sense espais): ");
        entrada = scanner.nextLine().trim(); // Obtenemos la entrada del nombre
        while (entrada.isEmpty() || entrada.length() < 4 || entrada.contains(" ")) { // Mientras el nombre este vacio, sea muy corto o tenga espacio
            System.out.println("Entrada no vàlida. Introdueix un valor vàlid (mínim 4 caràcters, sense espais):");
            entrada = scanner.nextLine().trim(); // Repetimos la pregunta
        }
        return entrada.substring(0, 1).toUpperCase() + entrada.substring(1).toLowerCase(); // Si esta bien devuelve String primera letra en mayus y el resto en minus
    }

    // Valida que el telèfon sigui correcte
    private static String validarTelefon(Scanner scanner) {
        String entrada;
        // Primero pedimos la entrada y luego validamos.
        System.out.print("Introdueix el telèfon (9 dígits): ");
        entrada = scanner.nextLine().trim(); // Obtenemos la entrada del nombre
        while (!entrada.matches("\\d{9}")) {// verifica si la cadena contiene exactamente 9 digitos consecutivos, \\d es cualquier digito 0-9
            System.out.print("Entrada no vàlida. Introdueix un telèfon vàlid (9 dígits): ");
            entrada = scanner.nextLine().trim(); // Repetimos la pregunta
        } 
        return entrada;
    }

    // Obté el següent ID disponible
    private static int obtenirSeguentId(JSONArray usuaris) {
        int maxId = 0;
        for (int i = 0; i < usuaris.length(); i++) { // Tiene en cuenta el numero de usuarios actual
            JSONObject usuari = usuaris.getJSONObject(i);
            maxId = Math.max(maxId, usuari.getInt("idUsuari")); // Usa la función para calcular el máximo
        }
        return maxId + 1; // Devuelve una id nueva
    }

    public static void modificarUsuari() {
        Scanner scanner = new Scanner(System.in); // Abrir el input
        try {
            // Leer JSON de usuarios
            JSONArray usuaris = llegirFitxerJson();
    
            // Mostrar lista de usuarios
            System.out.println("\nID    | Nom            | Cognoms             | Telèfon");
            System.out.println("--------------------------------------------------------");
            for (int i = 0; i < usuaris.length(); i++) {
                JSONObject usuari = usuaris.getJSONObject(i);
                int idUsuari = usuari.getInt("idUsuari");
                String nom = usuari.getString("nom");
                String cognoms = usuari.getString("cognoms");
                String telefon = usuari.get("telefon").toString();
    
                System.out.printf("%-6d| %-15s| %-20s| %-10s%n", idUsuari, nom, cognoms, telefon);
            }
    
            // Pedir el ID del usuario a modificar
            System.out.print("\nIntrodueix l'ID d'un usuari per modificar-lo: ");
            int selectUsuariId = Integer.parseInt(scanner.nextLine().trim());
    
            // Buscar el usuario por ID
            JSONObject usuariSeleccionat = null;
            for (int i = 0; i < usuaris.length(); i++) {
                JSONObject usuari = usuaris.getJSONObject(i);
                if (usuari.getInt("idUsuari") == selectUsuariId) {
                    usuariSeleccionat = usuari;
                    break;
                }
            }
    
            if (usuariSeleccionat == null) {
                System.out.println("Usuari no trobat.");
                return;
            }
    
            // Modificar los datos del usuario
            System.out.println("Modificant l'usuari amb ID: " + selectUsuariId);
    
            // Leer y decidir si modificar el nombre
            System.out.print("Introdueix el nou nom (deixa en blanc per mantenir el valor actual): ");
            String nouNom = scanner.nextLine().trim();
            if (!nouNom.isEmpty()) {
                // Validamos el nombre directamente aquí
                while (nouNom.isEmpty() || nouNom.length() < 4 || nouNom.contains(" ")) {
                    System.out.println("Entrada no vàlida. Introdueix un valor vàlid (mínim 4 caràcters, sense espais):");
                    nouNom = scanner.nextLine().trim();
                }
                // Capitalizar primer letra
                nouNom = nouNom.substring(0, 1).toUpperCase() + nouNom.substring(1).toLowerCase();
                usuariSeleccionat.put("nom", nouNom);
            }
    
            // Leer y decidir si modificar los apellidos
            System.out.print("Introdueix els nous cognoms (deixa en blanc per mantenir el valor actual): ");
            String nousCognoms = scanner.nextLine().trim();
            if (!nousCognoms.isEmpty()) {
                usuariSeleccionat.put("cognoms", nousCognoms);
            }
    
            // Leer y decidir si modificar el teléfono
            System.out.print("Introdueix el nou telèfon (deixa en blanc per mantenir el valor actual): ");
            String nouTelefon = scanner.nextLine().trim();
            if (!nouTelefon.isEmpty()) {
                // Validamos el teléfono aquí
                while (!nouTelefon.matches("\\d{9}")) {
                    System.out.print("Entrada no vàlida. Introdueix un telèfon vàlid (9 dígits): ");
                    nouTelefon = scanner.nextLine().trim();
                }
                usuariSeleccionat.put("telefon", nouTelefon);
            }
    
            // Guardar los cambios en el archivo JSON
            escriureFitxerJson(usuaris);
            System.out.println("Usuari modificat correctament.");
        } catch (Exception e) {
            System.out.println("Error en modificar l'usuari: " + e.getMessage());
        } finally {
            // no se cierra el scanner
        }
    }
    
    
    
    
    
    
    
    

    public static void eliminarUsuari() {
        Scanner scanner = new Scanner(System.in);
        try {
            JSONArray usuaris = llegirFitxerJson(); // Leer json
    
            System.out.print("Introdueix l'ID de l'usuari que vols eliminar: ");
            int idUsuari = Integer.parseInt(scanner.nextLine());
    
            // Buscar el usuari per ID y eliminarlo
            for (int i = 0; i < usuaris.length(); i++) { // Bucle que recorre los usuaris
                JSONObject usuariActual = usuaris.getJSONObject(i); // Selecciona el usuari a eliminar
                if (usuariActual.getInt("idUsuari") == idUsuari) {
                    usuaris.remove(i); // Eliminar l'usuari a l'índex 'i'
                    escriureFitxerJson(usuaris); // Guardar els canvis
                    System.out.println("Usuari eliminat correctament.");
                    return; // Salir del mètodo después de eliminar
                }
            }
    
            // Si no se encuentra el usuario
            System.out.println("Usuari no trobat.");
    
        } catch (Exception e) {
            System.out.println("Error en eliminar l'usuari: " + e.getMessage());
        } finally {
            // no se cierra el scanner
        }
    }
    
    // Método para listar todos los usuarios
    public static void llistatUsuaris() {
        try {
            String rutaJsonUsuaris = "src/main/json/usuaris.json";
            String contingutUsuaris = new String(Files.readAllBytes(Paths.get(rutaJsonUsuaris)));
            
            JSONArray usuaris = new JSONArray(contingutUsuaris);

            System.out.println("-".repeat(30) + " LLISTAT D'USUARIS " + "-".repeat(30));
            System.out.printf("%-10s | %-20s | %-20s | %-15s%n", "ID", "Nom", "Cognoms", "Telèfon");
            System.out.println("-".repeat(80));

            for (int i = 0; i < usuaris.length(); i++) {
                JSONObject usuari = usuaris.getJSONObject(i);
                int id = usuari.getInt("idUsuari");
                String nom = usuari.getString("nom");
                String cognoms = usuari.getString("cognoms");
                Object telefonObj = usuari.get("telefon");
                String telefon = telefonObj.toString(); // Convertimos cualquier tipo a String

                System.out.printf("%-10d | %-20s | %-20s | %-15s%n", id, nom, cognoms, telefon);
            }
            System.out.println();
        } catch (Exception e) {
            System.err.println("Error al llistar els usuaris: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Método para listar usuarios con préstamos activos
    public static void llistatUsuarisPrestecsActius() {
        try {
            String rutaJsonPrestecs = "src/main/json/prestecs.json";
            String contingutPrestecs = new String(Files.readAllBytes(Paths.get(rutaJsonPrestecs)));

            String rutaJsonUsuaris = "src/main/json/usuaris.json";
            String contingutUsuaris = new String(Files.readAllBytes(Paths.get(rutaJsonUsuaris)));

            JSONArray prestecs = new JSONArray(contingutPrestecs);
            JSONArray usuaris = new JSONArray(contingutUsuaris);

            LocalDate avui = LocalDate.now();

            System.out.println("-".repeat(30) + " USUARIS AMB PRÉSTECS ACTIUS " + "-".repeat(30));
            System.out.printf("%-10s | %-20s | %-20s | %-15s%n", "ID", "Nom", "Cognoms", "Telèfon");
            System.out.println("-".repeat(80));

            for (int i = 0; i < usuaris.length(); i++) {
                JSONObject usuari = usuaris.getJSONObject(i);
                int idUsuari = usuari.getInt("idUsuari");

                boolean tePrestecActiu = false;
                for (int j = 0; j < prestecs.length(); j++) {
                    JSONObject prestec = prestecs.getJSONObject(j);
                    if (prestec.getInt("idUsuari") == idUsuari) {
                        LocalDate dataDevolucio = LocalDate.parse(prestec.getString("dataDevolucio"), DateTimeFormatter.ISO_DATE);
                        if (dataDevolucio.isAfter(avui)) {
                            tePrestecActiu = true;
                            break;
                        }
                    }
                }

                if (tePrestecActiu) {
                    String nom = usuari.getString("nom");
                    String cognoms = usuari.getString("cognoms");
                    Object telefonObj = usuari.get("telefon");
                    String telefon = telefonObj.toString(); // Convertimos cualquier tipo a String

                    System.out.printf("%-10d | %-20s | %-20s | %-15s%n", idUsuari, nom, cognoms, telefon);
                }
            }
            System.out.println();
        } catch (Exception e) {
            System.err.println("Error al llistar els usuaris amb préstecs actius: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Método para listar usuarios con préstamos fuera de término
    public static void llistatUsuarisPrestecsForaDeTermini() {
        try {
            String rutaJsonPrestecs = "src/main/json/prestecs.json";
            String contingutPrestecs = new String(Files.readAllBytes(Paths.get(rutaJsonPrestecs)));

            String rutaJsonUsuaris = "src/main/json/usuaris.json";
            String contingutUsuaris = new String(Files.readAllBytes(Paths.get(rutaJsonUsuaris)));

            JSONArray prestecs = new JSONArray(contingutPrestecs);
            JSONArray usuaris = new JSONArray(contingutUsuaris);

            LocalDate avui = LocalDate.now();

            System.out.println("-".repeat(30) + " USUARIS AMB PRÉSTECS FORA DE TERMINI " + "-".repeat(30));
            System.out.printf("%-10s | %-20s | %-20s | %-15s%n", "ID", "Nom", "Cognoms", "Telèfon");
            System.out.println("-".repeat(80));

            for (int i = 0; i < usuaris.length(); i++) {
                JSONObject usuari = usuaris.getJSONObject(i);
                int idUsuari = usuari.getInt("idUsuari");

                boolean tePrestecForaDeTermini = false;
                for (int j = 0; j < prestecs.length(); j++) {
                    JSONObject prestec = prestecs.getJSONObject(j);
                    if (prestec.getInt("idUsuari") == idUsuari) {
                        LocalDate dataDevolucio = LocalDate.parse(prestec.getString("dataDevolucio"), DateTimeFormatter.ISO_DATE);
                        if (dataDevolucio.isBefore(avui)) {
                            tePrestecForaDeTermini = true;
                            break;
                        }
                    }
                }

                if (tePrestecForaDeTermini) {
                    String nom = usuari.getString("nom");
                    String cognoms = usuari.getString("cognoms");
                    Object telefonObj = usuari.get("telefon");
                    String telefon = telefonObj.toString(); // Convertimos cualquier tipo a String

                    System.out.printf("%-10d | %-20s | %-20s | %-15s%n", idUsuari, nom, cognoms, telefon);
                }
            }
            System.out.println();
        } catch (Exception e) {
            System.err.println("Error al llistar els usuaris amb préstecs fora de termini: " + e.getMessage());
            e.printStackTrace();
        }
    }

        
}

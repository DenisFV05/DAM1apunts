package com.exercici1201;

public class Llibre {
    private String titol;
    private String autor;
    private Integer anyPublicacio;
    private boolean prestec;

    public Llibre(String titol, String autor, Integer anyPublicacio) {
        this.titol = titol;
        this.autor = autor;
        this.anyPublicacio = anyPublicacio;
        this.prestec = false;
    }

    public String getTitol() {
        return titol;
    }

    public String getAutor() {
        return autor;
    }

    public Integer getAnyPublicacio() {
        return anyPublicacio;
    }

    public boolean estaPrestat() {
        return prestec;
    }

    public void prestar() {
        prestec = true;
    }

    public void retornar() {
        prestec = false;
    }

    @Override
    public String toString() {
        if (estaPrestat()) {
        return titol + ", " + autor + "; " + anyPublicacio + " - En préstec";
    } else {return titol + ", " + autor + "; " + anyPublicacio + " - Disponible";}}


}

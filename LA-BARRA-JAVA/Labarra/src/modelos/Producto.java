package modelos;

public class Producto {

    private int id_producto;
    private String nombre;
    private double precio;
    private int estado;

    public Producto() {
    }

    public Producto(int id_producto, String nombre, double precio, int estado) {
        this.id_producto = id_producto;
        this.nombre = nombre;
        this.precio = precio;
        this.estado = estado;
    }

    public int getId_producto() {
        return id_producto;
    }

    public void setId_producto(int id_producto) {
        this.id_producto = id_producto;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

}
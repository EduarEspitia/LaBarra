package controladores;

import conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.swing.JOptionPane;
import modelos.Producto;

public class CtrlProducto {

    public boolean guardar(Producto objeto) {

        boolean respuesta = false;

        Conexion objetoConexion = new Conexion();
        Connection cn = objetoConexion.establecerConexion();

        try {

            PreparedStatement consulta = cn.prepareStatement(
                    "INSERT INTO producto(nombre, precio, estado) VALUES (?, ?, ?)");

            consulta.setString(1, objeto.getNombre());
            consulta.setDouble(2, objeto.getPrecio());
            consulta.setInt(3, objeto.getEstado());

            if (consulta.executeUpdate() > 0) {
                respuesta = true;
            }

            cn.close();

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error al guardar producto: " + e);
        }

        return respuesta;
    }

    public boolean actualizar(Producto objeto) {

        boolean respuesta = false;

        Conexion objetoConexion = new Conexion();
        Connection cn = objetoConexion.establecerConexion();

        try {

            PreparedStatement consulta = cn.prepareStatement(
                    "UPDATE producto SET nombre = ?, precio = ?, estado = ? WHERE id_producto = ?");

            consulta.setString(1, objeto.getNombre());
            consulta.setDouble(2, objeto.getPrecio());
            consulta.setInt(3, objeto.getEstado());
            consulta.setInt(4, objeto.getId_producto());

            if (consulta.executeUpdate() > 0) {
                respuesta = true;
            }

            cn.close();

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error al actualizar producto: " + e);
        }

        return respuesta;
    }

    public boolean eliminar(int idProducto) {

        boolean respuesta = false;

        Conexion objetoConexion = new Conexion();
        Connection cn = objetoConexion.establecerConexion();

        try {

            PreparedStatement consulta = cn.prepareStatement(
                    "DELETE FROM producto WHERE id_producto = ?");

            consulta.setInt(1, idProducto);

            if (consulta.executeUpdate() > 0) {
                respuesta = true;
            }

            cn.close();

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error al eliminar producto: " + e);
        }

        return respuesta;
    }
}
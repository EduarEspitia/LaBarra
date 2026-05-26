package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    Connection conectar = null;

    String usuario = "root";
    String contraseña = "Prieto99";
    String bd = "la_barra";
    String ip = "localhost";
    String puerto = "3306";

    String cadena = "jdbc:mysql://" + ip + ":" + puerto + "/" + bd;

    public Connection establecerConexion() {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            conectar = DriverManager.getConnection(cadena, usuario, contraseña);

            System.out.println("Conexión exitosa a MySQL");

        } catch (ClassNotFoundException | SQLException e) {

            System.out.println("Error en la conexión: " + e.toString());

        }

        return conectar;
    }
}
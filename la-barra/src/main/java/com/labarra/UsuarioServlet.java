
package com.labarra;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/la_barra",
                    "root",
                    "prieto99@"
            );

            if ("guardar".equals(accion)) {

                String nombre = request.getParameter("nombre");
                String correo = request.getParameter("correo");
                String clave = request.getParameter("clave");
                int idRol = Integer.parseInt(request.getParameter("id_rol"));

                if (nombre.trim().isEmpty() || correo.trim().isEmpty() || clave.trim().isEmpty()) {
                    response.sendRedirect("usuarios.jsp?mensaje=campos");
                    return;
                }

                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO usuario(nombre, correo, clave, estado, id_rol) VALUES(?,?,?,1,?)"
                );

                ps.setString(1, nombre);
                ps.setString(2, correo);
                ps.setString(3, clave);
                ps.setInt(4, idRol);

                ps.executeUpdate();

                response.sendRedirect("usuarios.jsp?mensaje=guardado");

            } else if ("actualizar".equals(accion)) {

                int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));
                String nombre = request.getParameter("nombre");
                String correo = request.getParameter("correo");
                String clave = request.getParameter("clave");
                int estado = Integer.parseInt(request.getParameter("estado"));
                int idRol = Integer.parseInt(request.getParameter("id_rol"));

                if (nombre.trim().isEmpty() || correo.trim().isEmpty() || clave.trim().isEmpty()) {
                    response.sendRedirect("usuarios.jsp?mensaje=campos");
                    return;
                }

                PreparedStatement ps = con.prepareStatement(
                        "UPDATE usuario SET nombre=?, correo=?, clave=?, estado=?, id_rol=? WHERE id_usuario=?"
                );

                ps.setString(1, nombre);
                ps.setString(2, correo);
                ps.setString(3, clave);
                ps.setInt(4, estado);
                ps.setInt(5, idRol);
                ps.setInt(6, idUsuario);

                ps.executeUpdate();

                response.sendRedirect("usuarios.jsp?mensaje=actualizado");

            } else if ("eliminar".equals(accion)) {

                int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));

                PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM usuario WHERE id_usuario=?"
                );

                ps.setInt(1, idUsuario);
                ps.executeUpdate();

                response.sendRedirect("usuarios.jsp?mensaje=eliminado");
            }

            con.close();

        } catch (Exception e) {
            response.sendRedirect("usuarios.jsp?mensaje=error");
        }
    }
}
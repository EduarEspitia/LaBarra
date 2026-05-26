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

@WebServlet("/ProductoServlet")
public class ProductoServlet extends HttpServlet {

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
                double precio = Double.parseDouble(request.getParameter("precio"));

                if (precio <= 0) {
                    response.sendRedirect("productos.jsp?mensaje=precio");
                    return;
                }

                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO producto(nombre, precio, estado, stock) VALUES(?,?,1,0)"
                );

                ps.setString(1, nombre);
                ps.setDouble(2, precio);
                ps.executeUpdate();

                response.sendRedirect("productos.jsp?mensaje=guardado");

            } else if ("actualizar".equals(accion)) {

                int id = Integer.parseInt(request.getParameter("id_producto"));
                String nombre = request.getParameter("nombre");
                double precio = Double.parseDouble(request.getParameter("precio"));

                if (precio <= 0) {
                    response.sendRedirect("productos.jsp?mensaje=precio");
                    return;
                }

                PreparedStatement ps = con.prepareStatement(
                        "UPDATE producto SET nombre=?, precio=? WHERE id_producto=?"
                );

                ps.setString(1, nombre);
                ps.setDouble(2, precio);
                ps.setInt(3, id);
                ps.executeUpdate();

                response.sendRedirect("productos.jsp?mensaje=actualizado");

            } else if ("eliminar".equals(accion)) {

                int id = Integer.parseInt(request.getParameter("id_producto"));

                PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM producto WHERE id_producto=?"
                );

                ps.setInt(1, id);
                ps.executeUpdate();

                response.sendRedirect("productos.jsp?mensaje=eliminado");
            }

            con.close();

        } catch (Exception e) {
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}
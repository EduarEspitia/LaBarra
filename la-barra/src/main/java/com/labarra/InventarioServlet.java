package com.labarra;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/InventarioServlet")
public class InventarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idProducto = Integer.parseInt(request.getParameter("id_producto"));
        String tipo = request.getParameter("tipo");
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));

        if (cantidad <= 0) {
            response.sendRedirect("inventario.jsp?mensaje=cantidad");
            return;
        }

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/la_barra",
                    "root",
                    "prieto99@"
            );

            PreparedStatement psStock = con.prepareStatement(
                    "SELECT stock FROM producto WHERE id_producto=?"
            );

            psStock.setInt(1, idProducto);

            ResultSet rsStock = psStock.executeQuery();

            int stockActual = 0;

            if (rsStock.next()) {
                stockActual = rsStock.getInt("stock");
            }

            if ("Salida".equals(tipo) && cantidad > stockActual) {
                response.sendRedirect("inventario.jsp?mensaje=stock");
                return;
            }

            PreparedStatement psMovimiento = con.prepareStatement(
                    "INSERT INTO movimiento_inventario(id_producto, tipo, cantidad) VALUES(?,?,?)"
            );

            psMovimiento.setInt(1, idProducto);
            psMovimiento.setString(2, tipo);
            psMovimiento.setInt(3, cantidad);
            psMovimiento.executeUpdate();

            PreparedStatement psActualizar;

            if ("Entrada".equals(tipo)) {
                psActualizar = con.prepareStatement(
                        "UPDATE producto SET stock = stock + ? WHERE id_producto=?"
                );
            } else {
                psActualizar = con.prepareStatement(
                        "UPDATE producto SET stock = stock - ? WHERE id_producto=?"
                );
            }

            psActualizar.setInt(1, cantidad);
            psActualizar.setInt(2, idProducto);
            psActualizar.executeUpdate();

            response.sendRedirect("inventario.jsp?mensaje=guardado");

        } catch (Exception e) {
            response.sendRedirect("inventario.jsp?mensaje=error");
        }
    }
}
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
import java.sql.Statement;

@WebServlet("/VentaServlet")
public class VentaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idProducto = Integer.parseInt(request.getParameter("id_producto"));
            int cantidad = Integer.parseInt(request.getParameter("cantidad"));
            String metodoPago = request.getParameter("metodo_pago");

            int idUsuario = 1;

            if (cantidad <= 0) {
                response.sendRedirect("ventas.jsp?mensaje=cantidad");
                return;
            }

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/la_barra",
                    "root",
                    "prieto99@"
            );

            PreparedStatement psProducto = con.prepareStatement(
                    "SELECT precio, stock FROM producto WHERE id_producto=?"
            );

            psProducto.setInt(1, idProducto);

            ResultSet rsProducto = psProducto.executeQuery();

            if (rsProducto.next()) {

                double precio = rsProducto.getDouble("precio");
                int stockActual = rsProducto.getInt("stock");

                if (cantidad > stockActual) {
                    response.sendRedirect("ventas.jsp?mensaje=error");
                    return;
                }

                double subtotal = precio * cantidad;

                PreparedStatement psVenta = con.prepareStatement(
                        "INSERT INTO venta(fecha_hora, total, metodo_pago, id_usuario) VALUES(NOW(), ?, ?, ?)",
                        Statement.RETURN_GENERATED_KEYS
                );

                psVenta.setDouble(1, subtotal);
                psVenta.setString(2, metodoPago);
                psVenta.setInt(3, idUsuario);
                psVenta.executeUpdate();

                ResultSet rsVenta = psVenta.getGeneratedKeys();

                int idVenta = 0;

                if (rsVenta.next()) {
                    idVenta = rsVenta.getInt(1);
                }

                PreparedStatement psDetalle = con.prepareStatement(
                        "INSERT INTO detalle_venta(id_venta, id_producto, cantidad, precio_unitario, subtotal) VALUES(?,?,?,?,?)"
                );

                psDetalle.setInt(1, idVenta);
                psDetalle.setInt(2, idProducto);
                psDetalle.setInt(3, cantidad);
                psDetalle.setDouble(4, precio);
                psDetalle.setDouble(5, subtotal);
                psDetalle.executeUpdate();

                PreparedStatement psStock = con.prepareStatement(
                        "UPDATE producto SET stock = stock - ? WHERE id_producto=?"
                );

                psStock.setInt(1, cantidad);
                psStock.setInt(2, idProducto);
                psStock.executeUpdate();

                rsVenta.close();
                psVenta.close();
                psDetalle.close();
                psStock.close();
                rsProducto.close();
                psProducto.close();
                con.close();

                response.sendRedirect("ticket.jsp?id_venta=" + idVenta);
                return;
            }

            rsProducto.close();
            psProducto.close();
            con.close();

            response.sendRedirect("ventas.jsp?mensaje=error");

        } catch (Exception e) {
            response.getWriter().println("ERROR EN VENTA: " + e.getMessage());
        }
    }
}
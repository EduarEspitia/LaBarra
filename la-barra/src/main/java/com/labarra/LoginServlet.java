package com.labarra;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final String URL =
            "jdbc:mysql://localhost:3306/la_barra";

    private static final String USER =
            "root";

    private static final String PASSWORD =
            "prieto99@";

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD
            );

            String sql =
                    "SELECT * FROM usuario WHERE correo=? AND clave=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, correo);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                request.getSession().setAttribute(
                        "usuario",
                        rs.getString("nombre")
                );

                response.sendRedirect("dashboard.jsp");

            } else {

                response.getWriter().println(
                        "Correo o contraseña incorrectos"
                );
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            response.getWriter().println(
                    "ERROR EN LOGIN: " + e.getMessage()
            );
        }
    }
}
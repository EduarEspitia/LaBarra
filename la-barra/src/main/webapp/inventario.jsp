<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>

<%
    String usuarioSesion = (String) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>

<meta charset="UTF-8">

<title>Inventario | La Barra</title>

<style>

body{
    font-family: Arial, sans-serif;
    background:#f5f5f5;
    padding:30px;
}

.contenedor{
    background:white;
    padding:25px;
    border-radius:10px;
}

h1{
    color:#8B0000;
}

input, select{
    padding:8px;
    margin:5px;
}

button{
    padding:8px 15px;
    background:#8B0000;
    color:white;
    border:none;
    cursor:pointer;
}

table{
    width:100%;
    border-collapse:collapse;
    margin-top:20px;
    background:white;
}

th{
    background:#8B0000;
    color:white;
    padding:10px;
}

td{
    border:1px solid #ccc;
    padding:10px;
    text-align:center;
}

.btn-eliminar{
    background:#333;
}

a{
    color:#8B0000;
    font-weight:bold;
}

.alerta-ok{
    background:#d4edda;
    color:#155724;
    padding:12px;
    margin-bottom:15px;
    border-radius:6px;
    font-weight:bold;
}

.alerta-error{
    background:#f8d7da;
    color:#721c24;
    padding:12px;
    margin-bottom:15px;
    border-radius:6px;
    font-weight:bold;
}

</style>

</head>

<body>

<div class="contenedor">

<h1>Gestión de inventario</h1>

<%
    String mensaje = request.getParameter("mensaje");

    if(mensaje != null){

        if(mensaje.equals("guardado")){
%>

<div class="alerta-ok">
    Movimiento registrado correctamente
</div>

<%
        }

        if(mensaje.equals("stock")){
%>

<div class="alerta-error">
    Stock insuficiente
</div>

<%
        }

        if(mensaje.equals("cantidad")){
%>

<div class="alerta-error">
    La cantidad debe ser mayor a cero
</div>

<%
        }

        if(mensaje.equals("error")){
%>

<div class="alerta-error">
    Error en inventario
</div>

<%
        }
    }
%>

<p>Usuario conectado: <%= usuarioSesion %></p>

<a href="dashboard.jsp">Volver al dashboard</a>

<hr>

<h2>Registrar movimiento</h2>

<form action="InventarioServlet" method="POST">

    <select name="id_producto" required>

        <%
            try {

                Class.forName("com.mysql.cj.jdbc.Driver");

                Connection conProductos = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/la_barra",
                    "root",
                    "prieto99@"
                );

                PreparedStatement psProductos = conProductos.prepareStatement(
                        "SELECT * FROM producto"
                );

                ResultSet rsProductos = psProductos.executeQuery();

                while(rsProductos.next()){
        %>

        <option value="<%= rsProductos.getInt("id_producto") %>">

            <%= rsProductos.getString("nombre") %>
            -
            Stock: <%= rsProductos.getInt("stock") %>

        </option>

        <%
                }

                rsProductos.close();
                psProductos.close();
                conProductos.close();

            } catch(Exception e){

                out.println("Error productos: " + e.getMessage());

            }
        %>

    </select>

    <select name="tipo" required>

        <option value="Entrada">Entrada</option>
        <option value="Salida">Salida</option>

    </select>

    <input type="number"
           name="cantidad"
           placeholder="Cantidad"
           required>

    <button type="submit">
        Guardar
    </button>

</form>

<hr>

<h2>Movimientos registrados</h2>

<table>

<tr>

<th>ID</th>
<th>Producto</th>
<th>Tipo</th>
<th>Cantidad</th>

</tr>

<%
    try {

        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/la_barra",
            "root",
            "prieto99@"
        );

        String sql =
            "SELECT m.id_movimiento, p.nombre, m.tipo, m.cantidad " +
            "FROM movimiento_inventario m " +
            "INNER JOIN producto p ON m.id_producto = p.id_producto";

        PreparedStatement ps = con.prepareStatement(sql);

        ResultSet rs = ps.executeQuery();

        while(rs.next()){
%>

<tr>

<td><%= rs.getInt("id_movimiento") %></td>

<td><%= rs.getString("nombre") %></td>

<td><%= rs.getString("tipo") %></td>

<td><%= rs.getInt("cantidad") %></td>

</tr>

<%
        }

        rs.close();
        ps.close();
        con.close();

    } catch(Exception e){

        out.println("Error: " + e.getMessage());

    }
%>

</table>

</div>

</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>

<%
    String usuario = (String) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("login.html");
        return;
    }

    String idVenta = request.getParameter("id_venta");
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Ticket de venta | La Barra</title>

<style>
body{
    font-family: Arial, sans-serif;
    background:#f4f4f4;
    padding:30px;
}

.ticket{
    width:380px;
    margin:auto;
    background:white;
    padding:25px;
    border-radius:10px;
    box-shadow:0 0 10px rgba(0,0,0,0.2);
}

h1{
    text-align:center;
    color:#8B0000;
}

.linea{
    border-top:1px dashed #333;
    margin:15px 0;
}

p{
    font-size:15px;
}

.total{
    font-size:20px;
    font-weight:bold;
    text-align:right;
}

button, a{
    display:block;
    text-align:center;
    margin-top:15px;
    padding:10px;
    background:#8B0000;
    color:white;
    text-decoration:none;
    border-radius:6px;
    border:none;
    cursor:pointer;
}

@media print{
    button, a{
        display:none;
    }

    body{
        background:white;
    }

    .ticket{
        box-shadow:none;
    }
}
</style>
</head>

<body>

<div class="ticket">

<h1>LA BARRA</h1>
<p style="text-align:center;">Ticket de venta</p>

<div class="linea"></div>

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/la_barra",
        "root",
        "prieto99@"
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT v.id_venta, v.fecha_hora, v.metodo_pago, v.total, " +
        "p.nombre, dv.cantidad, dv.precio_unitario, dv.subtotal " +
        "FROM venta v " +
        "INNER JOIN detalle_venta dv ON v.id_venta = dv.id_venta " +
        "INNER JOIN producto p ON dv.id_producto = p.id_producto " +
        "WHERE v.id_venta = ?"
    );

    ps.setInt(1, Integer.parseInt(idVenta));

    ResultSet rs = ps.executeQuery();

    if(rs.next()){
%>

<p><strong>Venta N°:</strong> <%= rs.getInt("id_venta") %></p>
<p><strong>Fecha:</strong> <%= rs.getString("fecha_hora") %></p>
<p><strong>Producto:</strong> <%= rs.getString("nombre") %></p>
<p><strong>Cantidad:</strong> <%= rs.getInt("cantidad") %></p>
<p><strong>Precio unitario:</strong> $ <%= rs.getDouble("precio_unitario") %></p>
<p><strong>Subtotal:</strong> $ <%= rs.getDouble("subtotal") %></p>
<p><strong>Método de pago:</strong> <%= rs.getString("metodo_pago") %></p>

<div class="linea"></div>

<p class="total">TOTAL: $ <%= rs.getDouble("total") %></p>

<%
    }

    rs.close();
    ps.close();
    con.close();

}catch(Exception e){
    out.println("Error ticket: " + e.getMessage());
}
%>

<button onclick="window.print()">Imprimir ticket</button>

<a href="ventas.jsp">Volver a ventas</a>

</div>

</body>
</html>

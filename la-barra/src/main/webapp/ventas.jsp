<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>

<%
    String usuarioSesion = (String) session.getAttribute("usuario");

    if(usuarioSesion == null){
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

<meta charset="UTF-8">

<title>Ventas | La Barra</title>

<style>

body{
    font-family: Arial, sans-serif;
    background:#f4f4f4;
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
    margin-top:25px;
    border-collapse:collapse;
    background:white;
}

th{
    background:#8B0000;
    color:white;
    padding:10px;
}

td{
    padding:10px;
    border:1px solid #ccc;
    text-align:center;
}

a{
    color:#8B0000;
    font-weight:bold;
}

#buscarVenta{
    width:300px;
    padding:10px;
    margin-bottom:15px;
    border-radius:8px;
    border:1px solid #ccc;
}

.alerta{
    padding:12px;
    margin-bottom:15px;
    border-radius:6px;
    font-weight:bold;
}

.ok{
    background:#d4edda;
    color:#155724;
}

.error{
    background:#f8d7da;
    color:#721c24;
}

</style>

</head>

<body>

<div class="contenedor">

<h1>Gestión de ventas</h1>

<p>Usuario conectado: <%= usuarioSesion %></p>

<a href="dashboard.jsp">Volver al dashboard</a>

<hr>

<%
    String mensaje = request.getParameter("mensaje");

    if(mensaje != null){
%>

<div class="alerta <%= mensaje.equals("error") || mensaje.equals("cantidad") ? "error" : "ok" %>">

<%
        if(mensaje.equals("guardado")){
            out.println("Venta registrada correctamente");
        }

        if(mensaje.equals("error")){
            out.println("Stock insuficiente");
        }

        if(mensaje.equals("cantidad")){
            out.println("La cantidad debe ser mayor a cero");
        }
%>

</div>

<%
    }
%>

<h2>Registrar venta</h2>

<form action="VentaServlet" method="POST">

<select name="id_producto" required>

<%
try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection conProductos = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/la_barra",
        "root",
        "prieto99@"
    );

    PreparedStatement psProductos = conProductos.prepareStatement(
        "SELECT * FROM producto WHERE estado = 1"
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

}catch(Exception e){

    out.println("Error productos: " + e.getMessage());

}
%>

</select>

<input type="number"
       name="cantidad"
       placeholder="Cantidad"
       required>

<select name="metodo_pago">

    <option value="Efectivo">Efectivo</option>
    <option value="Transferencia">Transferencia</option>
    <option value="Tarjeta">Tarjeta</option>

</select>

<button type="submit">
    Vender
</button>

</form>

<hr>

<h2>Ventas registradas</h2>

<input type="text"
       id="buscarVenta"
       placeholder="Buscar venta...">

<table id="tablaVentas">

<tr>

<th>ID Venta</th>
<th>Producto</th>
<th>Cantidad</th>
<th>Precio</th>
<th>Subtotal</th>
<th>Método pago</th>
<th>Fecha</th>

</tr>

<%
try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/la_barra",
        "root",
        "prieto99@"
    );

    String sql =
        "SELECT v.id_venta, p.nombre, dv.cantidad, " +
        "dv.precio_unitario, dv.subtotal, " +
        "v.metodo_pago, v.fecha_hora " +
        "FROM venta v " +
        "INNER JOIN detalle_venta dv ON v.id_venta = dv.id_venta " +
        "INNER JOIN producto p ON dv.id_producto = p.id_producto " +
        "ORDER BY v.id_venta DESC";

    PreparedStatement ps = con.prepareStatement(sql);

    ResultSet rs = ps.executeQuery();

    while(rs.next()){
%>

<tr>

<td><%= rs.getInt("id_venta") %></td>

<td><%= rs.getString("nombre") %></td>

<td><%= rs.getInt("cantidad") %></td>

<td>$ <%= rs.getDouble("precio_unitario") %></td>

<td>$ <%= rs.getDouble("subtotal") %></td>

<td><%= rs.getString("metodo_pago") %></td>

<td><%= rs.getString("fecha_hora") %></td>

</tr>

<%
    }

    rs.close();
    ps.close();
    con.close();

}catch(Exception e){

    out.println("Error ventas: " + e.getMessage());

}
%>

</table>

</div>

<script>

document.getElementById("buscarVenta").addEventListener("keyup", function(){

    let filtro = this.value.toLowerCase();

    let filas = document.querySelectorAll("#tablaVentas tr");

    for(let i = 1; i < filas.length; i++){

        let texto = filas[i].innerText.toLowerCase();

        if(texto.includes(filtro)){
            filas[i].style.display = "";
        }else{
            filas[i].style.display = "none";
        }
    }

});

</script>

</body>
</html>
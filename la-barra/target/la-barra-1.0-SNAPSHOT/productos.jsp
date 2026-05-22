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
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Productos | La Barra</title>

    <style>

        body{
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            padding: 30px;
        }

        h1{
            color: #8B0000;
        }

        .contenedor{
            background: white;
            padding: 25px;
            border-radius: 10px;
        }

        input{
            padding: 8px;
            margin: 5px;
        }

        button{
            padding: 8px 15px;
            background: #8B0000;
            color: white;
            border: none;
            cursor: pointer;
        }

        table{
            width: 100%;
            margin-top: 25px;
            border-collapse: collapse;
            background: white;
        }

        th{
            background: #8B0000;
            color: white;
            padding: 10px;
        }

        td{
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }

        .btn-eliminar{
            background: #333;
        }

        .btn-actualizar{
            background: #b36b00;
        }

        a{
            color: #8B0000;
            font-weight: bold;
        }

        #buscarProducto{
            width: 220px;
            margin-top: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
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

    <h1>Gestión de productos</h1>

    <%
        String mensaje = request.getParameter("mensaje");

        if(mensaje != null){
    %>

    <div class="alerta
        <%= (mensaje.equals("precio")) ? "error" : "ok" %>">

        <%
            if(mensaje.equals("guardado")){
                out.println("Producto guardado correctamente");
            }

            if(mensaje.equals("actualizado")){
                out.println("Producto actualizado correctamente");
            }

            if(mensaje.equals("eliminado")){
                out.println("Producto eliminado correctamente");
            }

            if(mensaje.equals("precio")){
                out.println("El precio debe ser mayor a cero");
            }
        %>

    </div>

    <%
        }
    %>

    <p>Usuario conectado: <%= usuario %></p>

    <a href="dashboard.jsp">Volver al dashboard</a>

    <hr>

    <h2>Registrar producto</h2>

    <form action="ProductoServlet" method="POST">

        <input type="hidden" name="accion" value="guardar">

        <input type="text"
               name="nombre"
               placeholder="Nombre del producto"
               required>

        <input type="number"
               step="0.01"
               name="precio"
               placeholder="Precio"
               required>

        <button type="submit">Guardar</button>

    </form>

    <hr>

    <h2>Productos registrados</h2>

    <input type="text"
           id="buscarProducto"
           placeholder="Buscar producto...">

    <table>

        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Precio</th>
            <th>Estado</th>
            <th>Stock</th>
            <th>Actualizar</th>
            <th>Eliminar</th>
        </tr>

        <%

            try {

                Class.forName("com.mysql.cj.jdbc.Driver");

                Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/la_barra",
                        "root",
                        "prieto99@"
                );

                PreparedStatement ps = con.prepareStatement(
                        "SELECT * FROM producto"
                );

                ResultSet rs = ps.executeQuery();

                while(rs.next()) {

        %>

        <tr>

        <form action="ProductoServlet" method="POST">

            <td>
                <%= rs.getInt("id_producto") %>

                <input type="hidden"
                       name="id_producto"
                       value="<%= rs.getInt("id_producto") %>">
            </td>

            <td>
                <input type="text"
                       name="nombre"
                       value="<%= rs.getString("nombre") %>">
            </td>

            <td>
                <input type="number"
                       step="0.01"
                       name="precio"
                       value="<%= rs.getDouble("precio") %>">
            </td>

            <td>
                <%= rs.getInt("estado") %>
            </td>

            <td>
                <%= rs.getInt("stock") %>
            </td>

            <td>

                <input type="hidden"
                       name="accion"
                       value="actualizar">

                <button type="submit"
                        class="btn-actualizar">

                    Actualizar

                </button>

            </td>

        </form>

            <td>

                <form action="ProductoServlet" method="POST">

                    <input type="hidden"
                           name="accion"
                           value="eliminar">

                    <input type="hidden"
                           name="id_producto"
                           value="<%= rs.getInt("id_producto") %>">

                    <button type="submit"
                            class="btn-eliminar">

                        Eliminar

                    </button>

                </form>

            </td>

        </tr>

        <%

                }

                con.close();

            } catch(Exception e){

                out.println("Error: " + e.getMessage());

            }

        %>

    </table>

</div>

<script>

document.getElementById("buscarProducto").addEventListener("keyup", function () {

    let filtro = this.value.toLowerCase();

    let filas = document.querySelectorAll("table tr");

    filas.forEach((fila, index) => {

        if(index === 0){
            return;
        }

        let columnaNombre = fila.cells[1];

        if(columnaNombre){

            let texto = columnaNombre.textContent.toLowerCase();

            if(texto.includes(filtro)){
                fila.style.display = "";
            } else {
                fila.style.display = "none";
            }

        }

    });

});

</script>

</body>
</html>
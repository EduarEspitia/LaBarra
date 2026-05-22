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
<title>Usuarios | La Barra</title>

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

.btn-eliminar{
    background:#333;
}

.btn-actualizar{
    background:#b36b00;
}

a{
    color:#8B0000;
    font-weight:bold;
}

#buscarUsuario{
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

<h1>Gestión de usuarios</h1>

<%
    String mensaje = request.getParameter("mensaje");

    if(mensaje != null){
%>

<div class="alerta <%= (mensaje.equals("error") || mensaje.equals("campos")) ? "error" : "ok" %>">

<%
        if(mensaje.equals("guardado")){
            out.println("Usuario guardado correctamente");
        }

        if(mensaje.equals("actualizado")){
            out.println("Usuario actualizado correctamente");
        }

        if(mensaje.equals("eliminado")){
            out.println("Usuario eliminado correctamente");
        }

        if(mensaje.equals("campos")){
            out.println("Todos los campos son obligatorios");
        }

        if(mensaje.equals("error")){
            out.println("Ocurrió un error al procesar el usuario");
        }
%>

</div>

<%
    }
%>

<p>Usuario conectado: <%= usuarioSesion %></p>

<a href="dashboard.jsp">Volver al dashboard</a>

<hr>

<h2>Registrar usuario</h2>

<form action="UsuarioServlet" method="POST">

    <input type="hidden" name="accion" value="guardar">

    <input type="text" name="nombre" placeholder="Nombre" required>

    <input type="email" name="correo" placeholder="Correo" required>

    <input type="text" name="clave" placeholder="Clave" required>

    <select name="id_rol" required>
        <option value="1">Administrador</option>
        <option value="2">Mesera</option>
        <option value="3">Bodega</option>
    </select>

    <button type="submit">Guardar</button>

</form>

<hr>

<h2>Usuarios registrados</h2>

<input type="text" id="buscarUsuario" placeholder="Buscar usuario...">

<table id="tablaUsuarios">

<tr>
    <th>ID</th>
    <th>Nombre</th>
    <th>Correo</th>
    <th>Clave</th>
    <th>Estado</th>
    <th>Rol</th>
    <th>Actualizar</th>
    <th>Eliminar</th>
</tr>

<%
try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/la_barra",
        "root",
        "prieto99@"
    );

    PreparedStatement ps = con.prepareStatement("SELECT * FROM usuario");
    ResultSet rs = ps.executeQuery();

    while(rs.next()){
%>

<tr>

<form action="UsuarioServlet" method="POST">

<td>
    <%= rs.getInt("id_usuario") %>
    <input type="hidden" name="id_usuario" value="<%= rs.getInt("id_usuario") %>">
</td>

<td>
    <input type="text" name="nombre" value="<%= rs.getString("nombre") %>">
</td>

<td>
    <input type="email" name="correo" value="<%= rs.getString("correo") %>">
</td>

<td>
    <input type="text" name="clave" value="<%= rs.getString("clave") %>">
</td>

<td>
    <input type="number" name="estado" value="<%= rs.getInt("estado") %>">
</td>

<td>
    <input type="number" name="id_rol" value="<%= rs.getInt("id_rol") %>">
</td>

<td>
    <input type="hidden" name="accion" value="actualizar">
    <button type="submit" class="btn-actualizar">Actualizar</button>
</td>

</form>

<td>
    <form action="UsuarioServlet" method="POST">
        <input type="hidden" name="accion" value="eliminar">
        <input type="hidden" name="id_usuario" value="<%= rs.getInt("id_usuario") %>">
        <button type="submit" class="btn-eliminar">Eliminar</button>
    </form>
</td>

</tr>

<%
    }

    rs.close();
    ps.close();
    con.close();

}catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>

</table>

</div>

<script>
document.getElementById("buscarUsuario").addEventListener("keyup", function () {

    let filtro = this.value.toLowerCase();
    let filas = document.querySelectorAll("#tablaUsuarios tr");

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
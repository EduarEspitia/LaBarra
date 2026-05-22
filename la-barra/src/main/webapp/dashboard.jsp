
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

    int totalProductos = 0;
    int stockTotal = 0;
    int totalVentas = 0;
    double ingresosTotales = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/la_barra",
            "root",
            "prieto99@"
        );

        PreparedStatement ps1 = con.prepareStatement(
            "SELECT COUNT(*) AS total FROM producto WHERE estado=1"
        );
        ResultSet rs1 = ps1.executeQuery();
        if (rs1.next()) totalProductos = rs1.getInt("total");

        PreparedStatement ps2 = con.prepareStatement(
            "SELECT IFNULL(SUM(stock),0) AS total FROM producto WHERE estado=1"
        );
        ResultSet rs2 = ps2.executeQuery();
        if (rs2.next()) stockTotal = rs2.getInt("total");

        PreparedStatement ps3 = con.prepareStatement(
            "SELECT COUNT(*) AS total FROM venta"
        );
        ResultSet rs3 = ps3.executeQuery();
        if (rs3.next()) totalVentas = rs3.getInt("total");

        PreparedStatement ps4 = con.prepareStatement(
            "SELECT IFNULL(SUM(total),0) AS total FROM venta"
        );
        ResultSet rs4 = ps4.executeQuery();
        if (rs4.next()) ingresosTotales = rs4.getDouble("total");

        con.close();

    } catch (Exception e) {
        out.println("Error dashboard: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | La Barra</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body{
            margin:0;
            font-family:Arial, sans-serif;
            background:#111;
            color:white;
        }

        .layout{
            display:flex;
            min-height:100vh;
        }

        .sidebar{
            width:230px;
            background:#1b102b;
            padding:25px;
        }

        .sidebar h2{
            color:#9eefff;
            margin-bottom:5px;
        }

        .sidebar p{
            color:#ddd;
            margin-bottom:35px;
        }

        .sidebar a{
            display:block;
            color:white;
            text-decoration:none;
            padding:13px;
            margin-bottom:10px;
            border-radius:8px;
            background:rgba(255,255,255,0.08);
        }

        .sidebar a:hover,
        .sidebar .active{
            background:linear-gradient(90deg, #ff7b00, #ffcc00);
            color:white;
        }

        .main{
            flex:1;
            padding:35px;
            background:linear-gradient(135deg, #141414, #22152f);
        }

        .topbar{
            background:rgba(255,255,255,0.08);
            padding:25px;
            border-radius:15px;
            margin-bottom:25px;
        }

        .topbar span{
            color:#ffc400;
            font-weight:bold;
        }

        .topbar h1{
            color:#9eefff;
            margin:10px 0;
        }

        .cards{
            display:grid;
            grid-template-columns:repeat(4, 1fr);
            gap:18px;
            margin-bottom:25px;
        }

        .card{
            background:rgba(255,255,255,0.08);
            padding:22px;
            border-radius:15px;
            border:1px solid rgba(255,255,255,0.12);
        }

        .card h3{
            color:#ffc400;
            margin-bottom:10px;
        }

        .card p{
            font-size:24px;
            font-weight:bold;
        }

        .panel{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:20px;
        }

        .box{
            background:rgba(255,255,255,0.08);
            padding:25px;
            border-radius:15px;
            border:1px solid rgba(255,255,255,0.12);
        }

        .box h2{
            color:#9eefff;
        }

        canvas{
            background:white;
            border-radius:10px;
            padding:15px;
        }
    </style>
</head>

<body>

<div class="layout">

    <aside class="sidebar">
        <h2>LA BARRA</h2>
        <p>Panel principal</p>

        <a href="dashboard.jsp" class="active">Inicio</a>
        <a href="ventas.jsp">Ventas</a>
        <a href="inventario.jsp">Inventario y bodega</a>
        <a href="productos.jsp">Productos</a>
        <a href="usuarios.jsp">Usuarios</a>
        <a href="LogoutServlet">Cerrar sesión</a>
    </aside>

    <main class="main">

        <section class="topbar">
            <span>PANEL DE CONTROL</span>
            <h1>Bienvenido al sistema La Barra</h1>
            <p>Usuario conectado: <%= usuario %></p>
            <p>Administra productos, inventario, ventas y usuarios desde un solo lugar.</p>
        </section>

        <section class="cards">

            <div class="card">
                <h3>Productos activos</h3>
                <p><%= totalProductos %></p>
            </div>

            <div class="card">
                <h3>Stock total</h3>
                <p><%= stockTotal %></p>
            </div>

            <div class="card">
                <h3>Ventas registradas</h3>
                <p><%= totalVentas %></p>
            </div>

            <div class="card">
                <h3>Ingresos totales</h3>
                <p>$ <%= ingresosTotales %></p>
            </div>

        </section>

        <section class="panel">

            <div class="box">
                <h2>Resumen gráfico</h2>
                <canvas id="graficaGeneral"></canvas>
            </div>

            <div class="box">
                <h2>Resumen del sistema</h2>
                <p>
                    El sistema La Barra permite controlar productos, stock,
                    movimientos de inventario y ventas registradas en la base de datos.
                </p>

                <p>
                    Los datos mostrados en este panel se cargan directamente desde MySQL
                    mediante JSP, Servlets y JDBC.
                </p>
            </div>

        </section>

    </main>

</div>

<script>
const ctx = document.getElementById('graficaGeneral');

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['Productos activos', 'Stock', 'Ventas'],
        datasets: [{
            label: 'Resumen La Barra',
            data: [
                <%= totalProductos %>,
                <%= stockTotal %>,
                <%= totalVentas %>
            ],
            borderWidth: 1
        }]
    },
    options: {
        responsive: true
    }
});
</script>

</body>
</html>
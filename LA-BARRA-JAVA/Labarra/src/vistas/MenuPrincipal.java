package vistas;

import javax.swing.JButton;
import javax.swing.JFrame;

public class MenuPrincipal extends JFrame {

    JButton btnProductos;
    JButton btnRegistrarProducto;

    public MenuPrincipal() {

        setTitle("Sistema La Barra");
        setSize(500, 400);
        setLayout(null);
        setLocationRelativeTo(null);

        btnProductos = new JButton("Lista de productos");
        btnProductos.setBounds(150, 90, 180, 50);
        add(btnProductos);

        btnRegistrarProducto = new JButton("Registrar producto");
        btnRegistrarProducto.setBounds(150, 160, 180, 50);
        add(btnRegistrarProducto);

        btnProductos.addActionListener(e -> {
            FrmListaProductos ventana = new FrmListaProductos();
            ventana.setVisible(true);
        });

        btnRegistrarProducto.addActionListener(e -> {
            FrmProducto ventana = new FrmProducto();
            ventana.setVisible(true);
        });
    }
}
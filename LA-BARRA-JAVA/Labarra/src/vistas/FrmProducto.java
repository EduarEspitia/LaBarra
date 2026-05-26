package vistas;

import controladores.CtrlProducto;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import modelos.Producto;

public class FrmProducto extends JFrame {

    JTextField txtNombre;
    JTextField txtPrecio;

    JButton btnGuardar;

    public FrmProducto() {

        setTitle("Registro de productos");
        setSize(400, 300);
        setLayout(null);
        setLocationRelativeTo(null);

        JLabel lblNombre = new JLabel("Nombre:");
        lblNombre.setBounds(30, 40, 100, 30);
        add(lblNombre);

        txtNombre = new JTextField();
        txtNombre.setBounds(120, 40, 200, 30);
        add(txtNombre);

        JLabel lblPrecio = new JLabel("Precio:");
        lblPrecio.setBounds(30, 90, 100, 30);
        add(lblPrecio);

        txtPrecio = new JTextField();
        txtPrecio.setBounds(120, 90, 200, 30);
        add(txtPrecio);

        btnGuardar = new JButton("Guardar");
        btnGuardar.setBounds(120, 160, 120, 40);
        add(btnGuardar);

        btnGuardar.addActionListener(e -> {

            try {

                Producto producto = new Producto();

                producto.setNombre(txtNombre.getText());
                producto.setPrecio(Double.parseDouble(txtPrecio.getText()));
                producto.setEstado(1);

                CtrlProducto control = new CtrlProducto();

                if (control.guardar(producto)) {

                    JOptionPane.showMessageDialog(null, "Producto guardado correctamente");

                    txtNombre.setText("");
                    txtPrecio.setText("");

                } else {

                    JOptionPane.showMessageDialog(null, "Error al guardar");

                }

            } catch (Exception ex) {

                JOptionPane.showMessageDialog(null, "Error: " + ex);

            }

        });

    }
}
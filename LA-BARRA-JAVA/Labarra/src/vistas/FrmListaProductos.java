package vistas;

import conexion.Conexion;
import controladores.CtrlProducto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;
import modelos.Producto;

public class FrmListaProductos extends JFrame {

    JTable tabla;
    DefaultTableModel modelo;

    JTextField txtId;
    JTextField txtNombre;
    JTextField txtPrecio;

    JButton btnActualizar;
    JButton btnEliminar;

    public FrmListaProductos() {

        setTitle("Lista de productos");
        setSize(700, 500);
        setLayout(null);
        setLocationRelativeTo(null);

        JLabel lblId = new JLabel("ID:");
        lblId.setBounds(30, 30, 80, 25);
        add(lblId);

        txtId = new JTextField();
        txtId.setBounds(120, 30, 100, 25);
        txtId.setEditable(false);
        add(txtId);

        JLabel lblNombre = new JLabel("Nombre:");
        lblNombre.setBounds(30, 70, 80, 25);
        add(lblNombre);

        txtNombre = new JTextField();
        txtNombre.setBounds(120, 70, 200, 25);
        add(txtNombre);

        JLabel lblPrecio = new JLabel("Precio:");
        lblPrecio.setBounds(30, 110, 80, 25);
        add(lblPrecio);

        txtPrecio = new JTextField();
        txtPrecio.setBounds(120, 110, 200, 25);
        add(txtPrecio);

        btnActualizar = new JButton("Actualizar");
        btnActualizar.setBounds(350, 70, 130, 30);
        add(btnActualizar);

        btnEliminar = new JButton("Eliminar");
        btnEliminar.setBounds(500, 70, 130, 30);
        add(btnEliminar);

        modelo = new DefaultTableModel();

        modelo.addColumn("ID");
        modelo.addColumn("Nombre");
        modelo.addColumn("Precio");
        modelo.addColumn("Estado");

        tabla = new JTable(modelo);

        JScrollPane scroll = new JScrollPane(tabla);
        scroll.setBounds(30, 170, 620, 250);
        add(scroll);

        listarProductos();

        tabla.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {

                int fila = tabla.getSelectedRow();

                txtId.setText(tabla.getValueAt(fila, 0).toString());
                txtNombre.setText(tabla.getValueAt(fila, 1).toString());
                txtPrecio.setText(tabla.getValueAt(fila, 2).toString());

            }
        });

        btnActualizar.addActionListener(e -> actualizarProducto());

        btnEliminar.addActionListener(e -> eliminarProducto());
    }

    public void listarProductos() {

        modelo.setRowCount(0);

        try {

            Conexion objetoConexion = new Conexion();
            Connection cn = objetoConexion.establecerConexion();

            PreparedStatement consulta = cn.prepareStatement("SELECT * FROM producto");

            ResultSet resultado = consulta.executeQuery();

            while (resultado.next()) {

                Object[] fila = new Object[4];

                fila[0] = resultado.getInt("id_producto");
                fila[1] = resultado.getString("nombre");
                fila[2] = resultado.getDouble("precio");
                fila[3] = resultado.getInt("estado");

                modelo.addRow(fila);
            }

            cn.close();

        } catch (Exception e) {

            JOptionPane.showMessageDialog(null, "Error al listar productos: " + e);

        }
    }

    public void actualizarProducto() {

        if (txtId.getText().isEmpty()) {

            JOptionPane.showMessageDialog(null, "Seleccione un producto de la tabla");
            return;

        }

        try {

            Producto producto = new Producto();

            producto.setId_producto(Integer.parseInt(txtId.getText()));
            producto.setNombre(txtNombre.getText());
            producto.setPrecio(Double.parseDouble(txtPrecio.getText()));
            producto.setEstado(1);

            CtrlProducto control = new CtrlProducto();

            if (control.actualizar(producto)) {

                JOptionPane.showMessageDialog(null, "Producto actualizado correctamente");

                limpiarCampos();
                listarProductos();

            } else {

                JOptionPane.showMessageDialog(null, "No se pudo actualizar el producto");

            }

        } catch (Exception e) {

            JOptionPane.showMessageDialog(null, "Error al actualizar: " + e);

        }
    }

    public void eliminarProducto() {

        if (txtId.getText().isEmpty()) {

            JOptionPane.showMessageDialog(null, "Seleccione un producto de la tabla");
            return;

        }

        int confirmacion = JOptionPane.showConfirmDialog(
                null,
                "¿Está seguro de eliminar este producto?",
                "Confirmar eliminación",
                JOptionPane.YES_NO_OPTION
        );

        if (confirmacion == JOptionPane.YES_OPTION) {

            int idProducto = Integer.parseInt(txtId.getText());

            CtrlProducto control = new CtrlProducto();

            if (control.eliminar(idProducto)) {

                JOptionPane.showMessageDialog(null, "Producto eliminado correctamente");

                limpiarCampos();
                listarProductos();

            } else {

                JOptionPane.showMessageDialog(null, "No se pudo eliminar el producto");

            }
        }
    }

    public void limpiarCampos() {

        txtId.setText("");
        txtNombre.setText("");
        txtPrecio.setText("");

    }
}
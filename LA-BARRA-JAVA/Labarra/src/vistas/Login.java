package vistas;

import conexion.Conexion;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPasswordField;
import javax.swing.JTextField;

public class Login extends JFrame {

    JLabel titulo;
    JLabel correo;
    JLabel clave;

    JTextField txtCorreo;
    JPasswordField txtClave;

    JButton btnIngresar;

    public Login() {

        setTitle("La Barra - Login");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(null);

        titulo = new JLabel("INICIO DE SESIÓN");
        titulo.setBounds(120, 20, 200, 30);
        add(titulo);

        correo = new JLabel("Correo:");
        correo.setBounds(50, 80, 100, 30);
        add(correo);

        txtCorreo = new JTextField();
        txtCorreo.setBounds(130, 80, 180, 30);
        add(txtCorreo);

        clave = new JLabel("Contraseña:");
        clave.setBounds(50, 130, 100, 30);
        add(clave);

        txtClave = new JPasswordField();
        txtClave.setBounds(130, 130, 180, 30);
        add(txtClave);

        btnIngresar = new JButton("Ingresar");
        btnIngresar.setBounds(130, 190, 120, 35);
        add(btnIngresar);

        btnIngresar.addActionListener(new ActionListener() {

            public void actionPerformed(ActionEvent e) {

                validarLogin();

            }

        });

    }

    public void validarLogin() {

        String correoIngresado = txtCorreo.getText().trim();

        String claveIngresada = String.valueOf(txtClave.getPassword()).trim();

        Conexion objetoConexion = new Conexion();

        Connection conexion = objetoConexion.establecerConexion();

        try {

            String sql = "SELECT * FROM usuario WHERE correo = ? AND clave = ? AND estado = 1";

            PreparedStatement ps = conexion.prepareStatement(sql);

            ps.setString(1, correoIngresado);

            ps.setString(2, claveIngresada);

            ResultSet resultado = ps.executeQuery();

            if (resultado.next()) {

                JOptionPane.showMessageDialog(null, "Bienvenido al sistema La Barra");

                MenuPrincipal menu = new MenuPrincipal();
                menu.setVisible(true);

                this.dispose();

            } else {

                JOptionPane.showMessageDialog(null, "Correo o contraseña incorrectos");

            }

        } catch (Exception error) {

            JOptionPane.showMessageDialog(null, "Error: " + error.toString());

        }

    }

}
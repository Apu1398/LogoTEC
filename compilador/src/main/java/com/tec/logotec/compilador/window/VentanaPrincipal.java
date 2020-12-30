package com.tec.logotec.compilador.window;


import javax.swing.JFrame;

import org.antlr.v4.runtime.ANTLRErrorListener;
import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;

import com.tec.logotec.compilador.turtle.World;
import com.tec.logotec.compilador.LogoTecCustomVisitor;
import com.tec.logotec.compilador.LogoTecLexer;
import com.tec.logotec.compilador.LogoTecParser;
import com.tec.logotec.compilador.turtle.Turtle;

import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.io.FileWriter;
import java.io.IOException;
import java.awt.event.ActionEvent;
import javax.swing.JSeparator;
import java.awt.TextArea;
import javax.swing.JLabel;
import java.awt.Font;
import javax.swing.SwingConstants;
import java.awt.Color;

public class VentanaPrincipal {

	public JFrame frmLogotec;
	private TextArea consoleOutputComponent, codeEditingComponent;
	
	private World theWorld;
	private Turtle theTurtle;

	/**
	 * Launch the application.
	 */
	

	/**
	 * Create the application.
	 */
	public VentanaPrincipal() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frmLogotec = new JFrame();
		frmLogotec.setTitle("LogoTec");
		frmLogotec.setBounds(100, 100, 1179, 673);
		frmLogotec.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frmLogotec.getContentPane().setLayout(null);
		
		JButton btnCompilar = new JButton("Compilar");
		btnCompilar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					compilar();
				} catch (IOException e1) {
					e1.printStackTrace();
				}				
			}
		});
		btnCompilar.setBounds(10, 307, 89, 23);
		frmLogotec.getContentPane().add(btnCompilar);
		
		JButton btnEjecutar = new JButton("Ejecutar");
		btnEjecutar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					ejecutar();
				} catch (IOException e1) {
				e1.printStackTrace();
				}
			}
		});
		
		btnEjecutar.setBounds(109, 307, 89, 23);
		frmLogotec.getContentPane().add(btnEjecutar);
		
		JSeparator separator = new JSeparator();
		separator.setBounds(10, 341, 528, 2);
		frmLogotec.getContentPane().add(separator);
		
		TextArea txtCodigo = new TextArea();
		txtCodigo.setFont(new Font("Calibri", Font.PLAIN, 13));
		txtCodigo.setText("define miprograma(){\r\n\r\n\r\n}");
		codeEditingComponent = txtCodigo;
		txtCodigo.setBounds(10, 10, 516, 291);
		frmLogotec.getContentPane().add(txtCodigo);
		
		TextArea txtConsola = new TextArea();
		consoleOutputComponent = txtConsola;
		txtConsola.setEditable(false);
		txtConsola.setBounds(10, 371, 516, 263);
		frmLogotec.getContentPane().add(txtConsola);
		
		JLabel lblNewLabel = new JLabel("Consola");
		lblNewLabel.setBounds(10, 354, 46, 14);
		frmLogotec.getContentPane().add(lblNewLabel);
		
		JSeparator separator_1 = new JSeparator();
		separator_1.setOrientation(SwingConstants.VERTICAL);
		separator_1.setBounds(539, 0, 10, 634);
		frmLogotec.getContentPane().add(separator_1);
		
		//Se añade el panel de tortuga
		
		theWorld = new World();
	    theWorld.setLocation(550,0);
		theTurtle = new Turtle(theWorld);
		frmLogotec.getContentPane().add(theWorld);
		
		
		 
		 
	}
	
	private void compilar() throws IOException {

		//theWorld.eraseGround();
		//frmLogotec.repaint();
	}
	
	private void ejecutar() throws IOException{
		
		Color color = new Color(0,255,0);
		consoleOutputComponent.setText("");
		theTurtle.setColor(color);
		
		FileWriter myWriter = new FileWriter("input.smp");
	    myWriter.write(codeEditingComponent.getText());
	    myWriter.close();
		
		String program =  "input.smp";


		LogoTecLexer lexer = new LogoTecLexer(new ANTLRFileStream(program));
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		LogoTecParser parser = new LogoTecParser(tokens,consoleOutputComponent, true, theTurtle);
		parser.removeErrorListeners();
		
	    ANTLRErrorListener errorListener = new ErrorListener(consoleOutputComponent);
		parser.addErrorListener(errorListener);

		LogoTecParser.ProgramContext tree = parser.program();
		LogoTecCustomVisitor visitor = new LogoTecCustomVisitor();
		visitor.visit(tree);		
	}
}

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

import java.awt.Color;
import java.awt.Font;
import javax.swing.SwingConstants;

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
		frmLogotec.setBounds(0, 0, 1350, 730);
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
		btnCompilar.setBounds(10, 442, 89, 23);
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
		
		btnEjecutar.setBounds(109, 442, 89, 23);
		frmLogotec.getContentPane().add(btnEjecutar);
		
		JSeparator separator = new JSeparator();
		separator.setBounds(10, 476, 528, 2);
		frmLogotec.getContentPane().add(separator);
		
		TextArea txtCodigo = new TextArea();
		txtCodigo.setFont(new Font("Calibri", Font.PLAIN, 13));
		txtCodigo.setText("//Esto es un comentario");
		codeEditingComponent = txtCodigo;
		txtCodigo.setBounds(10, 10, 516, 426);
		frmLogotec.getContentPane().add(txtCodigo);
		
		TextArea txtConsola = new TextArea();
		consoleOutputComponent = txtConsola;
		txtConsola.setEditable(false);
		txtConsola.setBounds(10, 512, 516, 168);
		frmLogotec.getContentPane().add(txtConsola);
		
		JLabel lblNewLabel = new JLabel("Consola");
		lblNewLabel.setBounds(10, 492, 46, 14);
		frmLogotec.getContentPane().add(lblNewLabel);
		
		JSeparator separator_1 = new JSeparator();
		separator_1.setOrientation(SwingConstants.VERTICAL);
		separator_1.setBounds(539, 11, 10, 669);
		frmLogotec.getContentPane().add(separator_1);
		
		//Se añade el panel de tortuga
		
		theWorld = new World(774,680, new Color(255,255,255));
		theWorld.setSize(774, 680);
	    theWorld.setLocation(550,0);
		theTurtle = new Turtle(theWorld);
		frmLogotec.getContentPane().add(theWorld);	 
		 
	}
	
	private void compilar() throws IOException {
		
		consoleOutputComponent.setText("");
		CompilerState.dontDoNothing();
		CompilerState.clearErrors();
		doMagic();
		
		if(CompilerState.getCompilerStatus()) {
			consoleOutputComponent.setText( consoleOutputComponent.getText() + "Compiled succesful");
		}
		
	}
	
	private void ejecutar() throws IOException{
		
		consoleOutputComponent.setText("");
		CompilerState.doSome();
		CompilerState.clearErrors();
		doMagic();
		
		if(CompilerState.getCompilerStatus()) {
			consoleOutputComponent.setText( consoleOutputComponent.getText() + "Compiled succesful");
		}
	}
	
	private void doMagic() throws IOException {
		FileWriter myWriter = new FileWriter("input.smp");
	    myWriter.write(codeEditingComponent.getText());
	    myWriter.close();
		
		String program =  "input.smp";


		LogoTecLexer lexer = new LogoTecLexer(new ANTLRFileStream(program));
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		LogoTecParser parser = new LogoTecParser(tokens,consoleOutputComponent, theTurtle, theWorld);
		//LogoTecParser parser = new LogoTecParser(tokens);
		parser.removeErrorListeners();
		
	    ANTLRErrorListener errorListener = new ErrorListener(consoleOutputComponent);
		parser.addErrorListener(errorListener);

		LogoTecParser.ProgramContext tree = parser.program();
		LogoTecCustomVisitor visitor = new LogoTecCustomVisitor();
		System.out.println(tree.toStringTree(parser));
		visitor.visit(tree);
		
	}
}

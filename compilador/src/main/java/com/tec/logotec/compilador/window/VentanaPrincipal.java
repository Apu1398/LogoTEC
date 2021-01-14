package com.tec.logotec.compilador.window;


import javax.swing.JFrame;

import org.antlr.v4.runtime.ANTLRErrorListener;
import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;

import com.tec.logotec.compilador.turtle.World;
import com.tec.logotec.compilador.window.ASTVisualizer.ASTVNode;
import com.tec.logotec.compilador.LogoTecCustomVisitor;
import com.tec.logotec.compilador.LogoTecLexer;
import com.tec.logotec.compilador.LogoTecParser;
import com.tec.logotec.compilador.turtle.Turtle;



import javax.swing.JButton;
import javax.swing.JFileChooser;

import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.awt.event.ActionEvent;
import javax.swing.JSeparator;
import java.awt.TextArea;
import javax.swing.JLabel;

import java.awt.Color;
import java.awt.Font;
import javax.swing.SwingConstants;
import javax.swing.filechooser.FileNameExtensionFilter;



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
		frmLogotec.setBounds(1400, 0, 1350, 730);
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
		
		JButton btnAbrir = new JButton("Abrir");
		btnAbrir.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				
				try {
				
				JFileChooser selectorArchivos = new JFileChooser();
				selectorArchivos.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
				
				FileNameExtensionFilter filtro = new FileNameExtensionFilter("Archivos LOGO", "logo");
				selectorArchivos.setFileFilter(filtro);
				
				selectorArchivos.setCurrentDirectory(new File("C:\\Users\\jp139\\Desktop\\Codigos Logo"));
				
				selectorArchivos.showOpenDialog(frmLogotec);
				
				File archivo = selectorArchivos.getSelectedFile();
								 
				String cadena;
		        FileReader f = new FileReader(archivo);
		        BufferedReader b = new BufferedReader(f);
		        codeEditingComponent.setText("");
		        while((cadena = b.readLine())!=null) {
		            codeEditingComponent.setText(codeEditingComponent.getText() +  cadena + "\n");
		        }
		        b.close();				
			}catch (Exception a) {
				consoleOutputComponent.setText("No se cargo ningun archivo");
			}
				}
			});
		btnAbrir.setBounds(437, 442, 89, 23);
		frmLogotec.getContentPane().add(btnAbrir);
		 
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
	
	private void makeTree(LogoTecParser.ProgramContext tree, LogoTecParser parser) {
				
		
		if(CompilerState.getCompilerStatus()) {
			
			
			int childs = tree.getChildCount();
			
			List<ASTVNode> arbol = new ArrayList<ASTVNode>();
			
			
			
			for(int a = 0; a< childs; a++) {
				
				arbol.add(new ASTVNode(tree.getChild(a).getClass().getSimpleName()));		
				makeTreeAux(tree.getChild(a), parser, arbol.get(a));				
			}
			
			
			//System.out.println(arbol.get(1).childs.get(0).childs.get(0).childs.get(1).childs.get(0).childs.get(0).childs.get(0).value);
			
		}
		
	}
	
	private void makeTreeAux(ParseTree child, LogoTecParser parser, ASTVNode parent) {
		
		if(child.getChildCount() == 0) {
			
			parent.addChild(new ASTVNode(child.toStringTree(parser)));			

		}
		else {
			for(int a  = 0; a< child.getChildCount(); a ++ ) {
				ASTVNode tmp = null;
				if (!child.getChild(a).getClass().getSimpleName().equals("TerminalNodeImpl")) {
					tmp = new ASTVNode(child.getChild(a).getClass().getSimpleName().replace("Context", ""));
					parent.addChild(tmp);
					makeTreeAux(child.getChild(a),parser, tmp);
					}
				else {
					makeTreeAux(child.getChild(a),parser, parent);
					}
				}
			}
		}
	
	private void doMagic() throws IOException {
		FileWriter myWriter = new FileWriter("input.smp");
	    myWriter.write(codeEditingComponent.getText());
	    myWriter.close();
		
		String program =  "input.smp";
		
		
		theTurtle.putPenDown();
		theTurtle.setShellSize(8);


		LogoTecLexer lexer = new LogoTecLexer(new ANTLRFileStream(program));
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		LogoTecParser parser = new LogoTecParser(tokens,consoleOutputComponent, theTurtle, theWorld);
		//LogoTecParser parser = new LogoTecParser(tokens);
		parser.removeErrorListeners();
		
	    ANTLRErrorListener errorListener = new ErrorListener(consoleOutputComponent);
		parser.addErrorListener(errorListener);

		LogoTecParser.ProgramContext tree = parser.program();
		LogoTecCustomVisitor visitor = new LogoTecCustomVisitor();	
		
		visitor.visit(tree);
			
		//makeTree(tree,parser);	
		
		
		
		
	}
}

package com.tec.logotec.compilador.window;


import javax.swing.JFrame;

import org.antlr.v4.runtime.ANTLRErrorListener;
import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;

import com.tec.logotec.compilador.turtle.World;
import com.tec.logotec.compilador.LogoTecCustomVisitor;
import com.tec.logotec.compilador.LogoTecLexer;
import com.tec.logotec.compilador.LogoTecParser;
import com.tec.logotec.compilador.turtle.Turtle;

import javax.imageio.ImageIO;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;

import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.awt.event.ActionEvent;
import javax.swing.JSeparator;
import javax.swing.JTree;

import java.awt.TextArea;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.Font;
import javax.swing.SwingConstants;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.tree.DefaultMutableTreeNode;
import java.awt.ScrollPane;



public class VentanaPrincipal {

	public JFrame frmLogotec;
	private TextArea consoleOutputComponent, codeEditingComponent;
	
	private World theWorld;
	private Turtle theTurtle;
	
	private JDialog dialog;
	private JLabel lblAST;
	private JScrollPane jsp;
	
	
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
				
		JButton btnCompilar = new JButton("Compile");
		btnCompilar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					compilar();
				} catch (IOException e1) {
					e1.printStackTrace();
				}				
			}
		});
		
		btnCompilar.setBounds(10, 442, 101, 23);
		frmLogotec.getContentPane().add(btnCompilar);
		
		JButton btnEjecutar = new JButton("Run");
		btnEjecutar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					ejecutar();
				} catch (IOException e1) {
				e1.printStackTrace();
				}
			}
		});
		
		btnEjecutar.setBounds(121, 442, 59, 23);
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
		
		JLabel lblNewLabel = new JLabel("Console");
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
		
		JButton btnAbrir = new JButton("Open");
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
		btnAbrir.setBounds(457, 442, 69, 23);
		frmLogotec.getContentPane().add(btnAbrir);
		
		JButton btnASTVisualizer = new JButton("AST");
		btnASTVisualizer.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {				
				showAST();
			}
		});
		btnASTVisualizer.setBounds(190, 442, 59, 23);
		frmLogotec.getContentPane().add(btnASTVisualizer);
		 
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
	private void showAST() {
		if(CompilerState.getCompilerStatus()) {
			
BufferedImage img = null;
			
			try {
				img = ImageIO.read(new File("out.png"));
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			if (dialog == null) {
				dialog = new JDialog(frmLogotec);
				dialog.setBounds(200, 200, 600, 600);
				dialog.setDefaultCloseOperation(JDialog.HIDE_ON_CLOSE);
				dialog.getContentPane().setLayout(new BorderLayout(0, 0));
				lblAST = new JLabel(new ImageIcon(img), JLabel.CENTER);
				jsp = new JScrollPane(lblAST);
	            dialog.getContentPane().add(jsp, BorderLayout.CENTER);
			}			
			lblAST.setIcon(new ImageIcon(img));
			      
            
			lblAST.revalidate();
	        lblAST.repaint();
	        lblAST.update(lblAST.getGraphics());
            
            

            jsp.setViewportView(lblAST);
            
            dialog.revalidate();
	        dialog.repaint();
	        dialog.update(dialog.getGraphics());
	        
            dialog.setVisible(true);            
            
            
			
			
		}else{
			JOptionPane.showMessageDialog(frmLogotec, "El último codigo no ha compilado o tiene errores", "No se puede mostrar", JOptionPane.ERROR_MESSAGE);
		}
		
		
	}
	private void makeTree(LogoTecParser.ProgramContext tree, LogoTecParser parser) {
				
		
		if(CompilerState.getCompilerStatus()) {
			
			
			int childs = tree.getChildCount();
			
			
			GraphViz gv = new GraphViz();
			gv.addln(gv.start_graph());
				
			for(Integer a = 0; a< childs; a++) {
				
				gv.addln(a+ "[label = " + tree.getChild(a).getClass().getSimpleName().replace("Context", "") + "];");
				
				gv.addln("Program -> " + a + ";");
				
										
				makeTreeAux(tree.getChild(a), parser,gv,  a.toString());				
			}
						
			gv.addln(gv.end_graph());
			String type = "png";
			File out = new File("out." + type);
			gv.writeGraphToFile( gv.getGraph( gv.getDotSource(), type ), out );		
			
		}
		
	}
	
	private void makeTreeAux(ParseTree child, LogoTecParser parser, GraphViz gv, String parent) {

		if (child.getChildCount() > 0) {
			for (Integer a = 0; a < child.getChildCount(); a++) {
				String id = parent + a.toString();
				if (!child.getChild(a).getClass().getSimpleName().equals("TerminalNodeImpl")) {
					gv.addln(id + "[label =" + child.getChild(a).getClass().getSimpleName().replace("Context", "")
							+ "];");
					gv.addln(parent + "->" + id + ";");

					makeTreeAux(child.getChild(a), parser, gv, id);
				} else {
					makeTerminalNode(child.getChild(a).toStringTree(parser).toString(), gv, parent, id);
				}
			}
		}
	}
	
	public void makeTerminalNode(String terminal, GraphViz gv, String parent, String id) {

			Boolean bool = (terminal.equals("[") | terminal.equals("]") | terminal.equals("(") | terminal.equals(")"));

			if (!bool) {

				switch (terminal) {
				case "+":
					terminal = "mas";
					break;
				case "-":
					terminal = "menos";
					break;
				case "/":
					terminal = "entre";
					break;
				case "*":
					terminal = "por";
					break;

				}

				String tmp = terminal.replace("//", "").replace("/*", "").replace("/*", "").replace(" ", "_");
				gv.addln(id + " [label = " + tmp + "];");
				gv.addln(parent + " -> " + id + ";");

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
		parser.removeErrorListeners();
		
	    ANTLRErrorListener errorListener = new ErrorListener(consoleOutputComponent);
		parser.addErrorListener(errorListener);

		LogoTecParser.ProgramContext tree = parser.program();
		LogoTecCustomVisitor visitor = new LogoTecCustomVisitor();	
		
		visitor.visit(tree);
			
		makeTree(tree,parser);			
		
	}
}

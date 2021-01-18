package com.tec.logotec.compilador.ast;

import java.awt.TextArea;

import com.tec.logotec.compilador.window.CompilerState;

public class VarAssignment implements ASTNode {

	private String name;
	private ASTNode expression;
	private TextArea console;
	private int line;
	
	
	
	public VarAssignment(String name, ASTNode expression, TextArea console, int line) {
		super();
		this.name = name;
		this.expression = expression;
		this.console = console;
		this.line = line;
	}



	@Override
	public Object execute(Context symbolTable) {
		Object data = expression.execute(symbolTable);
		
		if(symbolTable.get(name).getClass().equals(data.getClass())) {

			symbolTable.put(name, data);
		}
		
		else {
			CompilerState.errorDetected();
			console.setText(console.getText() + "Line " + line + ": You con not use " + name + " as " + data.getClass().getName().replace("java.lang.", "") + " because it was declared as " + symbolTable.get(name).getClass().getName().replace("java.lang.", ""));
		}
		return null;
	}

}

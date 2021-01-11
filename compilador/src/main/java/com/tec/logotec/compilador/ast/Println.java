package com.tec.logotec.compilador.ast;

import java.awt.TextArea;

import com.tec.logotec.compilador.window.CompilerState;

public class Println implements ASTNode {

	private ASTNode data;
	private TextArea console;
	
	public Println(ASTNode data, TextArea console) {
		super();
		this.data = data;
		this.console = console;
	}

	@Override
	public Object execute(Context symbolTable) {
		Object msg = data.execute(symbolTable);
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			this.console.setText(this.console.getText() + msg + "\n");
		}	
		return null;
	}

}
